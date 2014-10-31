//
//  ViewController.h
//  Book
//
//  Created by Dustin Bayer on 2/21/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>

#import "FullPageSpriteViewController.h"
#import "FullVideoViewController.h"
#import "DataViewController.h"
#import "SettingsViewController.h"
#import "PageSelectViewController.h"
#import "eDrawViewController.h"
#import "VideoScene.h"
#import "SettingsMenuSegue.h"
#import "SettingsUnwindSegue.h"
#import "GreyOutView.h"
#import "PageSelectSegue.h"
#import "PageSelectUnwindSegue.h"
#import "DrawingSegue.h"
#import "DrawingUnwindSegue.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, SettingsViewControllerDelegate, UIPopoverControllerDelegate, PageSelectViewControllerDelegate, SpriteViewControllerDelegate, DataViewControllerDelegate,SettingsUnwindSegueDelegate, GreyOutDelegate, UIGestureRecognizerDelegate, DrawingControllerDelegate, DrawingUnwindSegueDelegate>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPopoverController *settingsPopoverController;
@property SettingsViewController *settings;
@property PageSelectViewController *pageSelect;
@property eDrawViewController *drawing;
@property (strong, nonatomic) UIPopoverController *pageSelectPopoverController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
//@property NSUInteger  currPage;

@property UIButton *settingsButton;
@property DataViewController *currentDataView;
@property DataViewController *prevDataView;
@property BOOL showText;
@property BOOL flipComplete;
@property BOOL soundMuted;

@property GreyOutView *settingsGreyOut;


@end