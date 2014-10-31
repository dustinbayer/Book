//
//  AnimatedSpriteNode.h
//
//  Created by Alec Tyre on 3/8/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AnimatedSpriteNode : SKSpriteNode

@property BOOL isReversible;
@property float fadeOutDuration;
@property BOOL waitForAnimationChildren;

-(id)initBlackNodeWithPath:(CGPathRef) path;

-(id)initBlankNodeWithSize:(CGSize)size;

-(id)initWithTextureAtlasNamed: (NSString *) textureAtlasName;

-(id)initWithTexturesNamed:(NSString *)textureBaseName WithNumberOfTextures:(int)numberOfTextures withType:(NSString *)fileType;

-(void)setAnimationBeginBlock: (void (^)(void))block;
-(void)setAnimationCompleteBlock: (void (^)(void))block;

-(void)animate;

-(void)addAnimationChild:(AnimatedSpriteNode *)child;

/// DEBUG FUNCTIONS ////////////////////////////////////

-(void)DebugMode;

+(void)DebugMode;

/// DEBUG FUNCTIONS ////////////////////////////////////

@end

