//
//  DrawingSegue.m
//  Book
//
//  Created by Dustin Bayer on 4/12/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "DrawingSegue.h"

@implementation DrawingSegue


/*- (void)perform {
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    //[dst viewWillAppear:NO];
    //[dst viewDidAppear:NO];
    
    //[src retain];
    
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;
    
    dst.view.frame = CGRectMake(dst.view.frame.origin.x, -dst.view.frame.size.height, 1024, 768);
    //dst.view.transform = CGAffineTransformMakeRotation(M_PI/20);
    
    
    //[src.view.superview addSubview:dst.view];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         //source.view.frame = sourceFrame;
                         dst.view.frame = CGRectMake(original.origin.x, original.origin.y, 1024, 768);
                        //dst.view.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished) {
                         //UIWindow *window = source.view.window;
                         //[window setRootViewController:destination];
                     }];
}*/

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Transformation start scale
    destinationViewController.view.frame = CGRectMake(0, 0, 1024, 768);
    destinationViewController.view.transform = CGAffineTransformMakeScale(0.125, 0.125);
    
    // Store original centre point of the destination view
    CGPoint originalCenter = destinationViewController.view.center;
    // Set center to start point of the button
    destinationViewController.view.center = CGPointMake(512+25, 768/2);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         //[destinationViewController.view removeFromSuperview]; // remove from temp super view
                         //[sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
                     }];
}


@end
