//
//  AnimationShapeNode.h
//  Book
//
//  Created by Alec Tyre on 9/22/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import "AnimationNode.h"

@interface ShapeAnimationNode : AnimationNode

-(id)initWithPath:(CGPathRef) path;
-(id)initWithSize:(CGSize) size;

@property (nonatomic) CGPathRef path;

@end
