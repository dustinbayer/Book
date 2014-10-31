//
//  AnimationNode.h
//  Book
//
//  Created by Alec Tyre on 9/19/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^block)(void);

@interface AnimationNode : SKNode
{
    block animationBeginBlock;
    block animationCompleteBlock;
}

@property (nonatomic, copy) block animationBeginBlock;
@property (nonatomic, copy) block animationCompleteBlock;

@property BOOL waitForAnimationChildren;

-(void)animate;

-(BOOL)canAnimate;

-(void)animateChildren;

-(void)setAnimationBeginBlock:(void (^)(void))block;
-(void)setAnimationCompleteBlock:(void (^)(void))block;

-(void)addAnimationChild:(AnimationNode *)child;

-(void)DebugMode;

@end
