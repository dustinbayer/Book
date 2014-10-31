//
//  FlashlightNode.m
//  Flashlight02
//
//  Created by Oleksandra Keehl on 4/19/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import "FlashlightNode.h"

@interface FlashlightNode()

@property SKTextureAtlas *textureAtlas;
@property NSArray *textures;
@property BOOL reversible;
@property BOOL looping;
@end

@implementation FlashlightNode

-(id)initWithTextureAtlasNamed: (NSString *) textureAtlasName isReversible:(BOOL) reversible isLooping:(BOOL)looping
{
    SKTextureAtlas * myAtlas;
    @try {
        myAtlas = [SKTextureAtlas atlasNamed:textureAtlasName];;
    }
    @catch (NSException *exception) {
        NSLog(@"woohoo");
    }
    @finally {
        //weep
    }
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    NSArray *textureNames = [myAtlas textureNames];
    textureNames = [textureNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (int i = 0; i < [textureNames count]; i++)
    {
        [textures addObject: [myAtlas textureNamed:[textureNames objectAtIndex: i]]];
    }
    
    self = (FlashlightNode *)[super initWithTexture:textures[0]];
    
    if(self)
    {
        self.textures = textures;
        self.textureAtlas = myAtlas;
        self.reversible = reversible;
        self.looping = looping;
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)animate
{
    if(!self.hasActions)
    {
        SKAction *animate = [SKAction animateWithTextures: self.textures timePerFrame:0.1];
        if(self.looping)
        {
            [self runAction: [SKAction repeatActionForever:animate]];
        }
        else
        {
            [self runAction: animate];
        }
            
        if(self.reversible)
        {
            self.textures = [self reverseArray:self.textures];
        }
    }
}

-(NSArray*)reverseArray:(NSArray*) array
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    for (id element in enumerator)
    {
        [resultArray addObject:element];
    }
    return resultArray;
}

@end
