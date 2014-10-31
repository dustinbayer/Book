//
//  PageScene.h
//  Book
//
//  Created by Dustin Bayer on 9/19/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol PageSceneDelegate

-(void)addSubsceen: (SKScene*) scene moveX:(float)x moveY:(float)y scale:(float)s fadeDelay:(BOOL)fade duration:(float)time;
-(void)drawingSegue;
-(void)returnHome;

@end

@interface PageScene : SKScene

@property (weak, nonatomic) id <PageSceneDelegate> delegate;
@property NSMutableArray *drawings;
@property BOOL touchEnabled;

@end
