//
//  AnimationShapeNode.m
//  Book
//
//  Created by Alec Tyre on 9/22/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import "ShapeAnimationNode.h"
#import <SpriteKit/SpriteKit.h>

@interface ShapeAnimationNode()

@property SKShapeNode* shapeNode;

@end


@implementation ShapeAnimationNode

@synthesize path = _path;

-(id)initWithPath:(CGPathRef) path {
    
    //Initialize with the first texture in the texture array
    self = (ShapeAnimationNode *)[super init];
    
    //If we exist, set properties to initial states
    if(self)
    {
        //NOTE: [super init] already initialized all AnimationNode defaults
        
        _shapeNode = [[SKShapeNode alloc] init];
        
        _path = path;
        
        _shapeNode.path = path;
        _shapeNode.lineWidth = 0;
        
        [self addChild:_shapeNode];
        
        self.userInteractionEnabled = YES;
        
        CGPathRelease(path);
    }
    
    return self;
}

-(id)initWithSize:(CGSize) size {
    
    //Initialize with the first texture in the texture array
    self = (ShapeAnimationNode *)[super init];
    
    //If we exist, set properties to initial states
    if(self)
    {
        //NOTE: [super init] already initialized all AnimationNode defaults
        
        _shapeNode = [[SKShapeNode alloc] init];

        CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), NULL);
        
        _path = path;
        
        _shapeNode.path = path;
        _shapeNode.lineWidth = 0;
        
        [self addChild:_shapeNode];
        
        self.userInteractionEnabled = YES;
        
        CGPathRelease(path);
    }
    
    return self;
}

-(BOOL)canAnimate {
    //Check if any animationChidren have actions
    return [super canAnimate];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    if(CGPathContainsPoint(_shapeNode.path, NULL, touchLocation, true)) {
        [self animate];
    }
}

-(void)animate
{
    if (![self canAnimate]) {
        return;
    }
    
    animationBeginBlock();
    
    [self animateChildren];
}

/// DEBUG FUNCTIONS ////////////////////////////////////
-(void)DebugMode {
    _shapeNode.fillColor = [UIColor redColor];
    
    if(_shapeNode.alpha != 0.2) {
        _shapeNode.alpha = 0.2;
    }
    else {
        _shapeNode.alpha = 0;
    }
}


@end
