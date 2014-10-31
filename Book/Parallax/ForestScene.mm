//
//  ForestScene.m
//
//  Created by Alec Tyre on 3/22/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import "ForestScene.h"
#import "AnimatedSpriteNode.h"
#import "SoundManager.h"
#import "FModHelper.h"
#import "SpriteAnimationNode.h"

@implementation ForestScene

-(void)createSceneContents {
    //Set sceene origin to screen center and set scale mode
    self.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.backgroundColor = [SKColor darkGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    //Make parallaxNodes
    ParallaxNode *layerOne = [[ParallaxNode alloc] init];
    layerOne.offsetRatio = CGPointMake(1.0, 1.0);
    
    ParallaxNode *layerTwo = [[ParallaxNode alloc] init];
    layerTwo.offsetRatio = CGPointMake(0.75, 0.9);
    
    ParallaxNode *layerThree = [[ParallaxNode alloc] init];
    layerThree.offsetRatio = CGPointMake(0.5, 0.8);
    
    //Make background image nodes
    SKSpriteNode *layerOneBG = [[SKSpriteNode alloc] initWithImageNamed:@"first_layer_edited"];
    SKSpriteNode *layerTwoBG = [[SKSpriteNode alloc] initWithImageNamed:@"second_layer_edited"];
    SKSpriteNode *layerThreeBG1 = [[SKSpriteNode alloc] initWithImageNamed:@"forest_repeatable_background"];
    SKSpriteNode *layerThreeBG2 = [[SKSpriteNode alloc] initWithImageNamed:@"forest_repeatable_background"];
    
    //Position layerThree's two background images to be side by side
    layerThreeBG1.position = CGPointMake(-layerThreeBG1.size.width/2, 0);
    layerThreeBG2.position = CGPointMake(layerThreeBG2.size.width/2, 0);
    
    //Create FMod sounds
    FModEvent* bambooHit = [FModEvent eventWithPath:@"event:/Forest Scene/Bamboo Hit"];
    FModEvent* breastTwitch = [FModEvent eventWithPath:@"event:/Forest Scene/Breast Twitch"];
    FModEvent* cuteAppearance = [FModEvent eventWithPath:@"event:/Forest Scene/Cute Appearance"];
    
    //Make clickToPlayAnimation nodes
    AnimatedSpriteNode *mushrooms = [[AnimatedSpriteNode alloc] initWithTextureAtlasNamed:@"mushrooms"];
    [mushrooms setAnimationBeginBlock:^{ [bambooHit play]; }];
    [mushrooms setScale:0.5];
    mushrooms.position = CGPointMake(-720, -245);
    
    AnimatedSpriteNode *flowers = [[AnimatedSpriteNode alloc] initWithTextureAtlasNamed:@"flowers"];
    [flowers setAnimationBeginBlock:^{ [breastTwitch play]; }];
    flowers.position = CGPointMake(470, -280);
    
    SpriteAnimationNode *ferns = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"ferns_" WithNumberOfTextures:55 withType:@"png"];
    [ferns setAnimationBeginBlock:^{ [cuteAppearance play]; }];
    ferns.isReversible = YES;
    ferns.userInteractionEnabled = YES;
    ferns.position = CGPointMake(-480, -260);
    
    //Add parallaxNodes to scene
    [self addChild: layerThree];
    [self addChild: layerTwo];
    [self addChild: layerOne];
    
    //Add other nodes to parallaxNodes
    [layerOne addChild: layerOneBG];
    [layerOne addChild: mushrooms];
    [layerOne addChild: ferns];
    [layerOne addChild: flowers];
    
    [layerTwo addChild: layerTwoBG];
    
    [layerThree addChild: layerThreeBG1];
    [layerThree addChild: layerThreeBG2];
    
    //Set min/max offsets for this scene
    self.maxOffsetX = 1024/2;
    self.minOffsetX = -1024/2;
    self.maxOffsetY = 128;
    self.minOffsetY = -128;
    
    //Play amazing background music
    //[SoundManager playMusicFromFile:@"rushLimelight" withExt:@"mp3" atVolume:0.75];
}

@end
