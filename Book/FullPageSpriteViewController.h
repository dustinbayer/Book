//
//  FullPageSpriteViewController.h
//  Book
//
//  Created by Dustin Bayer on 3/8/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "FullSpriteScene.h"
#import "FullVideoViewController.h"


@protocol SpriteViewControllerDelegate

-(void) goStory;
-(void) gotoFullVideo;

@end

@interface FullPageSpriteViewController : UIViewController

@property (weak, nonatomic) id <SpriteViewControllerDelegate> delegate;

@property FullSpriteScene *spriteScene;

-(void) addHome;

@end

