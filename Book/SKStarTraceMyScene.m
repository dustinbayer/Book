//
//  SKStarTraceMyScene.m
//  SKStarTrace
//
//  Created by Oleksandra Keehl on 3/28/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import "SKStarTraceMyScene.h"

static NSString* smallStarCategoryName = @"smallStar";
static NSString* bigStarCategoryName = @"bigStar";
static int blueStarDepth = 10;
static int firstStarDepth = 9;
static int blueLineDepth = 8;
static int pictureDepth = 7;
static int yellowStarDepth = 6;
static int yellowLineDepth = 4;

@interface SKStarTraceMyScene()
@property NSMutableArray* smallStars;
@property NSMutableArray* catStars;
@property NSMutableArray* homeStars;
@property NSMutableArray* thomasStars;
@property int bigStarCounter;
@property SKSpriteNode* sky;
@property BOOL tracingSmallPath;
@property BOOL tracingBigPath;
@property SKNode * activeStar;
@property SKSpriteNode *activePath;
@property SKAction * lineGlow;
@property SKAction * starGlow;
@property CGFloat lineThickWidth;
@property CGFloat lineThinWidth;
@property BOOL drawingComplete;
@property NSMutableArray * currentConstelation;
@property BOOL outOfBounds;
@end


@implementation SKStarTraceMyScene

-(id)initWithSize:(CGSize)size {
    
    //UIImage* mySky = [UIImage imageNamed:@"starlessSky.png"];
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.sky = [SKSpriteNode spriteNodeWithImageNamed:@"1sky.png"];
        self.sky.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.sky.size = self.frame.size;
        [self addChild:self.sky];
        //the "glowing" lines fluctuate between these values:
        self.lineThickWidth = 9.0;
        self.lineThinWidth = 3.0;
        //creating an action sequence that makes the lines glow
        SKAction * expand = [SKAction resizeToWidth:self.lineThickWidth duration:0.5];
        SKAction * shrink = [SKAction resizeToWidth:self.lineThinWidth duration:0.5];
        NSMutableArray * glowActions = [[NSMutableArray alloc] init];
        [glowActions addObject:expand];
        [glowActions addObject:shrink];
        self.lineGlow = [SKAction sequence:glowActions];
        
        //this makes the stars glow
        SKAction* starExpand = [SKAction scaleBy:1.3 duration:1.0];
        SKAction* starShrink = [SKAction scaleBy:1/1.3 duration:1.0];
        NSMutableArray * starGlowActions = [[NSMutableArray alloc] init];
        [starGlowActions addObject:starExpand];
        [starGlowActions addObject:starShrink];
        self.starGlow = [SKAction sequence:starGlowActions];
        
        //index counter for the picture constellation arrays. Starts with 1, because the first element is a picture and the rest are stars
        self.bigStarCounter = 1;
        //whether all the stars in the constellation have been touched
        self.drawingComplete = false;
        //whether the user is tracing a blue constellation
        self.tracingBigPath = false;
        //whether the user is tracing lines between yellow stars (mutually exclusive)
        self.tracingSmallPath = false;
        [self addStars];
    }
    return self;
}

//this adds all of the yellow stars, populates the constelation arrays and puts the first star of one of the constellations on the screen.
-(void)addStars
{
    //these are the hard-coded coordinates for the yellow stars :|
    float xValues[10] = {0.15, 0.3, 0.3, 0.6, 0.55, 0.8, 0.85, 0.7, 0.4, 0.25};
    float yValues[10] = {0.4, 0.17, 0.55, 0.25, 0.5, 0.3, 0.6, 0.75, 0.8, 0.85};
    for (int i = 0; i < 10; i++)
    {
        SKSpriteNode *aStar = [SKSpriteNode spriteNodeWithImageNamed:@"star"];
        float xValue = xValues[i];
        float yValue = yValues[i];
        aStar.position = CGPointMake((xValue - 0.5)*self.sky.size.width, (yValue - 0.5)*self.sky.size.height);
        float sizeRandomizer = (25.0 + arc4random_uniform(40))/100.0;
        aStar.size = CGSizeMake(aStar.size.width*sizeRandomizer, aStar.size.height*sizeRandomizer);
        double alpha = 1 + arc4random_uniform(4);
        [self.sky addChild: aStar];
        //these to deferentiate between objects on screen that can be touched and their layer order
        aStar.zPosition = yellowStarDepth;
        aStar.name = smallStarCategoryName;
        SKAction * starRotate = [SKAction rotateByAngle:alpha duration:5.0];
//makes the star glow and rotate forever
        [aStar runAction:[SKAction repeatActionForever:self.starGlow]];
        [aStar runAction:[SKAction repeatActionForever: starRotate]];
    }
/****************************************************
 populating the constellation arrays!
 the first item in the array is the picture, the rest are stars */
//cat stars!
    float catValuesX[8] = {0.64, 0.55, 0.65, 0.68, 0.56, 0.47, 0.27, 0.25};
    float catValuesY[8] = {0.17, 0.51, 0.49, 0.91, 0.89, 0.81, 0.85, 0.44};
    self.catStars = [[NSMutableArray alloc]init];
    SKSpriteNode * catPicture = [SKSpriteNode spriteNodeWithImageNamed:@"starCat"];
    catPicture.alpha = 0;
    catPicture.size = self.sky.size;
    [self.catStars addObject:catPicture];
    for (int i = 0; i < 8; i++)
    {
        SKSpriteNode *aStar = [SKSpriteNode spriteNodeWithImageNamed:@"bigStar"];
        float xValue = catValuesX[i];
        float yValue = 1-catValuesY[i];
        aStar.position = CGPointMake((xValue - 0.5)*self.sky.size.width, (yValue - 0.5)*self.sky.size.height);
        [self.catStars addObject:aStar];
    }
//thomas stars!
    float thomasValuesX[7] = {0.35, 0.48, 0.65, 0.64, 0.59, 0.49, 0.35};
    float thomasValuesY[7] = {0.26, 0.09, 0.25, 0.59, 0.86, 0.88, 0.63};
    self.thomasStars = [[NSMutableArray alloc]init];
    SKSpriteNode * thomasPicture = [SKSpriteNode spriteNodeWithImageNamed:@"thomas"];
    thomasPicture.alpha = 0;
    thomasPicture.size = self.sky.size;
    [self.thomasStars addObject:thomasPicture];
    
    for (int i = 0; i < 7; i++)
    {
        SKSpriteNode *aStar = [SKSpriteNode spriteNodeWithImageNamed:@"bigStar"];
        float xValue = thomasValuesX[i];
        float yValue = 1-thomasValuesY[i];
        aStar.position = CGPointMake((xValue - 0.5)*self.sky.size.width, (yValue - 0.5)*self.sky.size.height);
        [self.thomasStars addObject:aStar];
    }
//house stars!
    float homeValuesX[7] = {0.22, 0.43, 0.7, 0.58, 0.59, 0.3, 0.31};
    float homeValuesY[7] = {0.43, 0.1, 0.41, 0.42, 0.71, 0.72, 0.45};
    self.homeStars = [[NSMutableArray alloc]init];
    SKSpriteNode * homePicture = [SKSpriteNode spriteNodeWithImageNamed:@"star_home"];
    homePicture.alpha = 0;
    homePicture.size = self.sky.size;
    [self.homeStars addObject:homePicture];
    for (int i = 0; i < 7; i++)
    {
        SKSpriteNode *aStar = [SKSpriteNode spriteNodeWithImageNamed:@"bigStar"];
        float xValue = homeValuesX[i];
        float yValue = 1-homeValuesY[i];
        aStar.position = CGPointMake((xValue - 0.5)*self.sky.size.width, (yValue - 0.5)*self.sky.size.height);
        [self.homeStars addObject:aStar];
    }
/*****************************************************************************
 To add another constellation, copy-paste one of the blocks above, replace star coordinates and variable names
 accordingly. Don't forget to create an NSMutableArray property for your constelation*/
    
    
//at random adding the first star of either Cat or Home or Thomas
    int constelation = arc4random() % 3;
    SKSpriteNode* aStar;
    switch (constelation) {
        case 0:
            self.currentConstelation = self.catStars;
            break;
        case 1:
            self.currentConstelation = self.homeStars;
            break;
        case 2:
            self.currentConstelation = self.thomasStars;
        default:
            self.currentConstelation = self.catStars;
            break;
    }
    
    aStar = [self.currentConstelation objectAtIndex:1];
    [self addBigStar];
    aStar.zPosition = firstStarDepth; //first star is special, because it stays if you break the line and don't finish the constellation. So it has its own depth.
};

-(void)addBigStar
{
    if(self.bigStarCounter < [self.currentConstelation count])
    {
        NSLog(@"add a big star");
        SKSpriteNode * aStar = [self.currentConstelation objectAtIndex:self.bigStarCounter];
        if([self.sky.children containsObject:aStar])
        { //this, in case the stars of an unfinished constellation are still fading when a person attempts constellation again
            [aStar removeFromParent];
        }
        UIImage * blueStar = [UIImage imageNamed:@"bigStar"];
        aStar.size = CGSizeMake(0,0);
        float sizeRandomizer = (50.0 + arc4random_uniform(40))/100.0;
        float width = blueStar.size.width*sizeRandomizer;
        [aStar removeAllActions];
        aStar.zPosition = blueStarDepth;
        aStar.name = bigStarCategoryName;
        double alpha = arc4random_uniform(5);
        //all of this makes the star fade into existance as it grows from 0 to it's randomized size
        //then it will rotate and glow forever
        SKAction * starRotate = [SKAction rotateByAngle:alpha duration:5.0];
        [aStar runAction:[SKAction repeatActionForever:self.starGlow]];
        [aStar runAction:[SKAction repeatActionForever: starRotate]];
        [aStar runAction:[SKAction resizeByWidth:width height:width duration:0.5]];
        aStar.alpha = 0;
        [aStar runAction:[SKAction fadeAlphaTo:1 duration:0.5]];
        [self.sky addChild:aStar];
        self.bigStarCounter += 1;
    }
    else
    {
        //once all the stars have been added
        self.drawingComplete = YES;
        SKSpriteNode * picture = [self.currentConstelation objectAtIndex:0];
        picture.alpha = 0;
        picture.size = self.sky.size;
        [self.sky addChild:picture];
        picture.userInteractionEnabled = NO;
        picture.zPosition = pictureDepth;
        //this causes the picture to fade in and fade out.
        [picture runAction:[SKAction fadeAlphaTo:1 duration:1] completion:^
        {
            [picture runAction:[SKAction fadeAlphaTo:0 duration:2] completion:^
            {
                [picture removeFromParent];
            }];
        }];
        [self.activePath removeFromParent];
    }
}

//no touches began function since a single touch can't draw a line.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location;
    SKNode* myNode;
    //_outOfBounds = NO;
    
    for (UITouch *touch in touches)
    {
        location = [touch locationInNode:self.sky];
        NSLog(@"%f", location.x);
        if(location.x < -415 || location.x > 415)
            break;
            //_outOfBounds = YES;
        //if there's a star under the touch, we capture it here
        myNode = [self.sky nodeAtPoint:location];
    
    //if(!_outOfBounds)
    //{
        //the following if/else block prevents the user from connecting yellow and blue stars
        if(self.tracingSmallPath) //means you're drawing lines between yellow stars
        {
            //if there's actually a node and the node is a yellow star
            if (myNode && [myNode.name isEqualToString: smallStarCategoryName])
            {
                //and it's not the same star we just touched
                if (myNode != self.activeStar)
                {
                    self.activeStar = myNode;
                    //this causes the active Path (the interstellar glowing line) to snap to the star we just touched
                    double dX = self.activePath.position.x - myNode.position.x;
                    double dY = self.activePath.position.y - myNode.position.y;
                    double length = sqrt(dX*dX + dY*dY);
                    self.activePath.size = CGSizeMake(3.0, length);
                    
                    double alpha = -atan(dX/dY);
                    if (self.activePath.position.y >= myNode.position.y)
                        alpha += 3.14;
                    self.activePath.zRotation = alpha;
                    
                    //creating a new starPath originated on the star
                    SKSpriteNode * starPath = [SKSpriteNode spriteNodeWithImageNamed:@"starLine"];
                    starPath.position = self.activeStar.position;
                    //this anchor point is relative to the path's local system and places it in the bottom-middle position
                    starPath.anchorPoint = CGPointMake(0.5, 0.0);
                    starPath.zPosition = yellowLineDepth;
                    self.activePath = starPath;
                    self.activePath.size = CGSizeMake(self.lineThinWidth, 0);
                    [self.sky addChild: starPath];
                    [starPath runAction:[SKAction repeatActionForever:self.lineGlow]];
                }
                else
                    //this prevents a stubby line from poking out of the star.
                    self.activePath.size = CGSizeMake(self.lineThinWidth, 0);
            }
            else //if we're not touching another yellow star
            {    //simply adjust the active star path to stretch from the last star touched to the current finger position
                double dX = self.activePath.position.x - location.x;
                double dY = self.activePath.position.y - location.y;
                double length = sqrt(dX*dX + dY*dY);
                double alpha = -atan(dX/dY);
                if (self.activePath.position.y >= location.y)
                    alpha += 3.14;
                self.activePath.zRotation = alpha;
                self.activePath.size = CGSizeMake(self.lineThinWidth, length);
            }
        }
        else if (self.tracingBigPath) //if we're following a constellation
        {
            //if we're touching a star that belongs to a constellation
            if (myNode && [myNode.name isEqualToString: bigStarCategoryName])
            {
                self.activeStar = myNode;
                //we temporarily rename the star, so the user can't touch it twice, thus preventing him from adding unnecessary lines to the constellation
                myNode.name = @"nothing";
                //this makes the current star path snap to the star we're touching
                double dX = self.activePath.position.x - myNode.position.x;
                double dY = self.activePath.position.y - myNode.position.y;
                double length = sqrt(dX*dX + dY*dY);
                self.activePath.size = CGSizeMake(3.0, length);
                
                double alpha = -atan(dX/dY);
                if (self.activePath.position.y >= myNode.position.y)
                    alpha += 3.14;
                self.activePath.zRotation = alpha;
                //creating a new path originated at the star we just touched
                SKSpriteNode * starPath = [SKSpriteNode spriteNodeWithImageNamed:@"blueStarLine"];
                starPath.zPosition = blueLineDepth;
                starPath.position = self.activeStar.position;
                //this anchor point is relative to the path's local system and places it in the bottom-middle position
                starPath.anchorPoint = CGPointMake(0.5, 0.0);
                self.activePath = starPath;
                self.activePath.size = CGSizeMake(self.lineThinWidth, 0);
                [self.sky addChild: starPath];
                [starPath runAction:[SKAction repeatActionForever:self.lineGlow]];
                [self addBigStar]; //calling for a next star in the constellation to appear
            }
            else
            {   //if we're not touching a star, simply adjust the star path to stretch between the last star visited and the current finger position
                double dX = self.activePath.position.x - location.x;
                double dY = self.activePath.position.y - location.y;
                double length = sqrt(dX*dX + dY*dY);
                double alpha = -atan(dX/dY);
                if (self.activePath.position.y >= location.y)
                    alpha += 3.14;
                self.activePath.zRotation = alpha;
                self.activePath.size = CGSizeMake(self.lineThinWidth, length);
            }
        }
        else  //if we haven't touched any stars yet
        {
            if (myNode && [myNode.name isEqualToString: smallStarCategoryName])
            {
                self.tracingSmallPath = YES;
                self.activeStar = myNode;
                SKSpriteNode * starPath = [SKSpriteNode spriteNodeWithImageNamed:@"starLine"];
                starPath.zPosition = yellowLineDepth;
                starPath.position = self.activeStar.position;
                //this anchor point is relative to the path's local system and places it in the bottom-middle position
                starPath.anchorPoint = CGPointMake(0.5, 0.0);
                self.activePath = starPath;
                [starPath runAction:[SKAction repeatActionForever:self.lineGlow]];
                self.activePath.size = CGSizeMake(self.lineThinWidth, 0);
                [self.sky addChild: starPath];
            }
            else if (myNode && [myNode.name isEqualToString: bigStarCategoryName])
            {
                self.tracingBigPath = YES;
                self.activeStar = myNode;
                SKSpriteNode * starPath = [SKSpriteNode spriteNodeWithImageNamed:@"blueStarLine"];
                starPath.zPosition = blueLineDepth;
                starPath.position = self.activeStar.position;
                //this anchor point is relative to the path's local system and places it in the bottom-middle position
                starPath.anchorPoint = CGPointMake(0.5, 0.0);
                self.activePath = starPath;
                [starPath runAction:[SKAction repeatActionForever:self.lineGlow]];
                self.activePath.size = CGSizeMake(self.lineThinWidth, 0);
                //renaming the star to prevent the user from returning to it later and ruining the constellation design
                self.activeStar.name = @"nothing";
                [self.sky addChild: starPath];
                [self addBigStar];
            }
        }
    }
    //}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //if(!_outOfBounds)
    //{
        [self.activePath removeFromParent];
       if(!self.drawingComplete)
        {
            if(self.tracingBigPath)
            {
                //we prevent the very first star in the constellation from disappearing while everything else resets
                SKSpriteNode * aStar = [self.currentConstelation objectAtIndex:1];
                aStar.name = bigStarCategoryName;
                aStar.zPosition = firstStarDepth;
            }
        }
        else
        {
            SKSpriteNode * aStar = [self.currentConstelation objectAtIndex:1];
            //this will make the first star disappear along with all the others++
            aStar.zPosition = blueStarDepth;
            //this switches the constellation to the next one
            if(self.currentConstelation == self.catStars)
                self.currentConstelation = self.homeStars;
            else if(self.currentConstelation == self.homeStars)
            {
                self.currentConstelation = self.thomasStars;
            }
            else
            {
                self.currentConstelation = self.catStars;
                [SoundManager playSoundFromFile:@"remember" withExt:@"wav" atVolume: 0.5];
            }
            //we wait for 3 seconds allowing the picture to appear and fade before adding the first star of the next constellation
            [self runAction:[SKAction waitForDuration:3] completion:^
            {
                self.bigStarCounter = 1;
                SKSpriteNode * newStar = [self.currentConstelation objectAtIndex:1];
                [self addBigStar];
                newStar.zPosition = firstStarDepth;
            }];
            self.drawingComplete = false;
        }
        self.bigStarCounter = 2;
        [self removeLines];
        [self removeBigStars];
        self.tracingSmallPath = NO;
        self.tracingBigPath = NO;
    //}
    //_outOfBounds = NO;
}

-(void)removeLines
{
    for(SKNode * aChild in self.sky.children)
    {
        if ((aChild.zPosition == yellowLineDepth) || (aChild.zPosition == blueLineDepth))
        {
            //this causes the lines to simultaneously shrink in width and fade
            [aChild runAction:[SKAction fadeAlphaTo:0 duration:2.5] completion:^{[aChild removeFromParent];}];
            [aChild runAction:[SKAction resizeToWidth:0.1 duration:2.5]];
        }
    }
}

-(void)removeBigStars
{
    for(SKSpriteNode * aChild in self.sky.children)
    {
        
        if (aChild.zPosition == blueStarDepth)
        {
            aChild.name = @"nothing";
            [aChild runAction:[SKAction fadeAlphaTo:0 duration:2.5] completion:^{[aChild removeFromParent];}];
            [aChild runAction:[SKAction resizeByWidth:0.1 height:0.1 duration:2.5]];
        }
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
