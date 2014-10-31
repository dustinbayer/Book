//
//  FullVideoViewController.m
//  Book
//
//  Created by Dustin Bayer on 4/25/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "FullVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FullVideoViewController ()
@property MPMoviePlayerController *player;
@property UIButton *doneButton;
@property UIButton *fullscreenButton;
@property UISlider *slider;
@property UILabel *currentTime;
@property UILabel *videoLength;
@property NSTimer *updateTimer;
@property UIButton *playPauseButton;
@property UIButton *playPauseButtonFull;
@property bool isPaused;

@end

@implementation FullVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"fullVideoCompressed2" withExtension:@"mp4"];
    _player = [[MPMoviePlayerController alloc] initWithContentURL: url];
    [_player setControlStyle:MPMovieControlStyleNone];
    [_player prepareToPlay];
     NSLog(@"%f", _player.duration);
    [_player.view setFrame: /*CGRectMake(0, 0, 1024, 650)*/CGRectMake(450, 300, 400, 300)];  // player's frame must match parent's
    [self.view addSubview: _player.view];
    
    [_player play];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                    target: self
                                                  selector: @selector(timerUpdate:)
                                                  userInfo: nil
                                                   repeats: YES];
    
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(5, 5, 100, 50);
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_doneButton.titleLabel setShadowColor:[UIColor blackColor]];
    [_doneButton.titleLabel setShadowOffset:CGSizeMake(-1, 1)];
    
    
    _fullscreenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_fullscreenButton addTarget:self action:@selector(fullButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_fullscreenButton setTitle:@"Full" forState:UIControlStateNormal];
    _fullscreenButton.frame = CGRectMake(0, 0, 50, 30);
    [_fullscreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fullscreenButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_fullscreenButton.titleLabel setShadowColor:[UIColor blackColor]];
    [_fullscreenButton.titleLabel setShadowOffset:CGSizeMake(-1, 1)];
    
    
    [_player.view addSubview:_fullscreenButton];
    
    _playPauseButtonFull = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_playPauseButtonFull addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_playPauseButtonFull setTitle:@"" forState:UIControlStateNormal];
    _playPauseButtonFull.frame = CGRectMake(0, 75/2, 400, 225);
    _playPauseButtonFull.backgroundColor = [UIColor clearColor];
    //_playPauseButtonFull.alpha = .5;
    _isPaused = false;
    
    [_player.view addSubview:_playPauseButtonFull];
    
    _playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_playPauseButton addTarget:self action:@selector(playPauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    _playPauseButton.frame = CGRectMake(-2, 265, 50, 30);
    [_playPauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playPauseButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_playPauseButton.titleLabel setShadowColor:[UIColor blackColor]];
    [_playPauseButton.titleLabel setShadowOffset:CGSizeMake(-1, 1)];
    
    [_player.view addSubview:_playPauseButton];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(_player.view.frame.size.width/2-112.5, _player.view.frame.size.height - 30, 225, 20.0)];
    [_slider addTarget:self action:@selector(updateside:) forControlEvents:UIControlEventValueChanged];
    [_slider setBackgroundColor:[UIColor clearColor]];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = [_player duration];
    _slider.continuous = YES;
    [_slider setValue:0.0];
    
    _videoLength = [[UILabel alloc] initWithFrame:CGRectMake(_player.view.frame.size.width/2 +120, _player.view.frame.size.height - 45, 100, 50)];
    _videoLength.textColor = [UIColor whiteColor];
    _videoLength.backgroundColor = [UIColor clearColor];
    
    _videoLength.text = [[NSString alloc] initWithFormat:@"%d:%2d", (int)[_player duration]/60, (int)[_player duration] % 60];
    [_player.view addSubview:_videoLength];
    
    
    _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(_player.view.frame.size.width/2 -150, _player.view.frame.size.height - 45, 100, 50)];
    _currentTime.textColor = [UIColor whiteColor];
    _currentTime.backgroundColor = [UIColor clearColor];
    
    _currentTime.text = [[NSString alloc] initWithFormat:@"0:00"];
    [_player.view addSubview:_currentTime];
    
    
    [_player.view addSubview:_slider];
}

- (void) movieFinished {
   //[_updateTimer invalidate];
    _player.currentPlaybackTime = 0;
    [_slider setValue:0];
    _currentTime.text = [[NSString alloc] initWithFormat:@"0:00"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_updateTimer invalidate];
}

-(IBAction)updateside:(id)sender
{
    [_player pause];
    UISlider * newSlider = (UISlider*)sender;
    //CGFloat currentPlayedTime = [_player currentPlaybackTime];
    NSLog(@"Slider Value: %.1f", [newSlider value]);
    
    _player.currentPlaybackTime = [newSlider value];
    _slider = newSlider;
    
    _currentTime.text = [[NSString alloc] initWithFormat:@"%d:%02d", (int)[newSlider value]/60, (int)[newSlider value] % 60];
    
    [_player play];
}

-(void)timerUpdate:(NSTimer*)timer
{
    [_slider setValue:_player.currentPlaybackTime];
    //CGFloat currentPlayedTime = [_player currentPlaybackTime];
    //NSLog(@"Slider Value: %.1f", [newSlider value]);
    
    
    //_player.currentPlaybackTime = [newSlider value];
    
    
    _currentTime.text = [[NSString alloc] initWithFormat:@"%d:%02d", (int)[_slider value]/60, (int)[_slider value] % 60];
    
    if(_player.currentPlaybackTime > 461)
        [self movieFinished];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass: UISlider.class]) {
        
        [_player pause];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass: UISlider.class]) {
        
        [_player play];
    }
}

-(IBAction)doneButtonClicked:(id)sender
{
    [_doneButton removeFromSuperview];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Shrink!
                         _player.view.frame = CGRectMake(450, 300, 400, 300);
                         _playPauseButtonFull.frame = CGRectMake(0, 75/2, 400, 225);
                         _playPauseButton.frame = CGRectMake(-2, 265, 50, 30);
                         _slider.frame = CGRectMake(_player.view.frame.size.width/2-112.5, _player.view.frame.size.height - 30, 225, 20.0);
                         _videoLength.frame = CGRectMake(_player.view.frame.size.width/2+120, _player.view.frame.size.height - 45, 100, 50);
                         _currentTime.frame = CGRectMake(_player.view.frame.size.width/2-150, _player.view.frame.size.height - 45, 100, 50);
                     }
                     completion:^(BOOL finished){
                         [_player.view addSubview:_fullscreenButton];
                     }];
    
}

-(IBAction)fullButtonClicked:(id)sender
{
    [_fullscreenButton removeFromSuperview];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         _player.view.frame = CGRectMake(0, 0, 1024, 768);
                         _playPauseButtonFull.frame = CGRectMake(0, 192/2, 1024, 576);
                         _playPauseButton.frame = CGRectMake(20, 685, 100, 50);
                         _slider.frame = CGRectMake(_player.view.frame.size.width/2-256, _player.view.frame.size.height - 75, 512, 40.0);
                         _videoLength.frame = CGRectMake(_player.view.frame.size.width/2+265, _player.view.frame.size.height - 80, 100, 50);
                         _currentTime.frame = CGRectMake(_player.view.frame.size.width/2-300, _player.view.frame.size.height - 80, 100, 50);
                     }
                     completion:^(BOOL finished){
                         [_player.view addSubview:_doneButton];
                     }];
    
    
}

-(IBAction)playPauseButtonClicked:(id)sender
{
    if(_isPaused)
    {
        [_player play];
        _isPaused = false;
        [_playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
    }
    else
    {
        [_player pause];
        _isPaused = true;
        [_playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        
    }
}


#pragma mark - Navigation

- (IBAction)goHome:(id)sender {
    //[self performSegueWithIdentifier:@"toHome" sender:self];
    [_player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
