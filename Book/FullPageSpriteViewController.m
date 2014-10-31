//
//  FullPageSpriteViewController.m
//  Book
//
//  Created by Dustin Bayer on 3/8/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "FullPageSpriteViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface FullPageSpriteViewController ()

@property UIButton *storyButton;
@property UIButton *videoButton;
@property FullVideoViewController *fullVideoView;

@end

@implementation FullPageSpriteViewController

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"fullVideo"]) {
        _fullVideoView = [segue destinationViewController];
        //_fullVideoView.homeView = sender;
        
        
        //[[segue destinationViewController] setDelegate:self];
        //UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        //self.pageSelectPopoverController = popoverController;
        //popoverController.delegate = self;
    }
}

-(void) addHome
{
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_screen_002.jpg"]];
    [self.view addSubview:background];
    
    
    
    _storyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_storyButton addTarget:self action:@selector(goToStory:) forControlEvents:UIControlEventTouchUpInside];
    [_storyButton setTitle:@"" forState:UIControlStateNormal];
    _storyButton.frame = CGRectMake(355, 280, 250, 30);
    
    
    [self.view addSubview:_storyButton];
    
    _videoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_videoButton addTarget:self action:@selector(goToVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_videoButton setTitle:@"" forState:UIControlStateNormal];
    _videoButton.frame = CGRectMake(355, 345, 250, 30);
    
    
    
    [self.view addSubview:_videoButton];
    
}

- (IBAction)goToStory:(id)sender {
    [self.delegate goStory];
    
    //NSLog(@"gotoStory");
}

- (IBAction)goToVideo:(id)sender {
    //_spriteScene = [[FullSpriteScene alloc] initWithSize:CGSizeMake(1024, 768)];
    
   // _spriteScene.muted = NO;
    //SKView *spriteView = (SKView *) [self.view subviews][0];
    //[spriteView presentScene: _spriteScene];
    
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"fullVideo" withExtension:@"mov"];
    //MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //[self presentMoviePlayerViewControllerAnimated:movie];
    
    //[self.delegate gotoFullVideo];
    _fullVideoView = [[FullVideoViewController alloc] init];
    [self performSegueWithIdentifier:@"fullVideo" sender:self];
    
}

@end
