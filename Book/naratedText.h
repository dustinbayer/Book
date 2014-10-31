//
//  naratedText.h
//  Timer
//
//  Created by Oleksandra Keehl on 2/22/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface naratedText : UITextView
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)timerInit;
-(void)timerStop;
-(void)nextPart;
-(void)prevPart;

@property BOOL paused;

@property (strong, nonatomic) NSTimer * timer;
@property int currPage;
@property int numOfParts;
@property int currPart;

@end
