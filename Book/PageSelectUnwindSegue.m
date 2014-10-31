//
//  PageSelectUnwindSegue.m
//  Book
//
//  Created by Dustin Bayer on 4/5/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "PageSelectUnwindSegue.h"

@implementation PageSelectUnwindSegue



- (void)perform {
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    //[dst viewWillAppear:NO];
    //[dst viewDidAppear:NO];
    
    //[src retain];
    //[src.view addSubview:dst.view];
    //[src.view.superview insertSubview:dst.view atIndex:0];
    CGRect original = dst.view.frame;
    
    src.view.frame = CGRectMake(original.origin.x+200, original.origin.y+20, 800, 800);
    //[src.view.superview addSubview:dst.view];
    UIView *pageSelectView = [src.view subviews][0];
   int pageSelectOriginalX = pageSelectView.frame.origin.x;
    //int pageSelectOriginalY = pageSelectView.frame.origin.y;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         //source.view.frame = sourceFrame;
                         pageSelectView.transform = CGAffineTransformMakeRotation(M_PI/20);
                         pageSelectView.frame = CGRectMake(pageSelectOriginalX, pageSelectView.frame.origin.y, pageSelectView.frame.size.width, pageSelectView.frame.size.height);
                         
                         src.view.frame = CGRectMake(dst.view.frame.origin.x+200, dst.view.frame.size.height, 800, 800);
                         
                     }
                     completion:^(BOOL finished) {
                         [src.view removeFromSuperview]; // remove from temp super view
                         //[src dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                     }];
}

@end
