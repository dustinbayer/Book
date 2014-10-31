//
//  ViewController.m
//  Book
//
//  Created by Dustin Bayer on 2/21/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "ViewController.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "SoundManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FModHelper.h"

@interface ViewController ()

@property FullPageSpriteViewController *fullSpriteView;
@property FullVideoViewController *fullVideoView;

@property BOOL isSettings;
@property BOOL isFlipping;
@property BOOL isPageSelect;
@property NSUInteger pageNum;
@property NSUInteger pendingPage;
@property NSMutableArray *savedDrawings;
@property BOOL videoPaused;
@property UIImageView *pauseImage;
@property MPMoviePlayerController *videoView;
@property BOOL introPlaying;
@property bool canTouchSettingsButton;

@end

@implementation ViewController

UIPopoverController *popover;

- (void)viewDidLoad
{
    _savedDrawings = [[NSMutableArray alloc] initWithArray: @[[UIImage imageNamed:@"dadDrawing.png"], [UIImage imageNamed:@"landscapeDrawing.png"],[UIImage imageNamed:@"momDrawing.png"], [UIImage imageNamed:@"momDrawing.png"]]];
    
    _introPlaying = YES;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_sequence_001" ofType:@"mov"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    _videoView = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    
    [_videoView.view setFrame: CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:_videoView.view];
    [_videoView setControlStyle:MPMovieControlStyleNone];
    
    [_videoView play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introMovieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:_videoView];
    
    
    
}

- (void)introMovieFinished:(NSNotification *)notification
{
    [_videoView.view removeFromSuperview];
    _videoView = nil;
    
    _introPlaying = NO;
    // Create the data model
    
    [FModHelper initializeFModSystem];
    
    [FModHelper loadBankWithPath:@"Master Bank.bank"];
    [FModHelper loadBankWithPath:@"Master Bank.strings.bank"];
    
    _pageTitles = @[@"1", @"2", @"3", @"4",@"5",@"6",@"7",@"8",@"9"];

    
    [self gotoHome];
    
    
    _showText = YES;
    _isSettings = NO;
    _isPageSelect = NO;
    _soundMuted = NO;
    _pageNum = 0;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MusicState"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SoundState"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NarrState"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TextState"];
    _canTouchSettingsButton = true;
    
    for (UIGestureRecognizer *gR in self.pageViewController.gestureRecognizers) {
        gR.delegate = self;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {
    DataViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    //_currPage = index;
    
    
    // Create a new view controller and pass suitable data.
    DataViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    //pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageNumber = index;
    _pendingPage = index;
    pageContentViewController.delegate = self;
    pageContentViewController.showText = _showText;
    pageContentViewController.savedDrawings = _savedDrawings;
    pageContentViewController.soundMuted = _soundMuted;
    
    _currentDataView = pageContentViewController;
    //[_currentDataView  becomeFirstResponder];

    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DataViewController*) viewController).pageNumber;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((DataViewController*) viewController).pageNumber;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
        if(completed)
        {
            [SoundManager stopAll];
            [_currentDataView.videoScene setSound];
            [_currentDataView.videoScene  playVideo];
            _pageNum = _pendingPage;
            _videoPaused = NO;
        }
        else if(!completed)
        {
            _currentDataView = previousViewControllers[0];
        }
        _isFlipping = NO;
}


#pragma mark - Settings View Controller - Page View Controller

- (IBAction)showSettings:(id)sender {
    NSLog(@"%@", _settings);
    if(_isSettings == NO)
    {
        _canTouchSettingsButton = false;
        _isSettings = YES;
        _settingsGreyOut = [[GreyOutView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        _settingsGreyOut.backgroundColor = [UIColor blackColor];
        _settingsGreyOut.alpha = 0.5;
        _settingsGreyOut.delegate = self;
        [self.view addSubview:_settingsGreyOut];
        [_settings setTheDelegate:self];
        
        [self performSegueWithIdentifier:@"settingsMenu" sender:self];
        if(_currentDataView)
        {
            //self.view.backgroundColor = [UIColor blackColor];
            //self.view.alpha = 0.5;
            self.view.gestureRecognizers = nil;
            [_settings  becomeFirstResponder];
            if([_currentDataView.state isEqual:@"Video"])
            {
                [_currentDataView.videoScene stopVideo];
            }
            [SoundManager pauseAll];
            _currentDataView.textBox.paused = YES;
            if(_videoPaused)
            {
                [_pauseImage removeFromSuperview];
                _videoPaused = NO;
                
            }
        }
    }
    else if(_canTouchSettingsButton)
    {
        [self unwindToMainMenu];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.settingsPopoverController = nil;
    self.pageSelectPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"settingsMenu"]) {
        
        _settings = [segue destinationViewController];
        _settings.delegate = self;
        
        //NSLog(@"%@", [segue destinationViewController]);
        //[[segue destinationViewController] setDelegate:self];
        //UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        //self.settingsPopoverController = popoverController;
        //popoverController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"pageSelect"]) {
        _pageSelect = [segue destinationViewController];
        _pageSelect.delegate = self;
        
        //[[segue destinationViewController] setDelegate:self];
        //UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        //self.pageSelectPopoverController = popoverController;
        //popoverController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"drawing"]) {
        _drawing = [segue destinationViewController];
        _drawing.delegate = self;
        //[_drawing.savedImages addObjectsFromArray:_savedDrawings];
        
        //[[segue destinationViewController] setDelegate:self];
        //UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        //self.pageSelectPopoverController = popoverController;
        //popoverController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"fullVideo"]) {
        _fullVideoView = [segue destinationViewController];
        //_drawing.delegate = self;
        
        [[segue destinationViewController] setDelegate:self];
        //UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        //self.pageSelectPopoverController = popoverController;
        //popoverController.delegate = self;
    }
}

-(void)closeSettings
{
    [self unwindToMainMenu];
    
    if(_isPageSelect == YES)
    {
        [self unwindPageSelect];
    }
}


- (void)unwindToMainMenu
{
    
    [_settingsGreyOut removeFromSuperview];
    
    SettingsUnwindSegue *segue = [[SettingsUnwindSegue alloc] initWithIdentifier:@"UnwindSettings" source:_settings destination:self];
    segue.delegate = self;
    [segue perform];
}


-(void) goHome
{
    if(_pageViewController)
    {
        [self removePageViewController];
        [self gotoHome];
    }
    else
    {
        //_fullSpriteView.spriteScene = nil;
    }
    
    if(_pageSelect)
    {
        [self unwindPageSelect];
    }
}



- (void)pageSelectClicked
{
    //[self performSegueWithIdentifier:@"pageSelect" sender:self];
    if(_isPageSelect == NO)
    {
        _isPageSelect = YES;
        
        [_pageSelect setTheDelegate:self];
        //_pageSelect.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageSelectMenu.png"]];
        
        [self performSegueWithIdentifier:@"pageSelect" sender:self];
        
    }
    else
    {
        [self unwindPageSelect];
    }
}

- (void)unwindPageSelect
{
    _isPageSelect = NO;
    PageSelectUnwindSegue *segue = [[PageSelectUnwindSegue alloc] initWithIdentifier:@"UnwindPageSelect" source:_pageSelect destination:self];
    //segue.delegate = self;
    [segue perform];
}

- (void)pageSelectViewControllerDidFinish:(PageSelectViewController *)controller
{
    //[self.pageSelectPopoverController dismissPopoverAnimated:YES];
}


-(void) toggleText: (BOOL) state
{
    if(state == YES)
    {
        //self.currentDataView.spriteScene.muted = YES;
        _showText = YES;
        NSLog(@"text on");
    }
    else
    {
        //self.currentDataView.spriteScene.muted = NO;
        _showText = NO;
        NSLog(@"text off");
    }
    [_currentDataView toggleText:_showText];
}

-(void)gotoPage:(int) pageNumber
{
    
    [SoundManager stopAll];
    
    if(_isSettings)
    {
        [_settingsGreyOut removeFromSuperview];
        [self unwindPageSelect];
        [self unwindToMainMenu];
    }
    
    if(_fullSpriteView)
    {
        [self gotoStory];
        
    }
    
    if(pageNumber == _pageNum)
    {
        [_currentDataView.videoScene  playVideo];
        [_currentDataView.videoScene  setSound];
    }
    else if(pageNumber > _pageNum)
    {
        NSArray *viewControllers = @[[self viewControllerAtIndex:(pageNumber)]];
        [self.pageViewController setViewControllers: viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [_currentDataView.videoScene  playVideo];
        //_currentDataView.spriteScene.page = pageNumber;
        [_currentDataView.videoScene  setSound];
    }
    else if(pageNumber < _pageNum)
    {
        NSArray *viewControllers = @[[self viewControllerAtIndex:(pageNumber)]];
        [self.pageViewController setViewControllers: viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        [_currentDataView.videoScene  playVideo];
        //_currentDataView.spriteScene.page = pageNumber;
        [_currentDataView.videoScene  setSound];
    }
    
    _pageNum = pageNumber;

    
}

-(void) muteSound:(BOOL)muted
{
    _soundMuted = muted;
    _currentDataView.videoScene.muted = muted;
    [_currentDataView.videoScene  muteSound];
}

#pragma mark - Sprite View Controller
-(void) removeSpriteViewController
{
    
    [_fullSpriteView willMoveToParentViewController:nil];
    [_fullSpriteView.view removeFromSuperview];
    [_fullSpriteView removeFromParentViewController];
    _fullSpriteView = nil;
    
   
}

-(void) removePageViewController
{
    
    [SoundManager stopAll];
    _currentDataView = nil;
    [_pageViewController willMoveToParentViewController:nil];
    [_pageViewController.view removeFromSuperview];
    [_pageViewController removeFromParentViewController];
    _pageViewController = nil;
    
    
}

-(void) goStory
{
    [self gotoStory];
    [self gotoPage:0];
}

-(void) gotoStory
{
    
    
    [self removeSpriteViewController];
    
    [super viewDidLoad];
    _isFlipping = NO;
    // Create page view controller
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    //self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    DataViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    //self.pageViewController.view.backgroundColor = [UIColor clearColor];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.view insertSubview:_pageViewController.view atIndex:0];
    //[self.pageViewController didMoveToParentViewController:self];
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //_flipComplete = YES;
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    //self.view.gestureRecognizers = [UIPanGestureRecognizer class];
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers) {
        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
            tapRecognizer = recognizer;
            break;
        }
    }
    
    if ( tapRecognizer ) {
        [self.view removeGestureRecognizer:tapRecognizer];
        [self.pageViewController.view removeGestureRecognizer:tapRecognizer];
    }
    
    
    //[self gotoPage:0];
    //[_currentDataView.spriteScene playVideo];
    //[_currentDataView.spriteScene setSound];
    
    
    for (UIGestureRecognizer *gR in self.pageViewController.gestureRecognizers) {
        gR.delegate = self;
    }

    
}

-(void) gotoHome
{
    
    [super viewDidLoad];
    _pageNum = 0;
    _fullSpriteView = [[FullPageSpriteViewController alloc] init];
    _fullSpriteView = [self.storyboard instantiateViewControllerWithIdentifier:@"SpriteViewController"];
    _fullSpriteView.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self addChildViewController:_fullSpriteView];
    //[self.view addSubview:_fullSpriteView.view];
    [self.view insertSubview:_fullSpriteView.view atIndex:0];
    
    /*[self transitionFromViewController: _videoView
                      toViewController: _fullSpriteView
                              duration: 1
                               options: UI
                            animations: ^{
                            }
                            completion: ^{
                            }
     ];*/
    
    //[_fullSpriteView didMoveToParentViewController:self];
    _fullSpriteView.delegate = self;
    
    [_fullSpriteView addHome];
    
    
}

-(void) gotoFullVideo
{
    _fullVideoView = [[FullVideoViewController alloc] init];
    [self performSegueWithIdentifier:@"fullVideo" sender:self];
    
}

#pragma mark - Data View Controller

-(void)enableTouch
{
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers) {
        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
            tapRecognizer = recognizer;
            break;
        }
    }
    
    if ( tapRecognizer ) {
        [self.view removeGestureRecognizer:tapRecognizer];
        [self.pageViewController.view removeGestureRecognizer:tapRecognizer];
    }
    
    [self  becomeFirstResponder];
    if(_settings)
    {
        [_settings removeFromParentViewController];
        _isSettings = NO;
        _settings.view.alpha = 0;
    }
    
    //[_settingsGreyOut removeFromSuperview];
    
    if(_currentDataView)
    {
        //self.view.alpha = 1.0;
        if([_currentDataView.state isEqual:@"Video"])
        {
            [_currentDataView.videoScene  playVideo];
        }
        [SoundManager resumeAll];
        _currentDataView.textBox.paused = NO;
    }
    _isFlipping = NO;
    
    _canTouchSettingsButton = true;
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldReceiveTouch:(UITouch *)touch
{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint point = [touch locationInView:self.view];
        //CGPoint vel = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        //NSLog(@"Velocity: %f, %f", vel.x, vel.y);
        if(point.x < 100 || point.x > 924)
        {
            NSLog(@"page flip recognizer");
            
            
            if(_isFlipping)
            {
                return NO;
            }
            if(_pageNum == 0 && point.x < 100)
            {
               
                return NO;
            }
            else if(_pageNum == 8 && point.x > 924)
            {
               
                return NO;
            }
           // if(vel.y >)
            _isFlipping = YES;
            
            return YES;
        }
        
    }
    
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        CGPoint point = [touch locationInView:self.view];
        NSLog(@"tap");
        if(point.x < 100 || point.x > 924)
        {
            _isFlipping = NO;
            return NO;
        }
    }
    
    return NO;
}


-(void)drawingSegue;
{
    self.view.gestureRecognizers = nil;
    [self performSegueWithIdentifier:@"drawing" sender:self];
    [_drawing setTheDelegate:self];
}

-(void)doneDrawing:(NSMutableArray *)savedImages
{
    if(_savedDrawings == nil)
    {
        _savedDrawings = [[NSMutableArray alloc] init];
    }
    
    [_savedDrawings removeAllObjects];
    [_savedDrawings addObjectsFromArray:savedImages];
    
    _currentDataView.currScene.touchEnabled = YES;
    //DrawingUnwindSegue *segue = [[DrawingUnwindSegue alloc] initWithIdentifier:@"UnwindDrawing" source:_drawing destination:self];
    //segue.delegate = self;
    //[segue perform];
    [self enableTouch];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    CGPoint point = [touch locationInView:self.view];
    
    if(!_introPlaying)
    {
        if(point.y < 576 && point.x > 100 && point.x < 924)
        {
            if(_currentDataView && !_isFlipping)
            {
                if(!_videoPaused)
                {
                    if([_currentDataView.state isEqual:@"Video"])
                    {
                        _pauseImage = [[UIImageView alloc] initWithFrame:CGRectMake((1024/2 - 250/2), (576/2 - 250/2), 250, 250)];
                        
                        _pauseImage.image = [UIImage imageNamed:@"pause.png"];
                        
                        [_currentDataView.view addSubview:_pauseImage];
                        
                        [_currentDataView.videoScene stopVideo];
                        [SoundManager pauseAll];
                        _currentDataView.textBox.paused = YES;
                        _videoPaused = YES;
                    }
                }
                else
                {
                    if([_currentDataView.state isEqual:@"Video"])
                    {
                        
                        [_pauseImage removeFromSuperview];
                        [_currentDataView.videoScene playVideo];
                        [SoundManager resumeAll];
                        _currentDataView.textBox.paused = NO;
                        _videoPaused = NO;
                    }
                    
                }
                
            }
        }
    }
    else
    {
        [_videoView stop];
    }
    
    
    
}

-(void)removePause
{
    if(_videoPaused ==YES)
    {
        [_pauseImage removeFromSuperview];
        [SoundManager resumeAll];
        _currentDataView.textBox.paused = NO;
        _videoPaused = NO;
    }

}

-(NSMutableArray *) getSavedImages
{
    return _savedDrawings;
    
}

@end

