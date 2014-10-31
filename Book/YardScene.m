//
//  YardScene.m
//  Book
//
//  Created by Alec Tyre on 6/13/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "YardScene.h"
//#import "AnimatedSpriteNode.h"
#import "SoundManager.h"
#import "SpriteAnimationNode.h"
#import "ShapeAnimationNode.h"

@interface YardScene()

@end

@implementation YardScene

-(void)createSceneContents {
    
    //Set sceene origin to screen center and set scale mode
    self.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.backgroundColor = [SKColor darkGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    
    //Set min/max offsets for this scene
    self.maxOffsetX = 600;
    self.minOffsetX = -750;
    self.maxOffsetY = 35;
    self.minOffsetY = -35;
    
   
    //Make parallaxNodes
    ParallaxNode *layerOne = [[ParallaxNode alloc] init];
    layerOne.offsetRatio = CGPointMake(1, 1);
    
    ParallaxNode *layerTwo = [[ParallaxNode alloc] init];
    layerTwo.offsetRatio = CGPointMake(0.75, 0.9);
    
    ParallaxNode* layerThree = [[ParallaxNode alloc] init];
    layerThree.offsetRatio = CGPointMake(0.5, 0.8);
    
    ParallaxNode* layerFour = [[ParallaxNode alloc] init];
    layerFour.offsetRatio = CGPointMake(0.4, 0.7);
    
    
    //Make background image nodes
    SKSpriteNode *layerOneBG = [[SKSpriteNode alloc] initWithImageNamed:@"YardScene_layer1BG.png"];
    SKSpriteNode *layerTwoBG = [[SKSpriteNode alloc] initWithImageNamed:@"YardScene_layer2BG.png"];
    SKSpriteNode *layerThreeBG = [[SKSpriteNode alloc] initWithImageNamed:@"YardScene_layer3BG.png"];
    SKSpriteNode *layerFourBG = [[SKSpriteNode alloc] initWithImageNamed:@"YardScene_layer4BG.png"];
        
    
    //Add parallaxNodes to scene
    [self addChild: layerFour];
    [self addChild: layerThree];
    [self addChild: layerTwo];
    [self addChild: layerOne];
    
    
    //[AnimatedSpriteNode DebugMode];
    
    //Add animated sprites
    //Gate
    SpriteAnimationNode* gate = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"gate_anm" WithNumberOfTextures:24 withType:@"png"];
    gate.position = CGPointMake(446, -56);
    [gate setAnimationBeginBlock:^{ [SoundManager playSoundFromFile:@"gateclip" withExt:@"wav" atVolume:1.0]; }];
    
    //Gate hitbox
    ShapeAnimationNode* gateHitBox = [[ShapeAnimationNode alloc] initWithSize:gate.size];
    gateHitBox. position = CGPointMake(gate.position.x-gate.size.width/2,gate.position.y-gate.size.height/2);
    
    [gateHitBox addAnimationChild: gate];

    //Hero Tree
    SpriteAnimationNode* heroTree = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"heroTree_anm_" WithNumberOfTextures:50 withType:@"png"];
    heroTree.position = CGPointMake(375, 80);
    
    //Hero Tree Leaves
    SpriteAnimationNode* heroTreeLeaves = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"ht_leaves_anm" WithNumberOfTextures:87 withType:@"png"];
    heroTreeLeaves.position = CGPointMake(heroTree.position.x-50, heroTree.position.y-100);
    heroTreeLeaves.fadeOutDuration = 0.5;
    
    //Hero Tree Shadow
    SpriteAnimationNode* heroTreeShadow = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"herotree_shadow_anm" WithNumberOfTextures:50 withType:@"png"];
    heroTreeShadow.position = CGPointMake(heroTree.position.x+82, heroTree.position.y-210);
    
    /// Hero Tree Hitbox
    CGMutablePathRef heroTreeHitboxPath = CGPathCreateMutable();
    CGPoint heroTreePointArray[] = {CGPointZero, CGPointMake(-4, 50), CGPointMake(35, 130), CGPointMake(195, 135), CGPointMake(375, 16), CGPointMake(325, -95), CGPointZero};
    CGPathAddLines(heroTreeHitboxPath, NULL, heroTreePointArray, (sizeof heroTreePointArray)/(sizeof heroTreePointArray[0]));
    ShapeAnimationNode* heroTreeHitBox = [[ShapeAnimationNode alloc] initWithPath:heroTreeHitboxPath];
    heroTreeHitBox.position = CGPointMake(heroTree.position.x-183, heroTree.position.y-5);
    
    [heroTreeHitBox addAnimationChild:heroTree];
    [heroTreeHitBox addAnimationChild:heroTreeLeaves];
    [heroTreeHitBox addAnimationChild:heroTreeShadow];
    
    
    //Redwood Tree
    SpriteAnimationNode* redwoodTree = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"redwood_tree_anm_" WithNumberOfTextures:50 withType:@"png"];
    redwoodTree.position = CGPointMake(100, 100);
    
    //Redwood Shadow
    SpriteAnimationNode* redwoodShadow = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"redwood_shadow_anm_" WithNumberOfTextures:50 withType:@"png"];
    redwoodShadow.position = CGPointMake(redwoodTree.position.x + 108, redwoodTree.position.y - 300);
    
    //Redwood Leaves
    SpriteAnimationNode* redwoodLeaves = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"redwood_leaves_anm_" WithNumberOfTextures:96 withType:@"png"];
    redwoodLeaves.position = CGPointMake(redwoodTree.position.x - 54, redwoodTree.position.y - 46);
    redwoodLeaves.fadeOutDuration = 0.5;
    
    //Redwood Hitbox
    CGMutablePathRef redWoodHitboxPath = CGPathCreateMutable();
    CGPoint redwoodPointArray[] = {CGPointZero, CGPointMake(75, 316), CGPointMake(100, 316), CGPointMake(135, 210), CGPointMake(175, 0), CGPointMake(80, -25), CGPointZero};
    CGPathAddLines(redWoodHitboxPath, NULL, redwoodPointArray, (sizeof(redwoodPointArray))/sizeof(redwoodPointArray[0]));
    ShapeAnimationNode* redwoodHitbox = [[ShapeAnimationNode alloc] initWithPath: redWoodHitboxPath];
    redwoodHitbox.position = CGPointMake(redwoodTree.position.x -87, redwoodTree.position.y - 120);
    redwoodHitbox.waitForAnimationChildren = YES;
    
    [redwoodHitbox addAnimationChild: redwoodTree];
    [redwoodHitbox addAnimationChild: redwoodShadow];
    [redwoodHitbox addAnimationChild: redwoodLeaves];
    
    
    //Tamarac Tree
    SpriteAnimationNode* tamaracTree = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"tamarac_tree_anm_" WithNumberOfTextures:50 withType:@"png"];
    tamaracTree.position = CGPointMake(650, 110);
    
    //Tamarac Shadow
    SpriteAnimationNode* tamaracShadow = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"tamarac_shadow_anm_" WithNumberOfTextures:50 withType:@"png"];
    tamaracShadow.position = CGPointMake(tamaracTree.position.x + 231, tamaracTree.position.y - 264);
    
    //Tamarac Leaves
    SpriteAnimationNode* tamaracLeaves = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"tamarac_leaves_anm_" WithNumberOfTextures:97 withType:@"png"];
    tamaracLeaves.position = CGPointMake(tamaracTree.position.x - 54, tamaracTree.position.y - 46);
    tamaracLeaves.fadeOutDuration = 0.5;
    
    //Tamarac Hitbox
    CGMutablePathRef tamaracHitboxPath = CGPathCreateMutable();
    CGPoint tamaracPointArray[] = {CGPointZero, CGPointMake(50, 240), CGPointMake(85, 341), CGPointMake(110, 341), CGPointMake(204, 154), CGPointMake(190, 0), CGPointMake(107, -35), CGPointZero};
    CGPathAddLines(tamaracHitboxPath, NULL, tamaracPointArray, (sizeof(tamaracPointArray))/sizeof(tamaracPointArray[0]));
    ShapeAnimationNode* tamaracHitbox = [[ShapeAnimationNode alloc] initWithPath: tamaracHitboxPath];
    tamaracHitbox.position = CGPointMake(tamaracTree.position.x -97, tamaracTree.position.y - 150);
    tamaracHitbox.waitForAnimationChildren = YES;
     
    [tamaracHitbox addAnimationChild: tamaracTree];
    [tamaracHitbox addAnimationChild: tamaracShadow];
    [tamaracHitbox addAnimationChild: tamaracLeaves];
    
    //Add other nodes to parallaxNodes
    [layerOne addChild: heroTree];
    [layerOne addChild: layerOneBG];
    [layerOne addChild: gate];
    [layerOne addChild: heroTreeShadow];
    [layerOne addChild: heroTreeLeaves];
    [layerOne addChild: redwoodTree];
    [layerOne addChild: redwoodShadow];
    [layerOne addChild: redwoodLeaves];
    [layerOne addChild: tamaracTree];
    [layerOne addChild: tamaracShadow];
    [layerOne addChild: tamaracLeaves];
    [layerOne addChild: gateHitBox];
    [layerOne addChild: heroTreeHitBox];
    [layerOne addChild: redwoodHitbox];
    [layerOne addChild: tamaracHitbox];
     
    [layerTwo addChild: layerTwoBG];
    [layerThree addChild: layerThreeBG];
    [layerFour addChild: layerFourBG];
    
    /*
    SpriteAnimationNode* spriteAnimationNodeTest = [[SpriteAnimationNode alloc] initWithTexturesNamed:@"tamarac_tree_anm_" WithNumberOfTextures:50 withType:@"png"];
    spriteAnimationNodeTest.userInteractionEnabled = YES;
    [spriteAnimationNodeTest DebugMode];
    [spriteAnimationNodeTest setAnimationBeginBlock:^{
        NSLog(@"Animation begin");
    }];
    [spriteAnimationNodeTest setAnimationCompleteBlock:^{
        NSLog(@"Animation complete");
    }];
    
    [layerOne addChild:spriteAnimationNodeTest];
    
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI / 4);    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, 100, 100), &transform);
    
    
    ShapeAnimationNode* shapeAnimationNodeTest = [[ShapeAnimationNode alloc] initWithPath: path];
    shapeAnimationNodeTest.position = CGPointMake(200, 0);
    [shapeAnimationNodeTest DebugMode];
    [shapeAnimationNodeTest setAnimationBeginBlock:^{ NSLog(@"BEGIN" ); }];
    [shapeAnimationNodeTest addAnimationChild:spriteAnimationNodeTest];
    shapeAnimationNodeTest.userInteractionEnabled = YES;
    
    [layerOne addChild: shapeAnimationNodeTest];
    */
    
    [self offsetOrigin:CGPointMake(-113, 0)];
    self.minOffsetX += 113;
    self.maxOffsetX += 113;
}

@end
