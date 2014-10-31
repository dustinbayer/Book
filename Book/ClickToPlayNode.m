//
//  ClickToPlayNode.m
//  Book
//
//  Created by Alec Tyre on 6/13/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "ClickToPlayNode.h"



typedef void(^block)(void);

@interface ClickToPlayNode ()
{
    block animationBeginBlock;
    block animationCompleteBlock;
}

@property AVPlayer* player;
@property BOOL playing;

@property (nonatomic, copy) block animationBeginBlock;
@property (nonatomic, copy) block animationCompleteBlock;

@end

@implementation ClickToPlayNode

@synthesize animationBeginBlock;
@synthesize animationCompleteBlock;


-(id)initWithMovieNamed:(NSString *)fileName andExtension:(NSString *)extension {
    
    self.player = [AVPlayer playerWithPlayerItem: [AVPlayerItem playerItemWithURL: [[NSBundle mainBundle] URLForResource:fileName withExtension:extension]]];
    
    self = (ClickToPlayNode*)[super initWithAVPlayer: self.player];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieComplete:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
    //If we exist, set properties to initial states
    if(self)
    {
        animationBeginBlock = ^{};
        animationCompleteBlock = ^{};
        self.playing = NO;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.playing) {
        self.playing = YES;
        [self play];
        animationBeginBlock();
    }
}

-(void)movieComplete:(NSNotification *)notification {
    animationCompleteBlock();
    [self.player seekToTime: CMTimeMakeWithSeconds(0, 1)];
    [self pause];
    self.playing = NO;
}


-(void)setAnimationBeginBlock:(void (^)(void))block {
    animationBeginBlock = block;
}


-(void)setAnimationCompleteBlock:(void (^)(void))block {
    animationCompleteBlock = block;
}


@end
