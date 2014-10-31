//
//  ToychestScene.m
//  Book
//
//  Created by Dustin Bayer on 9/22/14.
//  Copyright (c) 2014 Starthief Studio. All rights reserved.
//

#import "ToychestScene.h"
#import "EndScene.h"

@implementation ToychestScene


-(id)initWithSize:(CGSize)size
{
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"toyChestMock.png"];
        background.position = CGPointMake(512, 576/2);
        background.size = size;
        [self addChild:background];
        _node = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)];
        _node.position = CGPointMake(50, 50);
        _node.name = @"back";
        [self addChild:_node];
        self.touchEnabled = true;
        
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node2 = [self nodeAtPoint:location];
    
    if ([node2.name isEqualToString:@"back"] && self.touchEnabled) {
        [self.delegate addSubsceen:[[EndScene alloc] initWithSize:CGSizeMake(1024, 576)] moveX:0 moveY:0 scale:1 fadeDelay:NO duration:1];
    }
    
}

-(void) dealloc
{
    
    NSLog(@"-----------------DEALLOCATED CHEST SCEEN-------------------");
}

@end