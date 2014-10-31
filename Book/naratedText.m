//
//  naratedText.m
//  Timer
//
//  Created by Oleksandra Keehl on 2/22/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import "naratedText.h"
#import "ListOfText.h"

@interface naratedText()

@property CGFloat maxOffset;
@property CGFloat textSpeed;
@property CGFloat startPoint;

//@property NSDate *refDate;
@end

@implementation naratedText
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _paused = NO;
    }
    return self;
}

-(void)timerInit{
    
    _currPart = 1;
    NSDate* timerDelay = [NSDate dateWithTimeIntervalSinceNow:10.0f];
    self.timer = [[NSTimer alloc] initWithFireDate:timerDelay interval:10 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.startPoint = 0;
    
}

-(void)timerStop{
    if([self.timer isValid])
    {
        [self.timer invalidate];
        
    }
}

-(void)changeText
{

     if(_paused == NO && _currPart < _numOfParts)
     {
         _currPart++;
         self.text = [[[ListOfText alloc] init] getText:_currPage getPart: _currPart];
     }
    else
    {
        [self.timer invalidate];
    }
}

-(void)onTap
{
    if([self.timer isValid])
    {
        //[self.timer invalidate];
    
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self onTap];
}

-(void)nextPart
{
    if(_paused == NO && _currPart < _numOfParts)
    {
        _currPart++;
        self.text = [[[ListOfText alloc] init] getText:_currPage getPart: _currPart];
    }
    
    if([self.timer isValid])
    {
        [self.timer invalidate];
        
    }
}

-(void)prevPart
{
    if(_paused == NO && _currPart > 1)
    {
        _currPart--;
        self.text = [[[ListOfText alloc] init] getText:_currPage getPart: _currPart];
    }
    
    if([self.timer isValid])
    {
        [self.timer invalidate];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
