//
//  ParallaxScene
//
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//
/*
 
  PURPOSE:
        
        A SpriteScene with built in functions to implement a parallax effect.
 
        Panning gestures move all child ParallaxNodes and their children.

  USE:
        Use ParallaxNodes as layers for parallaxing effect, parenting all Sprite nodes that are on the same layer under a single ParallaxNode. 
        
        Parallax effect is achieved by having different ParallaxNodes have different offsetRatios. Smaller ratios seem further away because they move more slowly.
 
        Subclass PrallaxScene and override the createSceneContents function to assemble your scene
        
        @property float maxOffsetX; //Maximum possible offsets
        @property float minOffsetX;
        @property float maxOffsetY;
        @property float minOffsetY;
 
        @property float responsiveness  //determines how "elastic" panning feels
*/

#import "ParallaxScene.h"
#import "SpriteAnimationNode.h"

@interface ParallaxScene ()

@property BOOL contentCreated;

@property NSTimeInterval lastUpdateTimeInterval;
@property CFTimeInterval timeSinceLast;

@end

@implementation ParallaxScene

- (void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        self.contentCreated = NO;
        [self initialize];
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)initialize
{
    //Create panGestureRecognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    panRecognizer.delegate = self;
    
    //Initialize offset properties
    self.offset = CGPointMake(0, 0);
    self.offsetTarget = CGPointMake(0, 0);
    
    //Default min/max offsets
    self.minOffsetX = -self.size.width;
    self.maxOffsetX = self.size.width;
    self.minOffsetY = -self.size.height;
    self.maxOffsetY = self.size.height;
    
    //Default elasticity
    self.resposiveness = 0.33;
    self.sensitivity = 1;
}

- (void)createSceneContents
{
    //Override to create scene
}

-(void)offsetOrigin:(CGPoint)offset {
    _offset = offset;
    _offsetTarget = offset;
    
    //Check all child nodes, any that are ParallaxNodes are adjusted to match new offset
    for (ParallaxNode* node in self.children) {
        if([node isKindOfClass:[ParallaxNode class]]) {
            node.offset = CGPointMake(node.offset.x + offset.x, node.offset.y + offset.y);
            node.position = CGPointMake(node.position.x + offset.x, node.position.y + offset.y);;
        }
    }
}

- (void)respondToPanGesture:(id)recognizer
{    
    //Add pan velocity with delta time correction to offsetTarget
    float xOffsetTarget = self.offsetTarget.x + ([recognizer velocityInView:self.view].x * self.timeSinceLast * _sensitivity);
    float yOffsetTarget = self.offsetTarget.y - ([recognizer velocityInView:self.view].y * self.timeSinceLast * _sensitivity);
    
    //Clamp new offsetTarget values
    xOffsetTarget = fmaxf(xOffsetTarget, self.minOffsetX);
    xOffsetTarget = fminf(xOffsetTarget, self.maxOffsetX);
    yOffsetTarget = fmaxf(yOffsetTarget, self.minOffsetY);
    yOffsetTarget = fminf(yOffsetTarget, self.maxOffsetY);
    
    //Assign the newly calculated offsetTarget
    self.offsetTarget = CGPointMake(xOffsetTarget, yOffsetTarget);
}

- (void)update:(NSTimeInterval)currentTime
{
    //Time correction
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.timeSinceLast = timeSinceLast;
    
    //Move offset by trackingRate * distance toward offsetTarget
    CGFloat newX = self.offset.x + self.resposiveness * (self.offsetTarget.x - self.offset.x);
    CGFloat newY = self.offset.y + self.resposiveness * (self.offsetTarget.y - self.offset.y);
    
    //Set new offset
    self.offset = CGPointMake(newX, newY);
    
    //Find all ParallaxNode children and match their offset to current offset
    for (ParallaxNode *object in self.children)
    {
        if([object isKindOfClass:[ParallaxNode class]])
            object.offset = self.offset;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:self.view];
     
        if(point.x < 100 || point.x > 924)
        {
            return NO;
        }
        
        
    }
    return YES;
}


@end

