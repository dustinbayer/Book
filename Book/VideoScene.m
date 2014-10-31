//
//  SpriteScene.m
//  Book
//
//  Created by Dustin Bayer on 2/22/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "VideoScene.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundManager.h"

@interface VideoScene ()
@property BOOL contentCreated;
@property AVPlayer *player;
@property SKVideoNode *video;

@end


@implementation VideoScene

- (void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        //_page = 1;
    }
}

- (void)createSceneContents
{
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    //_page = 1;
    
    
    _video = self.newVideoNode;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieComplete:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
    
    [self addChild: _video];
}

-(SKVideoNode *)newVideoNode
{
    
    NSLog(@"%lu", _page);
    self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL: [[NSBundle mainBundle] URLForResource:[self getVideo] withExtension:@"mp4"]]];
    
    SKVideoNode *videoNode = [SKVideoNode videoNodeWithAVPlayer:self.player];

    videoNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    
    videoNode.name = @"videoNode";
    videoNode.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    //[videoNode play];
    
    //[self setSound];
    
    return videoNode;
}


-(NSString *) getVideo
{
    NSString *video = [[NSString alloc] init];
    
    switch (_page) {
        case 0:
            video = @"page1";
            break;
        case 1:
            video = @"page2";
            break;
        case 2:
            video = @"page4";
            break;
        case 3:
            video = @"page6";
            break;
        case 4:
            video = @"page8";
            break;
        case 5:
            video = @"page9";
            break;
        case 6:
            video = @"page10";
            break;
        case 7:
            video = @"page11";
            break;
        case 8:
            video = @"page12";
            break;
            
        default:
            break;
    }
    
    return video;
}


-(void) setSound
{
    
    switch (_page)
    {
        case 0:
            [SoundManager playNarrationFromFile:@"narr1" withExt:@"wav" atVolume:1.0];
            break;
        case 1:
            [SoundManager playNarrationFromFile:@"narr2" withExt:@"wav" atVolume:1.0];
            break;
        case 2:
            //[SoundManager playNarrationFromFile:@"narr3" withExt:@"wav" atVolume:1.0];
            break;
        case 3:
            [SoundManager playMusicFromFile:@"piano_clip" withExt:@"wav" atVolume:2.0];
            _muted = YES;
            break;
                    
        default:
            
            break;
    }
    [self muteSound];
    
    
}

-(void) playVideo
{
    
    [_video play];
}

-(void) stopVideo
{
    [_video pause];
}
-(void) muteSound
{
    if(_muted)
    {
        [_player setVolume:0.0];
    }
    else
    {
        [_player setVolume:1.0];
    }
}


-(void) movieComplete:(NSNotification *)notification
{
    //NSLog(@"%@", notification);
    //[_video removeFromParent];
    [_video pause];
    [self.delegate addInteractive];
}


@end
