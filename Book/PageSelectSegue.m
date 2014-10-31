//
//  PageSelectSegue.m
//  Book
//
//  Created by Dustin Bayer on 4/5/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "PageSelectSegue.h"

@implementation PageSelectSegue


- (void)perform {
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    //[dst viewWillAppear:NO];
    //[dst viewDidAppear:NO];
    
    //[src retain];
    
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;
    
    dst.view.frame = CGRectMake(dst.view.frame.origin.x+200, dst.view.frame.size.height, 800, 800);
    //dst.view.transform = CGAffineTransformMakeRotation(M_PI/20);
    
    UIView *pageSelectView = [dst.view subviews][0];
    int pageSelectOriginalX = pageSelectView.frame.origin.x;
    int pageSelectOriginalY = pageSelectView.frame.origin.y;
    pageSelectView.transform = CGAffineTransformMakeRotation(M_PI/15);
    pageSelectView.frame = CGRectMake(pageSelectView.frame.origin.x, pageSelectView.frame.origin.y, pageSelectView.frame.size.width, pageSelectView.frame.size.height);
    
    //[src.view.superview addSubview:dst.view];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         //source.view.frame = sourceFrame;
                         dst.view.frame = CGRectMake(original.origin.x+200, original.origin.y+20, 800, 800);
                         pageSelectView.transform = CGAffineTransformMakeRotation(0);
                         pageSelectView.frame = CGRectMake(pageSelectOriginalX, pageSelectOriginalY, pageSelectView.frame.size.width, pageSelectView.frame.size.height);
                         //dst.view.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished) {
                         //UIWindow *window = source.view.window;
                         //[window setRootViewController:destination];
                     }];
}


@end
