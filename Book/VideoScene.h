//
//  SpriteScene.h
//  Book
//
//  Created by Dustin Bayer on 2/22/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol VideoSceneDelegate

-(void)addInteractive;

@end

@interface VideoScene : SKScene
@property (weak, nonatomic) id <VideoSceneDelegate> delegate;
@property unsigned long  page;
@property BOOL muted;
@property BOOL showText;


-(void) setSound;
-(void) playVideo;
-(void) stopVideo;
-(void) muteSound;


@end
