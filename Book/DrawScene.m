//
//  DrawScene.m
//  Book
//
//  Created by Dustin Bayer on 4/12/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "DrawScene.h"

@implementation DrawScene

-(id)initWithSize:(CGSize)size
{
    
    if (self = [super initWithSize:size]) {

        self.touchEnabled = YES;
        _bookMoved = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"deskBackground.tif"];
        background.position = CGPointMake(512, 300);
        [self addChild:background];
        
        _node = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(130, 175)];
        _node.position = CGPointMake(830, 440);
        _node.zRotation = M_PI/-7;
        _node.name = @"drawButton";
        [self addChild:_node];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node2 = [self nodeAtPoint:location];
    
    
  
    if ([node2.name isEqualToString:@"drawButton"] && self.touchEnabled) {
       // _touchEnabled = NO;
        [self.delegate drawingSegue];
    }
    
    //NSLog(@"%f, %f", location.x, location.y);
}

@end
