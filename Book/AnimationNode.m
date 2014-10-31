//
//  AnimationNode.m
//  Book
//
//  Created by Alec Tyre on 9/19/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//



#import "AnimationNode.h"



@interface AnimationNode()

@property NSMutableArray* animationChildren;

@end


@implementation AnimationNode

@synthesize animationBeginBlock;
@synthesize animationCompleteBlock;

-(id)init {
    self = (AnimationNode*)[super init];
    
    if(self) {
        _animationChildren = [NSMutableArray array];
        animationBeginBlock = ^{};
        animationCompleteBlock = ^{};
        self.userInteractionEnabled = NO;
        _waitForAnimationChildren = YES;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animate];
}

//Override to change the rules for whether or not a node canAnimate
-(BOOL)canAnimate {
    //If waitForAnimationChildren is YES
    if(_waitForAnimationChildren)
    {
        //Check each animationChild
        for (AnimationNode* animationChild in _animationChildren) {
            //If any animationChild is still animating, stop!
            if (![animationChild canAnimate]) {
                return NO;
            }
        }
    }
    
    if(self.hasActions)
        return NO;
    else
        return YES;
}

//Override example
/*
-(void)animate {
    if (![self canAnimate])
        return;

    animationBeginBlock();
    
    [self animateChildren];

    SKAction* demoAction = [SKAction animateWithTextures:_textures timePerFrame:0.4];

    [self runAction: demoAction complete: ^{ animationCompleteBlock(); }];
}
*/
-(void)animate
{
    if (![self canAnimate]) {
        return;
    }
    
    [self animateChildren];
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
    
    for (AnimationNode* node in _animationChildren)
    {
        if ([node isKindOfClass:[AnimationNode class]])
        {
            [node animate];
        }
    }
}

-(void)addAnimationChild:(AnimationNode *)child {
    [_animationChildren addObject:child];
}

/// DEBUG FUNCTIONS ////////////////////////////////////
//Override to setup how debug is displayed
-(void)DebugMode {
    if ([self childNodeWithName:@"crossNode"]) {
        [self enumerateChildNodesWithName:@"crossNode" usingBlock:^(SKNode *node, BOOL *stop){
            [node removeFromParent];
        }];
    }
    else {
        CGMutablePathRef crossPath = CGPathCreateMutable();
        
        CGPathMoveToPoint(crossPath, NULL, 0, 5);
        CGPathAddLineToPoint(crossPath, NULL, 0, -5);
        CGPathMoveToPoint(crossPath, NULL, -5, 0);
        CGPathAddLineToPoint(crossPath, NULL, 5, 0);

        SKShapeNode* crossNode = [SKShapeNode node];
        crossNode.path = crossPath;
        crossNode.strokeColor = [UIColor redColor];
        crossNode.lineWidth = 1;
        crossNode.name = @"crossNode";
        
        [self addChild: crossNode];
    }
}

@end
