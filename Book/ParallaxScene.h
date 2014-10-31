//
//  ParallaxScene.h
//  
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ParallaxNode.h"
#import "PageScene.h"


@interface ParallaxScene : PageScene <UIGestureRecognizerDelegate>

@property float maxOffsetX; //Maximum possible offsets
@property float minOffsetX;
@property float maxOffsetY;
@property float minOffsetY;

-(void)offsetOrigin:(CGPoint) offset;

@property CGPoint offset;
@property CGPoint offsetTarget;

@property float resposiveness; //Determines how "elastic" panning feels
@property float sensitivity;

-(void)createSceneContents;

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast;

@end
