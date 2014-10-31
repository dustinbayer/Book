//
//  eDrawView.h
//  eDraw
//
//  Created by Oleksandra Keehl on 3/10/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface eDrawView : UIView


@property UIColor *strokeColor;

- (id)initWithFrame:(CGRect)frame colors:(UIImage *) colorDrawing tones:(UIImage *) toneDrawing;
- (void)finalDrawing;
- (void)reset;
- (UIImage *)getImage;

@property UIImage* pencilBrush;

@end
