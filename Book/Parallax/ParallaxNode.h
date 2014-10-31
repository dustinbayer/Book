//
//  ParallaxNode.h
//  Parallax
//
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ParallaxNode : SKNode

@property (nonatomic) CGPoint offset;
@property (nonatomic) float parallaxRatio;
@property (nonatomic) CGPoint screenPosition;

@end
