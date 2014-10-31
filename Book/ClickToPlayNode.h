//
//  ClickToPlayNode.h
//  Book
//
//  Created by Alec Tyre on 6/13/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ClickToPlayNode : SKVideoNode <AVAudioPlayerDelegate>

-(id)initWithMovieNamed:(NSString*)fileName andExtension:(NSString*)extension;

-(void)setAnimationBeginBlock: (void (^)(void))block;
-(void)setAnimationCompleteBlock: (void (^)(void))block;

@end
