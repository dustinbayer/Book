//
//  MyScene.h
//  drawingTest
//

//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol SketchbookSceneDelegate

- (UIImage *)snapshot:(UIView *)view;

@end

@interface SketchbookScene : SKScene
@property (weak, nonatomic) id <SketchbookSceneDelegate> delegate;
@property UIImage *drawing;
@property NSString *drawingName;
@property SKSpriteNode *drawingBackground;
@property SKSpriteNode *drawingNode;
@property int color;
@end
