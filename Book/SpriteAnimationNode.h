//
//  SpriteAnimationNode.h
//  Book
//
//  Created by Alec Tyre on 9/19/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import "AnimationNode.h"

@interface SpriteAnimationNode : AnimationNode

-(id)initWithTexturesNamed:(NSString *)textureBaseName WithNumberOfTextures:(int)numberOfTextures withType:(NSString *)fileType;

@property float framesPerSecond;
@property bool isReversible;

@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint anchorPoint;


@property float fadeOutDuration;;

@end
