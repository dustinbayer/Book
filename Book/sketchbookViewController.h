//
//  sketchbookViewController.h
//  drawingTest
//
//  Created by Dustin Bayer on 10/3/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "SketchbookScene.h"

@protocol SketchbookControllerDelegate
-(void)doneDrawing:(UIImage *)savedImage;

@end

@interface sketchbookViewController : UIViewController <SketchbookSceneDelegate>
@property (weak, nonatomic) id <SketchbookControllerDelegate> delegate;

@property SKView *spriteView;
@property SketchbookScene * scene;
@property NSUInteger  pageNumber;
@property UIImage *drawing;



@end
