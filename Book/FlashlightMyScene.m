//
//  FlashlightMyScene.m
//  Flashlight02
//
//  Created by Oleksandra Keehl on 3/19/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import "FlashlightMyScene.h"
#import "FlashlightNode.h"


@interface FlashlightMyScene()

@property CGPoint beamOrigin;
@property SKSpriteNode * background;
@property SKSpriteNode * light;
@property SKSpriteNode * beam;
@property double defaultLightHeight;
@property double defaultBeamHeight;
@property FlashlightNode * redFl;
@property SKSpriteNode *thomas;
@end

@implementation FlashlightMyScene



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size])
    {
        self.background = [SKSpriteNode spriteNodeWithImageNamed:@"v.png"];
        self.background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self.background setSize: size];
        [self addChild:self.background];
        
        self.thomas = [SKSpriteNode spriteNodeWithImageNamed:@"fogThomas.png"];
        self.thomas.position = CGPointMake(180.0, 200.0);
        self.thomas.alpha = 0;
        [self addChild:self.thomas];
     
/****** this is the squigly thingie **********/
        self.redFl = [[FlashlightNode alloc] initWithTextureAtlasNamed:@"fl" isReversible:NO isLooping:YES];
        self.redFl.position = CGPointMake(580, 150);
        [self.redFl setScale:0.8];
        [self addChild:self.redFl];
        
        //fixed to look correct
/****** this is a grey field with a big blurry dot on it that creates the darkness with light effect **********/
        self.light = [SKSpriteNode spriteNodeWithImageNamed:@"newFlashlightCircle.png"];
        self.light.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self.light setScale:2.0];
        [self addChild:self.light];
/******* blendmode is what makes it a mask of sorts ******/
        self.light.blendMode = 3;
        
        //this is also a bit wrong
/******* the size of the light is a constant multiplied by a factor that depends on the distance of the touch from
        the point of origin (which is off screen). Since the size is constantly changing, I'm keeping the original
        value in the defaultLightHeight variable. The same is true for the beam. *******/
        self.defaultLightHeight = self.light.size.height;
        self.beam = [SKSpriteNode spriteNodeWithImageNamed:@"beam06.png"];
        self.beam.position = self.background.position;
        [self.beam setScale:2];
        [self addChild:self.beam];
        self.beam.blendMode = 1;
/****** the following line sets the anchor point of the beam (a spoon-shaped image) to the center of the spoon */
        self.beam.anchorPoint = CGPointMake(0.5, 1 - self.beam.frame.size.width/(2*self.beam.frame.size.height));
        self.defaultBeamHeight = self.beam.size.height;
        self.beamOrigin = CGPointMake(self.frame.size.width/2, -self.frame.size.height/4); //where our flashlight shines from (off screen)
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if(location.x < 100 || location.x > 924)
            break;
        
/* at first I find the angle for the line between the touch and origin point */
        double dX = location.x - self.beamOrigin.x;
        double dY = location.y - self.beamOrigin.y;
 
        double alpha = -atan(dX/dY);
/*then I move the location of the touch by 100 points on that line, so the finger is at the base of the light circle, not in the middle*/
        location.x -= 100*sin(alpha);
        location.y += 100*cos(alpha);
        dX -= 100*sin(alpha);
        dY += 100*cos(alpha);
/*this gradually moves the light to the adjusted touch point*/
        [self.light runAction:[SKAction moveTo:location duration:0.25]];
        [self.beam runAction:[SKAction moveTo:location duration:0.25]];
/*calculating the change in size for the light and beam and change them gradually */
        double distance = sqrt(dX*dX + dY*dY);
        double factor = 1.25 * distance/self.size.height;
        [self.beam runAction:[SKAction resizeToHeight:self.defaultBeamHeight*factor duration:0.25]];
/*gradually rotate the beam and light*/
        [self.beam runAction:[SKAction rotateToAngle:alpha duration:0.25 shortestUnitArc:YES]];//rotates around center
        if (factor > 1)
        {
            [self.light runAction:[SKAction resizeToHeight:self.defaultLightHeight*factor duration:0.25]];
            [self.light runAction:[SKAction rotateToAngle:alpha duration:0.25 shortestUnitArc:YES]];//rotates around center
        }
/*checking whether the wiggly thing is in view. Activate it if it is, deactivate it if it isn't*/
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        if([nodes containsObject:self.redFl])
            [self.redFl animate];
        else
            [self.redFl removeAllActions];
            
    }
}

/*much like touchesBegan but with addition of Thomas*/
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        if(location.x < 100 || location.x > 924)
            break;
        
        double dX = location.x - self.beamOrigin.x;
        double dY = location.y - self.beamOrigin.y;
        double alpha = -atan(dX/dY);
        self.beam.zRotation = alpha;
        location.x -= 100*sin(alpha);
        location.y += 100*cos(alpha);
        dX -= 100*sin(alpha);
        dY += 100*cos(alpha);
        
        self.light.position = location;
        self.beam.position = location;
        
        NSArray *nodes = [self nodesAtPoint:location];
        if([nodes containsObject:self.redFl])
            [self.redFl animate];
        else
            [self.redFl removeAllActions];
/*checking if thomas is in view*/
        if (([nodes containsObject:self.thomas]) && !self.thomas.hasActions)
        {//making Thomas fade in, stay for a bit and fade out
            [self.thomas runAction:[SKAction fadeAlphaTo:1 duration:1.5] completion:^
             {[self.thomas runAction: [SKAction waitForDuration:1.5] completion:^{[self.thomas runAction:[SKAction fadeAlphaTo:0 duration:1]];}];}];
        }
/*this is necessary to prevent wird jerking of the beam if it's in the middle of gradually moving for touchesBegan*/
        [self.light removeAllActions];
        [self.beam removeAllActions];

        
        double distance = sqrt(dX*dX + dY*dY);
        double factor = 1.25 * distance/self.size.height;
        self.beam.size = CGSizeMake(self.beam.size.width, self.defaultBeamHeight * factor);
        
        if (factor > 1)
        {
            self.light.size = CGSizeMake(self.light.size.width, self.defaultLightHeight * factor);
            self.light.zRotation = alpha;
        }
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   
}

@end
