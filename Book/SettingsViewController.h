//
//  SettingsViewController.h
//  Book
//
//  Created by Dustin Bayer on 2/14/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate
//- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
- (void)goHome;
- (void)pageSelectClicked;
-(void)toggleText:(BOOL)state;
-(void) unwindToMainMenu;
-(void) muteSound:(BOOL)muted;
@end

@interface SettingsViewController : UIViewController 

@property (weak, nonatomic) id <SettingsViewControllerDelegate> delegate;

//- (IBAction)done:(id)sender;
- (IBAction)pageSelectButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *soundImage;
@property (weak, nonatomic) IBOutlet UIImageView *narrationImage;
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UIImageView *pageSelectImage;
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UIImageView *textImage;

-(void) setTheDelegate:(id<SettingsViewControllerDelegate>)delegate;


@end