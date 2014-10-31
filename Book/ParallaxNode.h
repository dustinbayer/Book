//
//  ParallaxNode.h
//
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ParallaxNode : SKNode

@property (nonatomic) CGPoint offset;
@property CGPoint offsetRatio;
@property (nonatomic) CGPoint screenPosition;

@end
