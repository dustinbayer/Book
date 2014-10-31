//
//  FlipsideViewController.m
//  Book
//
//  Created by Dustin Bayer on 2/14/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "SettingsViewController.h"
#import "SoundManager.h"

@interface SettingsViewController ()

@property NSTimer *waitTimer;
@property bool wait;
@end

@implementation SettingsViewController


- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(230.0, 670.0);
    [super awakeFromNib];
    
    //_defaults = [NSUserDefaults standardUserDefaults];
    
    /*if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchState"])
    {
        _narrationImage.image = [UIImage imageNamed:@"Page1.png"];
        NSLog(@"is on");
    }
    else
    {
        _narrationImage.image = [UIImage imageNamed:@"Page2.png"];
        NSLog(@"is off");
    }
    
    NSLog(@"%hhd", [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchState"]);*/
    
    _wait = false;
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _homeImage.image = [UIImage imageNamed:@"Home.png"];
    _pageSelectImage.image = [UIImage imageNamed:@"PageSelect.png"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NarrState"])
    {
        _narrationImage.image = [UIImage imageNamed:@"NarrationOn.png"];
    }
    else
    {
        _narrationImage.image = [UIImage imageNamed:@"NarrationOff.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SoundState"])
    {
        _soundImage.image = [UIImage imageNamed:@"SoundOn.png"];
    }
    else
    {
        _soundImage.image = [UIImage imageNamed:@"SoundOff.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MusicState"])
    {
        _musicImage.image = [UIImage imageNamed:@"MusicOn.png"];
    }
    else
    {
        _musicImage.image = [UIImage imageNamed:@"MusicOff.png"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextState"])
    {
        _textImage.image = [UIImage imageNamed:@"TextOn.png"];
    }
    else
    {
        _textImage.image = [UIImage imageNamed:@"TextOff.png"];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeButton:(id)sender {
    [self.delegate unwindToMainMenu];
    [self.delegate goHome];
}

- (IBAction)pageSelectButton:(id)sender {
    if(!_wait)
    {
        _wait = true;
        _waitTimer = [NSTimer scheduledTimerWithTimeInterval: 1.1
                                                      target: self
                                                    selector: @selector(waitOver:)
                                                    userInfo: nil
                                                     repeats: NO];
        [self.delegate pageSelectClicked];
    }
    
    //[self.delegate unwindToMainMenu];
}
- (IBAction)toggleMusic:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MusicState"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MusicState"];
        [SoundManager muteMusic];
        _musicImage.image = [UIImage imageNamed:@"MusicOff.png"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MusicState"];
        [SoundManager unmuteMusic];
        _musicImage.image = [UIImage imageNamed:@"MusicOn.png"];
    }
}

- (IBAction)toggleSound:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SoundState"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SoundState"];
        [SoundManager muteSound];
        [self.delegate muteSound:YES];
        _soundImage.image = [UIImage imageNamed:@"SoundOff.png"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SoundState"];
        [SoundManager unmuteSound];
        [self.delegate muteSound:NO];
        _soundImage.image = [UIImage imageNamed:@"SoundOn.png"];
        
    }
    //NSLog(@"Sound: %hhd", [[NSUserDefaults standardUserDefaults] boolForKey:@"SoundState"]);
}

- (IBAction)ToggleNarration:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NarrState"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NarrState"];
        [SoundManager muteNarration];
        _narrationImage.image = [UIImage imageNamed:@"NarrationOff.png"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NarrState"];
        [SoundManager unmuteNarration];
        _narrationImage.image = [UIImage imageNamed:@"NarrationOn.png"];
        
    }
    //NSLog(@"Narration: %hhd", [[NSUserDefaults standardUserDefaults] boolForKey:@"NarrState"]);
    
}
- (IBAction)toggleText:(id)sender {
    if(!_wait)
    {
        _wait = true;
        _waitTimer = [NSTimer scheduledTimerWithTimeInterval: 0.6
                                                      target: self
                                                    selector: @selector(waitOver:)
                                                    userInfo: nil
                                                     repeats: NO];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextState"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TextState"];
            [self.delegate toggleText: NO];
            _textImage.image = [UIImage imageNamed:@"TextOff.png"];
        
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TextState"];
            [self.delegate toggleText: YES];
            _textImage.image = [UIImage imageNamed:@"TextOn.png"];
        
        }
    }
    
}


-(void) setTheDelegate:(id<SettingsViewControllerDelegate>)delegate
{
    _delegate = delegate;
    NSLog(@"%@", _delegate);
}

-(void)waitOver:(NSTimer*)timer
{
    _wait = false;
    [_waitTimer invalidate];
}




@end