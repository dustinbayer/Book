//
//  SettingsMenuSegue.m
//  Book
//
//  Created by Dustin Bayer on 3/26/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "SettingsMenuSegue.h"

@implementation SettingsMenuSegue

/*-(void)perform{
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    [dst viewWillAppear:NO];
    [dst viewDidAppear:NO];
    
    //[src retain];
    
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;
    
    dst.view.frame = CGRectMake(dst.view.frame.origin.x, 0-dst.view.frame.size.height, 130, 600);
    
    [UIView beginAnimations:nil context:nil];
    dst.view.frame = CGRectMake(original.origin.x, original.origin.y, 130, 600);
    [UIView commitAnimations];
    
    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:.2f];
}
- (void)animationDone:(id)vc{
    UIViewController *dst = (UIViewController*)vc;
    UINavigationController *nav = [[self sourceViewController] navigationController];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:dst animated:NO];
    //[[self sourceViewController] release];
}*/


- (void)perform {
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    //[dst viewWillAppear:NO];
    //[dst viewDidAppear:NO];
    
    //[src retain];
    
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;
    
    
    dst.view.frame = CGRectMake(dst.view.frame.origin.x, 0-dst.view.frame.size.height, 230, 670);
    UIView *settingsView = [dst.view subviews][0];
    int settingsOriginalX = settingsView.frame.origin.x;
    int settingsOriginalY = settingsView.frame.origin.y;
    settingsView.transform = CGAffineTransformMakeRotation(-M_PI/20);
    settingsView.frame = CGRectMake(settingsView.frame.origin.x , settingsView.frame.origin.y, settingsView.frame.size.width, settingsView.frame.size.height);
    //dst.view.transform = CGAffineTransformMakeRotation(M_PI/40);
    //[src.view.superview addSubview:dst.view];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         //source.view.frame = sourceFrame;
                         dst.view.frame = CGRectMake(original.origin.x, original.origin.y, 230, 670);
                         settingsView.transform = CGAffineTransformMakeRotation(0);
                         settingsView.frame = CGRectMake(settingsOriginalX, settingsOriginalY, settingsView.frame.size.width, settingsView.frame.size.height);
                         //dst.view.transform = CGAffineTransformMakeRotation(-M_PI/40);
                         //dst.view.transform = CGAffineTransformMakeRotation(0 * M_PI / 180.0);
                     }
                     completion:^(BOOL finished) {
                         //UIWindow *window = source.view.window;
                         //[window setRootViewController:destination];
                     }];
}

@end
