//
//  DataViewController.m
//  Book
//
//  Created by Dustin Bayer on 2/6/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "DataViewController.h"
#import "ListOfText.h"

@interface DataViewController ()

@property PageScene *tempScene;

@property UIButton *nextButton;
@property UIButton *prevButton;
@property SKTransition *fadeTransition;

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _fadeTransition = [SKTransition fadeWithColor:[UIColor blackColor] duration:2];
    
    NSLog(@"%@", _savedDrawings);
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    _state = @"Video";

    _spriteView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, 1024, 576)];
    //[_spriteView setShowsNodeCount:YES];
    //[_spriteView setShowsFPS:YES];
    //[_spriteView setShowsDrawCount:YES];
    _spriteOriginal =  _spriteView.frame;
    _spriteHeight = _spriteView.frame.size.height;
    _spriteWidth = _spriteView.frame.size.width;
    
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 1024, 200)];
    _textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pagefiller.png"]];
    _textOriginal =  _textView.frame;
    _textHeight = _textView.frame.size.height;
    _textWidth = _textView.frame.size.width;
    
    _textBox = [[naratedText alloc] initWithFrame:CGRectMake(100, 30, 840, 150)];
    _textBox.backgroundColor = [UIColor clearColor];
    _textBox.editable = NO;
    _textBox.scrollEnabled = NO;
    
    /*_swipebarLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 576)];
    _swipebarRight = [[UIView alloc] initWithFrame:CGRectMake(924, 0, 100, 576)];
    _swipebarLeft.backgroundColor = [UIColor clearColor];
    _swipebarLeft.alpha = 0.5;
    _swipebarRight.backgroundColor = [UIColor clearColor];
    _swipebarRight.alpha = 0.5;
    */
    _skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_skipButton addTarget:self action:@selector(skipVideo:) forControlEvents:UIControlEventTouchUpInside];
    [_skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    _skipButton.frame = CGRectMake(825, 560, 100, 50);
    [_skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_skipButton.titleLabel setTextColor:[UIColor blackColor]];
    [_skipButton.titleLabel setShadowColor:[UIColor blackColor]];
    [_skipButton.titleLabel setShadowOffset:CGSizeMake(-1, 1)];
    //_skipButton.titleLabel.alpha = 0.50;
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_nextButton addTarget:self action:@selector(pressedNext:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
    _nextButton.frame = CGRectMake(825, 725, 100, 50);
    [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nextButton.titleLabel setTextColor:[UIColor blackColor]];
    [_nextButton.titleLabel setShadowColor:[UIColor blackColor]];
    [_nextButton.titleLabel setShadowOffset:CGSizeMake(-1, 1)];
    
    
    _prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_prevButton addTarget:self action:@selector(pressedPrev:) forControlEvents:UIControlEventTouchUpInside];
    [_prevButton setTitle:@"Prev" forState:UIControlStateNormal];
    _prevButton.frame = CGRectMake(750, 725, 100, 50);
    [_prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_prevButton.titleLabel setTextColor:[UIColor blackColor]];
    [_prevButton.titleLabel setShadowColor:[UIColor blackColor]];
    [_prevButton.titleLabel setShadowOffset:CGSizeMake(-1, 1)];
    _prevButton.alpha = 0;
    
    if(_showText == NO)
    {
        _spriteView.frame = CGRectMake(0, 100, 1024, 576);
        _textView.frame = CGRectMake(0, 768, 1024, 200);
        //_swipebarLeft.frame = CGRectMake(0, 100, 100, 576);
        //_swipebarRight.frame = CGRectMake(924, 100, 100, 576);
        _skipButton.frame = CGRectMake(825, 640, 100, 50);
        _nextButton.frame = CGRectMake(825, 925, 100, 50);
        _prevButton.frame = CGRectMake(750, 925, 100, 50);
        
        _textView.alpha = 0;
    }
    
    [[self.view subviews][0] addSubview:_spriteView];
    [[self.view subviews][0] addSubview:_textView];
    [_textView addSubview:_textBox];
    //[[self.view subviews][0] addSubview:_swipebarLeft];
    //[[self.view subviews][0] addSubview:_swipebarRight];
    [[self.view subviews][0] addSubview:_skipButton];
    [[self.view subviews][0] addSubview:_nextButton];
    [[self.view subviews][0] addSubview:_prevButton];
    
    _videoScene = [[VideoScene alloc] initWithSize:CGSizeMake(1024, 576)];
    _videoScene.page = _pageNumber;
    _videoScene.showText = _showText;
    _videoScene.delegate = self;
    _videoScene.muted = _soundMuted;

    
    [_spriteView presentScene: _videoScene];
    
    
    
    //NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: _pageNum.text ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *text = [[[ListOfText alloc] init] getText:_pageNumber getPart: 1];
    
    UIFont *font = [UIFont fontWithName:@"Times New Roman" size:24];
    
    _textBox.text = text;
    _textBox.currPage = _pageNumber;
    _textBox.numOfParts = [[[ListOfText alloc] init] getnumParts:_pageNumber];
    [_textBox setFont:font];
    [_textBox timerInit];
    
    if(_textBox.numOfParts == 1)
        _nextButton.alpha = 0;

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [_textBox timerStop];
    if([_state  isEqual: @"Video"])
    {
        [_videoScene stopVideo];
        _videoScene = nil;
    }
    else
    {
        _currScene = nil;
    }
}

-(void)addInteractive
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    _state = @"Interactive";
    _videoScene = nil;
    [_skipButton removeFromSuperview];
    [self.delegate removePause];
    
    
    //_tempScene = [[SKScene alloc] initWithSize:CGSizeMake(1024, 576)];
    
    switch (_pageNumber)
    {
        case 0:
        {
            _currScene = [[YardScene alloc] initWithSize:CGSizeMake(1024, 576)];
            _currScene.delegate = self;
            [_spriteView presentScene:_currScene transition: _fadeTransition];
            break;
        }
            
        case 1:
        {
            _currScene = [[DrawScene alloc] initWithSize:CGSizeMake(1024, 576)];
            _currScene.delegate = self;
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
        
        case 2:
        {
            _tempScene = [[PageScene alloc] initWithSize:CGSizeMake(1024, 576)];
            SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:@"underconstruction.jpg"];
            node.position = CGPointMake(512, 300);
            [_tempScene addChild:node];
            [_spriteView presentScene:_tempScene transition:_fadeTransition];
            break;
        }

        case 3:
        {
            _currScene = [[ForestScene alloc] initWithSize:CGSizeMake(1024, 576)];
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
            
        case 4:
        {
            _currScene= [[FogScene alloc] initWithSize:CGSizeMake(1024, 576)];
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
            
        case 5:
        {
            _currScene = [[CliffScene alloc] initWithSize:CGSizeMake(1024, 576)];
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
            
        case 6:
        {
            _currScene = [[FlashlightMyScene alloc] initWithSize:CGSizeMake(1024, 576)];
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
        
        case 7:
        {
            _currScene = [[SKStarTraceMyScene alloc] initWithSize:CGSizeMake(1024, 576)];
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
            
        case 8:
        {
            _currScene = [[EndScene alloc] initWithSize:CGSizeMake(1024, 576)];
            _currScene.delegate = self;
            _currScene.drawings = _savedDrawings;
            [_spriteView presentScene:_currScene transition:_fadeTransition];
            break;
        }
            
            
        default:
        {
            break;
        }
    }
    [self resignFirstResponder];
    
}

/*-(void) playNarration
{
    switch (_pageNumber)
    {
        case 0:
            [SoundManager playNarrationFromFile:@"narr1" withExt:@"wav" atVolume:1.0];
            break;
        case 1:
            [SoundManager playNarrationFromFile:@"narr2" withExt:@"wav" atVolume:1.0];
            break;
        case 2:
            [SoundManager playNarrationFromFile:@"narr3" withExt:@"wav" atVolume:1.0];
            break;
        case 3:
            [SoundManager playNarrationFromFile:@"narr4" withExt:@"wav" atVolume:1.0];
            break;
        case 4:
            [SoundManager playNarrationFromFile:@"narr5" withExt:@"wav" atVolume:1.0];
            break;
            
        default:
           
            break;
    }

}*/


-(void)toggleText:(BOOL) display
{
    
    if(display)
    {
        _showText = YES;
        _textView.alpha = 1;
        NSLog(@"Moving up");
        [UIView animateWithDuration:0.5
                         animations:^{
                             _spriteView.frame = CGRectMake(0, 0, 1024, 576);
                             _textView.frame = CGRectMake(0, 568, 1024, 200);
                             //_swipebarLeft.frame = CGRectMake(0, 0, 100, 576);
                            // _swipebarRight.frame = CGRectMake(924, 0, 100, 576);
                             _skipButton.frame = CGRectMake(825, 560, 100, 50);
                             _nextButton.frame = CGRectMake(825, 725, 100, 50);
                             _prevButton.frame = CGRectMake(750, 725, 100, 50);
                         }
                         completion:^(BOOL finished) {
                             //UIWindow *window = source.view.window;
                             //[window setRootViewController:destination];
                         }];

    }
    else
    {
        _showText = NO;
        NSLog(@"Moving down");
        [UIView animateWithDuration:0.5
                         animations:^{
                             _spriteView.frame = CGRectMake(0, 100, 1024, 576);
                             _textView.frame = CGRectMake(0, 768, 1024, 200);
                           //  _swipebarLeft.frame = CGRectMake(0, 100, 100, 576);
                            // _swipebarRight.frame = CGRectMake(924, 100, 100, 576);
                             _skipButton.frame = CGRectMake(825, 640, 100, 50);
                             _nextButton.frame = CGRectMake(825, 925, 100, 50);
                             _prevButton.frame = CGRectMake(750, 925, 100, 50);
                         }
                         completion:^(BOOL finished) {
                             _textView.alpha = 0;
                             //UIWindow *window = source.view.window;
                             //[window setRootViewController:destination];
                         }];
    }
}

-(IBAction)skipVideo:(id)sender
{
    [_videoScene stopVideo];
    [self addInteractive];
    
}

-(IBAction)pressedNext:(id)sender
{
    [_textBox nextPart];
    [self manageButtons];
    
    
}

-(IBAction)pressedPrev:(id)sender
{
    [_textBox prevPart];
    [self manageButtons];
    
}

-(void) drawingSegue
{
    [self.delegate drawingSegue];
}

-(void)returnHome
{
    [self.delegate goHome];
}

-(void) manageButtons
{
    if (_textBox.currPart == 1)
    {
        _prevButton.alpha = 0;
        _nextButton.alpha = 1;
    }
    else if (_textBox.currPart == _textBox.numOfParts)
    {
        _nextButton.alpha = 0;
        _prevButton.alpha = 1;
    }
    else
    {
        _prevButton.alpha = 1;
        _nextButton.alpha = 1;
    }
}

-(void)addSubsceen: (PageScene*)scene moveX:(float)x moveY:(float)y scale:(float)s fadeDelay:(BOOL)fade duration:(float)time
{
    
    SKView *newView =[[SKView alloc] initWithFrame:CGRectMake(0, 0, 1024, 576)];
    [[self.view subviews][0] insertSubview:newView atIndex:0];
    _currScene = nil;
    _currScene = scene;
    _currScene.delegate = self;
    [newView presentScene:_currScene];
    
    
    [UIView animateWithDuration:2
                     animations:^{
                         _spriteView.frame = CGRectMake(_spriteView.frame.origin.x +x, _spriteView.frame.origin.y +y, _spriteView.frame.size.width * s, _spriteView.frame.size.height * s);
                         
                    }completion:^(BOOL finished) {}];
    
    [UIView animateKeyframesWithDuration:time delay:fade options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                              animations:^{_spriteView.alpha = 0;}
                              completion:^(BOOL finished) {
                                  [_spriteView removeFromSuperview];
                                  _spriteView = nil;
                                  _spriteView = newView;
                              }];
    
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSMutableArray *) getsavedImages
{
   return [self.delegate getSavedImages];
    
}


@end
