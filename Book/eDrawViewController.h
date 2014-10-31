//
//  eDrawViewController.h
//  eDraw
//
//  Created by Oleksandra Keehl on 3/10/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "sketchbookViewController.h"

@protocol DrawingControllerDelegate
-(void)doneDrawing:(NSArray *)savedImages;
-(NSMutableArray*) getSavedImages;
@end

@interface eDrawViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate, SketchbookControllerDelegate>
@property (weak, nonatomic) id <DrawingControllerDelegate> delegate;

-(void) setTheDelegate:(id<DrawingControllerDelegate>)delegate;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property sketchbookViewController *currentView;
@property sketchbookViewController *pendingView;
@property sketchbookViewController *prevView;
@property NSUInteger pendingPage;

@property (strong, nonatomic) NSArray *pageTitles;
@property BOOL isFlipping;

@property (strong, nonatomic) NSArray *colors;

@property (weak, nonatomic) IBOutlet UIButton *black;
@property (weak, nonatomic) IBOutlet UIButton *red;
@property (weak, nonatomic) IBOutlet UIButton *green;
@property (weak, nonatomic) IBOutlet UIButton *blue;
@property (weak, nonatomic) IBOutlet UIButton *yellow;
@property NSMutableArray *savedImages;

@end
