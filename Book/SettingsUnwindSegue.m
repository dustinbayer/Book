//
//  SettingsUnwindSegue.m
//  Book
//
//  Created by Dustin Bayer on 3/28/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "SettingsUnwindSegue.h"

@implementation SettingsUnwindSegue

- (void)perform {
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    //[dst viewWillAppear:NO];
    //[dst viewDidAppear:NO];
    
    //[src retain];
    //[src.view addSubview:dst.view];
    //[src.view.superview insertSubview:dst.view atIndex:0];
    CGRect original = dst.view.frame;
    
    src.view.frame = CGRectMake(original.origin.x, original.origin.y, 230, 670);
    //[src.view.superview addSubview:dst.view];
    UIView *settingsView = [src.view subviews][0];
    int settingsOriginalX = settingsView.frame.origin.x;
    //int settingsOriginalY = settingsView.frame.origin.y;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         //source.view.frame = sourceFrame;
                         src.view.frame = CGRectMake(dst.view.frame.origin.x, 0-dst.view.frame.size.height, 230, 670);
                         
                         settingsView.transform = CGAffineTransformMakeRotation(-M_PI/25);
                         settingsView.frame = CGRectMake(settingsOriginalX, settingsView.frame.origin.y, settingsView.frame.size.width, settingsView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self.delegate enableTouch];
                         //[src.view removeFromSuperview]; // remove from temp super view
                         //[src dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                     }];
}


@end
