//
//  DAGClickToPlayAnimation.h
//  Parallax
//
//  Created by Alec Tyre on 3/8/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol AnimationDelegate


@end

@interface DAGClickToPlayAnimation : SKSpriteNode
@property (weak, nonatomic) id <AnimationDelegate> delegate;
@property NSString *sound;

-(id)initWithTextureAtlasNamed: (NSString *) textureAtlasName isReversible: (BOOL) reversible;

@end
