//
//  DrawingUnwindSegue.h
//  Book
//
//  Created by Dustin Bayer on 4/12/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawingUnwindSegueDelegate

-(void)enableTouch;

@end


@interface DrawingUnwindSegue : UIStoryboardSegue
@property (weak, nonatomic) id <DrawingUnwindSegueDelegate> delegate;

@end
