//
//  DAGClickToPlayAnimation.m
//  Parallax
//
//  Created by Alec Tyre on 3/8/14.
//  Copyright (c) 2014 Alec Tyre. All rights reserved.
//

#import "DAGClickToPlayAnimation.h"

#import "DAGParallaxScene.h"
#import "SoundManager.h"

@interface DAGClickToPlayAnimation ()

@property SKTextureAtlas *textureAtlas;
@property NSArray *textures;
@property BOOL reversible;

@end

@implementation DAGClickToPlayAnimation

-(id)initWithTextureAtlasNamed: (NSString *) textureAtlasName isReversible: (BOOL) reversible
{
    //Get ze textureAtlas, if you can
    SKTextureAtlas *textureAtlas;
    
    @try {
        textureAtlas = [SKTextureAtlas atlasNamed: textureAtlasName];
    }
    @catch (NSException *exception) {
        NSLog(@"Error loading texture atlas: %@", [exception reason]);
    }
    @finally {
        //weep
    }
    
    //init the texture array
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    //Make an array to temporarily hold names of all the textures in the textureAtlas
    NSArray *textureNames = [textureAtlas textureNames];
    
    //Sort texture names
    textureNames = [textureNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //Use texture names to load textures into texture array
    for ( int i = 0; i < [textureNames count]; i++ ) {
        [textures addObject: [textureAtlas textureNamed:[textureNames objectAtIndex: i]]];
    }
    
    self = (DAGClickToPlayAnimation *)[super initWithTexture: textures[0] ];
                                       
    if(self)
    {
        self.textures = textures;
        self.textureAtlas = textureAtlas;
        self.reversible = reversible;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.hasActions)
    {
        [self animate];
        
        if(self.reversible)
        {
            self.textures = [self reverseArray: self.textures];
        }
        
        //[[(DAGParallaxScene *)self.scene soundManager] playAudioFileAtIndex: 0];
        
        
        [SoundManager playSoundFromFile:_sound withExt:@"mp3" atVolume:1];
        
    }
}

-(void)animate
{
    SKAction *animate = [SKAction animateWithTextures: self.textures timePerFrame: 0.04];
    [self runAction: animate completion:^{
        //Stuff when animation is complete
    }];
}

-(NSArray *)reverseArray: (NSArray *) array {
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    for (id element in enumerator) {
        [resultArray addObject:element];
    }
    return resultArray;
}

@end
