//
//  SettingsUnwindSegue.h
//  Book
//
//  Created by Dustin Bayer on 3/28/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsUnwindSegueDelegate

-(void)enableTouch;

@end

@interface SettingsUnwindSegue : UIStoryboardSegue
@property (weak, nonatomic) id <SettingsUnwindSegueDelegate> delegate;

@end
