//
//  AnimatedSpriteNode.m
//
//  Created by Alec Tyre on 3/8/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import "AnimatedSpriteNode.h"


typedef void(^block)(void);

@interface AnimatedSpriteNode ()
{
    block animationBeginBlock;
    block animationCompleteBlock;
}

@property SKTextureAtlas *textureAtlas;
@property NSArray *textures;

@property (nonatomic, copy) block animationBeginBlock;
@property (nonatomic, copy) block animationCompleteBlock;

@property NSMutableArray* animationChildren;

@property SKShapeNode* shapeNode;

@end


@implementation AnimatedSpriteNode


static BOOL debugMode;

@synthesize animationBeginBlock;
@synthesize animationCompleteBlock;


-(id)initBlackNodeWithPath:(CGPathRef) path {
    self = (AnimatedSpriteNode*)[super init];
    
    if(self) {
        _shapeNode = [SKShapeNode node];
        _shapeNode.path = path;
        _shapeNode.strokeColor = [UIColor clearColor];
        
        [self addChild: _shapeNode];
        
        animationBeginBlock = ^{};
        animationCompleteBlock = ^{};
        _animationChildren = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
        _waitForAnimationChildren = YES;
        if(debugMode == YES)
        {
            [self DebugMode];
        }

    }
    
    return self;
}

-(id)initBlankNodeWithSize:(CGSize)size {
    self = (AnimatedSpriteNode*)[super initWithColor:[UIColor clearColor] size:size];
    
    //If we exist, set properties to initial states
    if(self)
    {
        animationBeginBlock = ^{};
        animationCompleteBlock = ^{};
        _animationChildren = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
        _waitForAnimationChildren = YES;
        if(debugMode == YES)
        {
            [self DebugMode];
        }
    }
    
    return self;
}

-(id)initWithTextureAtlasNamed: (NSString *) textureAtlasName {
    //Get ze textureAtlas, if you can
    SKTextureAtlas *textureAtlas;
    
    @try {
        textureAtlas = [SKTextureAtlas atlasNamed: textureAtlasName];
    }
    @catch (NSException *exception) {
        NSLog(@"Error loading texture atlas: %@", [exception reason]);
    }
    
    //init the texture array
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    //Make an array to temporarily hold names of all the textures in the textureAtlas
    NSArray *textureNames = [textureAtlas textureNames];
    
    //Sort texture names
    textureNames = [textureNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //TEST THIS
    /*
    self = [[AnimatedSpriteNode alloc] init];
    self.texture =
    */
    
    //Use texture names to load textures into texture array
    for ( int i = 0; i < [textureNames count]; i++ ) {
        [textures addObject: [textureAtlas textureNamed:[textureNames objectAtIndex: i]]];
    }
    
    //Initialize with the first texture in the texture array
    self = (AnimatedSpriteNode *)[super initWithTexture: textures[0]];
    
    //If we exist, set properties to initial states
    if(self)
    {
        _textureAtlas = textureAtlas;
        _textures = textures;
        animationBeginBlock = ^{};
        animationCompleteBlock = ^{};
        _animationChildren = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = NO;
        _waitForAnimationChildren = YES;
        if(debugMode == YES)
        {
            [self DebugMode];
        }
    }
    
    return self;
}

-(id)initWithTexturesNamed:(NSString *)textureBaseName WithNumberOfTextures:(int)numberOfTextures withType:(NSString *)fileType {
    //init the texture array
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
   
    for (int i = 0; i < numberOfTextures; i++) {
        NSString* textureNumber = [NSString stringWithFormat: @"%02d.", i];
        NSMutableString* textureName = [[NSMutableString alloc] init];
        [textureName appendString:textureBaseName];
        [textureName appendString:textureNumber];
        [textureName appendString:fileType];
       // NSLog(@"%@", textureName);
        [textures addObject: [self getTextureWithName:textureName]];
    }
    
    //Initialize with the first texture in the texture array
    self = (AnimatedSpriteNode *)[super initWithTexture:textures[0]];
    
    //If we exist, set properties to initial states
    if(self)
    {
        self.texture = textures[0];
        self.textures = textures;
        animationBeginBlock = ^{};
        animationCompleteBlock = ^{};
        self.animationChildren = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = NO;
        _waitForAnimationChildren = YES;
        if(debugMode == YES)
        {
            [self DebugMode];
        }
    }
    
    return self;
}

-(SKTexture*)getTextureWithName:(NSString*)name {
    UIImage* image = [UIImage imageNamed:name];
    return [SKTexture textureWithImage:image];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.shapeNode) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        if(CGPathContainsPoint(self.shapeNode.path, NULL, touchLocation, true)) {
            [self animate];
        }
    }
    
    [self animate];
}

-(void)animate
{
    //If waitForAnimationChildren is YES
    if(_waitForAnimationChildren)
    {
        //Check each animationChild
        for (AnimatedSpriteNode* animationChild in _animationChildren) {
            //If any animationChild is still animating, stop!
            if (animationChild.hasActions) {
                return;
            }
        }
    }
    
    if(!self.hasActions)
    {
        animationBeginBlock();
        
        //If there are textures, animate with them, and call animationCompleteBlock when finished
        if (self.textures)
        {
            SKAction *animate = [SKAction animateWithTextures: self.textures timePerFrame: 0.04];
            [self runAction: animate completion:
             ^{
                animationCompleteBlock();
                 
                 if(_fadeOutDuration > 0) {
                     [self fadeOutAndReset];
                 }
            }];
            
            if(self.isReversible)
            {
                self.textures = [self reverseArray: self.textures];
            }
        }
        //Otherwise, immediately call animationComplete block
        else
        {
            animationCompleteBlock();
        }
        
        [self animateChildren];
    }
}


-(void)setAnimationBeginBlock:(void (^)(void))block
{
    animationBeginBlock = block;
}


-(void)setAnimationCompleteBlock:(void (^)(void))block
{
    animationCompleteBlock = block;
}

-(void)animateChildren {
    
    for (AnimatedSpriteNode* node in _animationChildren)
    {
        if ([node isKindOfClass:[AnimatedSpriteNode class]])
        {
            [node animate];
        }
    }
}

-(void)addAnimationChild:(AnimatedSpriteNode *)child {
    [_animationChildren addObject:child];
}

-(void)fadeOutAndReset {
    SKAction* fadeOutAction = [SKAction fadeOutWithDuration: _fadeOutDuration];
    [self runAction:fadeOutAction completion:^{
        self.texture = self.textures[0];
        self.alpha = 1;
    }];
}

-(NSArray *)reverseArray: (NSArray *) array {
    NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    for (id element in enumerator) {
        [reversedArray addObject:element];
    }
    
    return reversedArray;
}

/// DEBUG FUNCTIONS ////////////////////////////////////

-(void)drawPointAtOrigin {
    SKSpriteNode* dot = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(3, 3)];
    [self addChild:dot];
}

-(void)drawOutlineWithWidth:(float)outlineWidth {
    if(self.shapeNode) {
        self.shapeNode.fillColor = [UIColor redColor];
        self.shapeNode.alpha = 0.2;
    }
    else if(self.textures ) {
        CGRect outlineRect = CGRectMake(-self.size.width*self.anchorPoint.x, -self.size.height*self.anchorPoint.y, self.size.width, self.size.height);
        
        CGPathRef outlinePath = CGPathCreateWithRect(outlineRect, NULL);
        
        SKShapeNode* outlineNode = [SKShapeNode node];
        outlineNode.path = outlinePath;
        outlineNode.strokeColor = [UIColor greenColor];
        outlineNode.lineWidth = outlineWidth;
        
        [self addChild: outlineNode];
    }
    else
    {
        self.alpha = 0.2;
        self.color = [UIColor redColor];
    }
}

-(void)debug {
    
    [self drawOutlineWithWidth:1];
    [self drawPointAtOrigin];
}

-(void)DebugMode {
    [self debug];
}

+(void)DebugMode {
    debugMode = YES;
}

/// DEBUG FUNCTIONS ////////////////////////////////////


@end
