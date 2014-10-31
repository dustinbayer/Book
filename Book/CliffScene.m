//
//  CliffScene.m
//  Book
//
//  Created by Dustin Bayer on 7/8/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "CliffScene.h"

@implementation CliffScene

-(id)initWithSize:(CGSize)size
{
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"opaque.png"];
        background.position = CGPointMake(512, 300);
        [self addChild:background];
        
        
    }
    
    return self;
}

@end
