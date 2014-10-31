//
//  fogScene.m
//  Book
//
//  Created by Dustin Bayer on 7/9/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "FogScene.h"

@interface FogScene ()
@property NSMutableArray *fogArray;
@property float screenWidth;
@property float screenX;
@property BOOL isTouching;
@end

@implementation FogScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        _fogArray = [[NSMutableArray alloc] init];
        srandom(time(NULL));
        
        self.backgroundColor = [SKColor blackColor];
        SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"fogbackground.png"];
        background.position = CGPointMake(512, 350);
        [self addChild:background];
        
        self.physicsWorld.gravity = CGVectorMake(0, -0.06);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        SKSpriteNode *fog= [[SKSpriteNode alloc] init];
        
        for(int i = 0; i < 50; i++)
        {
            SKSpriteNode *fogCloud = [SKSpriteNode spriteNodeWithImageNamed:@"thick_fog2.png"];
            fogCloud.position = CGPointMake(arc4random() % 1024, arc4random() % 576);
            
            int fogRadius = arc4random() % 100 + 100;
            
            fogCloud.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:fogRadius];
            [fogCloud setScale:0.25];
            fogCloud.physicsBody.friction = 0.1;
          
            
            NSLog(@"fog: %f, %f", fogCloud.position.x, fogCloud.position.y);
            
            [_fogArray addObject: fogCloud];
            
            [fog addChild:fogCloud];
        }
        
        [fog setAlpha:0.8];
        
        [self addChild:fog];
        _screenWidth = 1024;
        _screenX = 0;
        _isTouching = false;
        
    }
    return self;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
       
        
        _isTouching = true;
        for(int i = 0; i < _fogArray.count; i++)
        {
            
            SKSpriteNode *node = [_fogArray objectAtIndex:i];
            float distanceX = node.position.x - location.x;
            float distanceY = node.position.y - location.y;
            
            
            if(abs(distanceX) < 75 && abs(distanceY) < 75)
            {
                float impulseX, impulseY;
                
                if(distanceX >= 0)
                    impulseX = 75 - distanceX;
                else
                    impulseX = -distanceX - 75;
                
                if(distanceY >= 0)
                    impulseY = 75 - distanceY;
                else
                    impulseY = -distanceY - 75;
                
                
                [node.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY)];
                
                
                
            }
            
        }
        if(_screenX > -500)
        {
            _screenWidth+=10;
            _screenX-=5;
            self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(_screenX, 0, _screenWidth, 768)];
        }
        
    }
    
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isTouching = false;
}

-(void)update:(CFTimeInterval)currentTime {
   
    if(!_isTouching)
    {
        if(_screenX < 0)
        {
            _screenX+=0.5;
            _screenWidth -= 1;
        }
        else
        {
            _screenX = 0;
            _screenWidth = 1024;
        }
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(_screenX, 0, _screenWidth, 768)];
    }
    
    for(int i = 0; i < _fogArray.count; i++)
    {
        SKSpriteNode *node = [_fogArray objectAtIndex:i];
        node.alpha = ((768 - node.position.y)/ 768);
        
    }
}
@end
