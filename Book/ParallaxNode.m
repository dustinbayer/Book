//
//  ParallaxNode.m
//
//  Created by Alec Tyre on 2/21/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import "ParallaxNode.h"

@implementation ParallaxNode

@synthesize offset = _offset;
@synthesize screenPosition = _screenPosition;
@synthesize position = _position;

-(id)init
{
    self = (ParallaxNode *)[super init];

    if(self)
    {
        [self setOffsetRatio: CGPointMake(0, 0)];
        [self setOffset:CGPointZero];
    }
    
    return self;
}


-(void)setPosition:(CGPoint)position
{
    CGPoint positionWithOffset = {position.x + (_offset.x * _offsetRatio.x), position.y + (_offset.y * _offsetRatio.y)};
    
    
    [super setPosition:positionWithOffset];
}


-(CGPoint)position
{
    //Return current position without offset
    CGPoint currentPosition = {[super position].x - (_offset.x * _offsetRatio.x), [super position].y - (_offset.y * _offsetRatio.y)};
    return currentPosition;
}

 
-(void)setOffset:(CGPoint)offset
{
    //Find current position without offset
    CGPoint positionWithoutOffset = {[super position].x - (_offset.x * _offsetRatio.x), [super position].y - (_offset.y * _offsetRatio.y)};
    
    //Store offset
    _offset.x = offset.x;
    _offset.y = offset.y;
    
    CGPoint positionWithOffset = {positionWithoutOffset.x + (_offset.x * _offsetRatio.x), positionWithoutOffset.y + (_offset.y * _offsetRatio.y)};
    
    
    [super setPosition:positionWithOffset];
}


-(CGPoint)offset
{
    //Return offset
    return _offset;
}


-(void)setScreenPosition:(CGPoint)screenPosition
{
    //Todo setter override
    //Set actual screen position while maintaining offset and parallaxRatio
}

-(CGPoint)screenPosition
{
    //Return screen position
    return self.position;
}



@end
