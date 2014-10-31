//
//  DrawingUnwindSegue.m
//  Book
//
//  Created by Dustin Bayer on 4/12/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "DrawingUnwindSegue.h"

@implementation DrawingUnwindSegue


- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    //UIViewController *destinationViewController = self.destinationViewController;
    
  
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Shrink!
                         sourceViewController.view.transform = CGAffineTransformMakeScale(0.125, 0.125);
                         sourceViewController.view.center = CGPointMake(512+25, 768/2);
                     }
                     completion:^(BOOL finished){
                         //S[destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [self.delegate enableTouch];
                         [sourceViewController dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                         [sourceViewController.view removeFromSuperview];
                     }];
}



@end
