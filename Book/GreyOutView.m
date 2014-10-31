//
//  GreyOutView.m
//  Book
//
//  Created by Dustin Bayer on 4/4/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "GreyOutView.h"

@implementation GreyOutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((1024/2 - 250/2), (576/2 - 250/2), 250, 250)];
        
        imageView.image = [UIImage imageNamed:@"pause.png"];
        
        [self addSubview:imageView];
        _wait = true;
        
        _waitTimer = [NSTimer scheduledTimerWithTimeInterval: 1.1
                                                        target: self
                                                      selector: @selector(waitOver:)
                                                      userInfo: nil
                                                       repeats: NO];
    }
    return self;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!_wait)
    {
        [self.delegate closeSettings];
    }
    
}

-(void)waitOver:(NSTimer*)timer
{
    _wait = false;
    [_waitTimer invalidate];
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
