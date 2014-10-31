//
//  GreyOutView.h
//  Book
//
//  Created by Dustin Bayer on 4/4/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GreyOutDelegate

-(void)closeSettings;

@end

@interface GreyOutView : UIView

@property (weak, nonatomic) id <GreyOutDelegate> delegate;

@property NSTimer *waitTimer;
@property bool wait;

@end
