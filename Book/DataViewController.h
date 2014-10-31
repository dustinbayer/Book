//
//  DataViewController.h
//  Book
//
//  Created by Dustin Bayer on 2/6/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "naratedText.h"
#import "VideoScene.h"
#import "YardScene.h"
#import "DrawScene.h"
#import "ForestScene.h"
#import "FogScene.h"
#import "CliffScene.h"
#import "SKStarTraceMyScene.h"
#import "FlashlightMyScene.h"
#import "EndScene.h"

@protocol DataViewControllerDelegate
-(void)drawingSegue;
-(void)goHome;
-(void)removePause;
-(void)enableTouch;
-(NSMutableArray*) getSavedImages;

@end

@interface DataViewController : UIViewController <VideoSceneDelegate, PageSceneDelegate>

@property (weak, nonatomic) id <DataViewControllerDelegate> delegate;

@property SKView *spriteView;
@property UIView *textView;
@property UIImageView *textImageView;
@property UIImage *textImage;
@property naratedText *textBox;
@property UILabel *label;
@property UIView *swipebarLeft;
@property UIView *swipebarRight;
@property UIButton *skipButton;


@property VideoScene *videoScene;
@property PageScene *currScene;

@property CGRect textOriginal;
@property float textHeight;
@property float textWidth;
@property CGRect spriteOriginal;
@property float spriteHeight;
@property float spriteWidth;

@property NSString *titleText;
@property NSUInteger  pageNumber;
@property BOOL showText;

@property NSString *state;
@property NSMutableArray *savedDrawings;
@property BOOL soundMuted;
//-(void) addInteractive;
-(void)toggleText:(BOOL) display;

@end
