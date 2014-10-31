//
//  DAGParallaxScene.h
//  Parallax
//
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ParallaxNode.h"
#import "DAGClickToPlayAnimation.h"
#import "SoundManager.h"

@protocol ParallaxSceneDelegate


@end

@interface DAGParallaxScene : SKScene <AnimationDelegate>
@property (weak, nonatomic) id <ParallaxSceneDelegate> delegate;
@property float maxOffsetX;
@property float minOffsetX;
@property float maxOffsetY;
@property float minOffsetY;


@end
