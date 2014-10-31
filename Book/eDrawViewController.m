//
//  eDrawViewController.m
//  eDraw
//
//  Created by Oleksandra Keehl on 3/10/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import "eDrawViewController.h"
#import "eDrawView.h"

@interface eDrawViewController ()

@property NSUInteger pageNum;

@property (strong, nonatomic) UIButton *exitButton;
@end

@implementation eDrawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_savedImages = [[NSMutableArray alloc] initWithArray: @[[UIImage imageNamed:@"dadDrawing.png"], [UIImage imageNamed:@"landscapeDrawing.png"],[UIImage imageNamed:@"momDrawing.png"], [UIImage imageNamed:@"momDrawing.png"]]];
    
    _savedImages = [[NSMutableArray alloc] initWithArray: [self.delegate getSavedImages]];
    //self.savedImages = @[[UIImage imageNamed:@"dadDrawing.png"], [UIImage imageNamed:@"landscapeDrawing.png"],[UIImage imageNamed:@"momDrawing.png"], [[UIImage alloc]init]];
    _pageNum = 0;
    _pageTitles = @[@"0", @"1", @"2", @"3"];
    _colors = @[_black, _red, _green, _blue, _yellow];
   // _savedImages = [[NSMutableArray alloc] init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    //self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    sketchbookViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width-400, self.view.bounds.size.height);
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
    
    CGRect buttonFrame = CGRectMake(525, 700, 100, 40);
    self.exitButton = [[UIButton alloc] initWithFrame:buttonFrame];
    self.exitButton.backgroundColor = [UIColor grayColor];
    [self.exitButton setTitle:@"Exit" forState:0];
    [self.exitButton addTarget:self action:@selector(pressedExitButton:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
}


- (IBAction)startWalkthrough:(id)sender {
    sketchbookViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (sketchbookViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    //_currPage = index;
    
    
    // Create a new view controller and pass suitable data.
    sketchbookViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sketchbookController"];
    //pageContentViewController.imageFile = self.pageImages[index];
    //pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageNumber = index;
    _pendingPage = index;
    pageContentViewController.delegate = self;
    pageContentViewController.drawing = _savedImages[index];

    //pageContentViewController.showText = _showText;
    //pageContentViewController.savedDrawings = _savedDrawings;
    //pageContentViewController.soundMuted = _soundMuted;
    
    _currentView = pageContentViewController;
    //[_currentDataView  becomeFirstResponder];
    
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((sketchbookViewController*) viewController).pageNumber;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((sketchbookViewController*) viewController).pageNumber;
    
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
        //_currentView = _pendingView;
        _pageNum = _pendingPage;
        
    }
    else if(!completed)
    {
        _currentView = previousViewControllers[0];
    }
    _isFlipping = NO;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldReceiveTouch:(UITouch *)touch
{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint point = [touch locationInView:self.view];
        //CGPoint vel = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        //NSLog(@"Velocity: %f, %f", vel.x, vel.y);
        if(point.x < 1024 -400)
        {
            NSLog(@"page flip recognizer");
            
            
            if(_isFlipping)
            {
                return NO;
            }
            if(point.x >= 50 && point.x < 1024-450)
            {
                return NO;
            }
            
            if(_pageNum == 0 && point.x < 50)
            {
                
                return NO;
            }
            else if(_pageNum == 3 && point.x > 1024-450)
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
        if(point.x < 50 || (point.x > 1024-450 && point.x < 1024 -400))
        {
            _isFlipping = NO;
            return NO;
        }
    }
    return NO;
    // return YES;
}

- (IBAction)pressedColor:(id)sender {
    NSLog(@"click");
    for(int i = 0; i < _colors.count; i++)
    {
        if(_colors[i] == sender)
        {
            _currentView.scene.color = i;
            break;
        }
    }
}

-(void)pressedExitButton:(UIButton*)sender
{
    
    //[self.savedImages insertObject:_currentView.scene.drawing atIndex:_pageNum];
    _savedImages[_pageNum] = _currentView.scene.drawing;
    [self.delegate doneDrawing:self.savedImages];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneDrawing:(UIImage *)savedImage
{
    _savedImages[_pageNum] = savedImage;
    //[self.delegate doneDrawing:_savedImages];
}

-(void) setTheDelegate:(id<DrawingControllerDelegate>)delegate
{
    _delegate = delegate;
}

@end
