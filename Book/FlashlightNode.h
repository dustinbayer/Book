//
//  FlashlightNode.h
//  Flashlight02
//
//  Created by Oleksandra Keehl on 4/19/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FlashlightNode : SKSpriteNode
-(void)animate;
-(id)initWithTextureAtlasNamed: (NSString *) textureAtlasName isReversible:(BOOL) reversible isLooping:(BOOL) looping;
@end
