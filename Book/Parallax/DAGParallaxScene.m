//
//  DAGParallaxScene.m
//  Parallax
//
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import "DAGParallaxScene.h"



@interface DAGParallaxScene ()

@property BOOL contentCreated;
@property CGPoint offset;
@property CGPoint offsetTarget;
@property NSTimeInterval lastUpdateTimeInterval;
@property CFTimeInterval timeSinceLast;

@end

@implementation DAGParallaxScene

-(void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        [SoundManager playMusicFromFile:@"rushLimelight" withExt:@"mp3" atVolume:1];
    }
}

-(void)createSceneContents
{
    //Set sceene origin to screen center and set scale mode
    self.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.backgroundColor = [SKColor darkGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    //Create panGestureRecognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    //Initialize properties
    self.offset = CGPointMake(0, 0);
    self.offsetTarget = CGPointMake(0, 0);
    
    //Make parallaxNodes
    ParallaxNode *layerOne = [[ParallaxNode alloc] init];
    layerOne.parallaxRatio = 1.0;
    
    ParallaxNode *layerTwo = [[ParallaxNode alloc] init];
    layerTwo.parallaxRatio = 0.75;
    
    ParallaxNode *layerThree = [[ParallaxNode alloc] init];
    layerThree.parallaxRatio = 0.50;
    
    //Make background image nodes
    SKSpriteNode *layerOneBG = [[SKSpriteNode alloc] initWithImageNamed:@"first_layer_edited"];
    SKSpriteNode *layerTwoBG = [[SKSpriteNode alloc] initWithImageNamed:@"second_layer_edited"];
    SKSpriteNode *layerThreeBG1 = [[SKSpriteNode alloc] initWithImageNamed:@"forest_repeatable_background"];
    SKSpriteNode *layerThreeBG2 = [[SKSpriteNode alloc] initWithImageNamed:@"forest_repeatable_background"];
    
    //Position layerThree's two background images to be side by side
    layerThreeBG1.position = CGPointMake(-layerThreeBG1.size.width/2, 0);
    layerThreeBG2.position = CGPointMake(layerThreeBG2.size.width/2, 0);
    
    //Make clickToPlayAnimation nodes
    DAGClickToPlayAnimation *mushrooms = [[DAGClickToPlayAnimation alloc] initWithTextureAtlasNamed:@"mushrooms" isReversible: NO];
    mushrooms.position = CGPointMake(-720, -245);
    
    DAGClickToPlayAnimation *flowers = [[DAGClickToPlayAnimation alloc] initWithTextureAtlasNamed:@"flowers" isReversible: YES];
    flowers.position = CGPointMake(470, -280);
    
    DAGClickToPlayAnimation *ferns = [[DAGClickToPlayAnimation alloc] initWithTextureAtlasNamed:@"ferns" isReversible: YES];
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
    
    mushrooms.delegate = self;
    mushrooms.sound = @"Dream Bubble";
    ferns.delegate = self;
    ferns.sound = @"Cute Appearance 1";
    flowers.delegate = self;
    flowers.sound = @"Breast Twitch";
    
    //Set min/max offsets for this scene
    self.maxOffsetX = 1024/2;
    self.minOffsetX = -1024/2;
    self.maxOffsetY = 128;
    self.minOffsetY = -128;
}


-(void)respondToPanGesture:(id)recognizer
{
    /*CGPoint location = [recognizer locationInView:(SKView *) self.view];
    
    if(location.x <100 || location.x > 924)
    {
        [self resignFirstResponder];
    }*/
    
    
    
    //Add pan velocity to offsetTarget
    float xOffsetTarget = self.offsetTarget.x + ([recognizer velocityInView:self.view].x * self.timeSinceLast);
    float yOffsetTarget = self.offsetTarget.y - ([recognizer velocityInView:self.view].y * self.timeSinceLast);
    
    //Clamp new offsetTarget values
    xOffsetTarget = fmaxf(xOffsetTarget, self.minOffsetX);
    xOffsetTarget = fminf(xOffsetTarget, self.maxOffsetX);
    yOffsetTarget = fmaxf(yOffsetTarget, self.minOffsetY);
    yOffsetTarget = fminf(yOffsetTarget, self.maxOffsetY);

    self.offsetTarget = CGPointMake(xOffsetTarget, yOffsetTarget);
}

-(void)update:(NSTimeInterval)currentTime
{
    //Delta time stuff
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.timeSinceLast = timeSinceLast;
    
    //Move offset by trackingRate * distance toward offsetTarget
    CGFloat trackingRate = 0.33;
    CGFloat newX = self.offset.x + trackingRate * (self.offsetTarget.x - self.offset.x);
    CGFloat newY = self.offset.y + trackingRate * (self.offsetTarget.y - self.offset.y);
    
    //Set new offset
    self.offset = CGPointMake(newX, newY);
    
    //Find all ParallaxNode children and match their offset to current offset
    for (ParallaxNode *object in self.children)
    {
        if([object isKindOfClass:[ParallaxNode class]])
            object.offset = self.offset;
    }
}


@end

