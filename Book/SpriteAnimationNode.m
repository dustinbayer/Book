//
//  SpriteAnimationNode.m
//  Book
//
//  Created by Alec Tyre on 9/19/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import "SpriteAnimationNode.h"
#import <SpriteKit/SpriteKit.h>

@interface SpriteAnimationNode()
{
    int frame;
    float secondsPerFrame;
    float secondsUntilNextFrame;
}

@property NSArray* textureNames;

@property SKSpriteNode* spriteNode;

@end

@implementation SpriteAnimationNode

@synthesize size = _size;
@synthesize anchorPoint = _anchorPoint;


-(id)initWithTexturesNamed:(NSString *)textureBaseName WithNumberOfTextures:(int)numberOfTextures withType:(NSString *)fileType {

    NSMutableArray* textureNames = [NSMutableArray array];
    
    NSMutableString* baseName = [NSMutableString string];
    [baseName appendString: textureBaseName];
    [baseName appendString: @"%02d."];
    [baseName appendString: fileType];
    
    for (int i = 0; i < numberOfTextures; i++) {
        NSString* textureName = [NSString stringWithFormat: baseName, i];
        
        [textureNames addObject: textureName];        
    }
    
    //Initialize with the first texture in the texture array
    self = (SpriteAnimationNode *)[super init];
    
    //If we exist, set properties to initial states
    if(self)
    {
        //NOTE: [super init] already initialized all AnimationNode defaults
        
        _spriteNode = [[SKSpriteNode alloc] initWithTexture:[self getTextureWithName:textureNames[0]]];
        
        _textureNames = [NSArray arrayWithArray:textureNames];
        
        [self addChild:_spriteNode];
    }
    
    return self;
}

-(BOOL)canAnimate {
    //Check our spriteNode for actions
    if(_spriteNode.hasActions) {
        return NO;
    }
    
    //Check if any animationChidren have actions
    return [super canAnimate];
}

-(void)animate {
    //If we can't animate, abort
    if (![self canAnimate])
        return;
    
    //Do our block before calling children, cause whatever
    animationBeginBlock();
    
    //Propegate animate call
    [super animateChildren];
    
    //Finally, do our animation, and run aniamtionCompleteBlock when done
    frame = 0;
    _framesPerSecond = 30;
    secondsPerFrame = 1/_framesPerSecond;
    secondsUntilNextFrame = secondsPerFrame;
    
    SKAction* tick = [SKAction customActionWithDuration: secondsPerFrame * _textureNames.count + 2 actionBlock:^(SKNode* node, CGFloat elapsedTime){
        
        while(elapsedTime >= secondsUntilNextFrame) {
            frame++;
            secondsUntilNextFrame += secondsPerFrame;
        }
        
        //If the frame count is valid, change frames
        if (frame < _textureNames.count) {
            _spriteNode.texture = [self getTextureWithName:_textureNames[frame]];
        }
        
        //If this is the last frame, do end stuff
        if (frame >= _textureNames.count-1) {
            animationCompleteBlock();
            
            if(_fadeOutDuration > 0) {
                [self fadeOutAndReset];
            }
            
            if (_isReversible) {
                _textureNames = [self reverseArray:_textureNames];
            }
            
            [node removeActionForKey:@"animation"];
        }
    }];
    
    [self runAction: tick withKey:@"animation"];
}

-(void)fadeOutAndReset {
    if(_fadeOutDuration) {
        SKAction* fadeOutAction = [SKAction fadeOutWithDuration: _fadeOutDuration];
        [_spriteNode runAction:fadeOutAction completion:^{
            _spriteNode.texture = [self getTextureWithName:_textureNames[0]];
            _spriteNode.alpha = 1;
        }];
    }
}

-(NSArray *)reverseArray: (NSArray *) array {
    NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    for (id element in enumerator) {
        [reversedArray addObject:element];
    }
    
    return reversedArray;
}


-(SKTexture*)getTextureWithName:(NSString*)name {
    UIImage* image = [UIImage imageNamed:name];
    return [SKTexture textureWithImage:image];
}

/// DEBUG FUNCTIONS ////////////////////////////////////
-(void)drawPointAtOrigin {
    SKSpriteNode* dot = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(3, 3)];
    dot.name = @"dot";
    [self addChild:dot];
}

-(void)drawOutlineWithWidth:(float)outlineWidth {
    CGRect outlineRect = CGRectMake(-_spriteNode.size.width*_spriteNode.anchorPoint.x, -_spriteNode.size.height*_spriteNode.anchorPoint.y, _spriteNode.size.width, _spriteNode.size.height);

    CGPathRef outlinePath = CGPathCreateWithRect(outlineRect, NULL);

    SKShapeNode* outlineNode = [SKShapeNode node];
    outlineNode.path = outlinePath;
    outlineNode.strokeColor = [UIColor greenColor];
    outlineNode.lineWidth = outlineWidth;
    outlineNode.name = @"outlineNode";

    [self addChild: outlineNode];
}

-(void)DebugMode {
    if ([self childNodeWithName:@"dot"] || [self childNodeWithName:@"outlineNode"]) {
        [self enumerateChildNodesWithName:@"dot" usingBlock:
         ^(SKNode *node, BOOL *stop){ [node removeFromParent]; }
         ];
        [self enumerateChildNodesWithName:@"outlineNode" usingBlock:
         ^(SKNode *node, BOOL *stop){ [node removeFromParent]; }
         ];
    }
    else {
        [self drawPointAtOrigin];
        [self drawOutlineWithWidth: 2];
    }
}

-(void)setSize:(CGSize)size {
    _spriteNode.size = size;
}

-(CGSize)size {
    return _spriteNode.size;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    _spriteNode.anchorPoint = anchorPoint;
}

-(CGPoint)anchorPoint {
    return _spriteNode.anchorPoint;
}



@end
