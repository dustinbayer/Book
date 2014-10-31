//
//  MyScene.m
//  drawingTest
//
//  Created by Dustin Bayer on 9/22/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "SketchbookScene.h"

@interface SketchbookScene ()



@property CGSize viewSize;
@property CGSize drawViewSize;
@property int count;
@property int sizeCount;

@property NSMutableArray *linePoints;
@property SKSpriteNode *picture;


@end


@implementation SketchbookScene
{
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint points[5];
    uint counter;
    BOOL hasMoved;
    CGFloat STROKEWIDTH;
    
    NSTimer* myTimer;
    BOOL done;
    NSRunLoop * runLoop;
    UIImage * myFlatColors;
    UIImage * myShading;
    
    CGPoint lenPoints[10];
    
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        //runLoop = [NSRunLoop currentRunLoop];
        done = NO;
        //path = [UIBezierPath bezierPath];
        //_drawingName = [[NSString alloc] init];
        //hasMoved = NO;
        _linePoints = [[NSMutableArray alloc] init];
        counter = 0;
        _color = 0;
        _viewSize = size;
        _drawViewSize = CGSizeMake(size.width-200, size.height);
        _count = 0;
        _sizeCount = 0;
        _drawingBackground = [[SKSpriteNode alloc] initWithColor:[UIColor whiteColor] size:_viewSize];
        _drawingBackground.position = CGPointMake(_viewSize.width/2, _viewSize.height/2);
        _drawingBackground.size = _viewSize;
        self.backgroundColor = [UIColor whiteColor];
        
        _drawingNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:_drawViewSize];
        _drawingNode.position = CGPointMake(_viewSize.width/2-100, _viewSize.height/2);
        _drawingNode.size = _drawViewSize;
        [self addChild:_drawingBackground];
        [self addChild:_drawingNode];
        
        
        
        
        
        
        
     
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /*if(myTimer)
    {
        [myTimer invalidate];
        myTimer = nil;
        
    }*/
    UITouch *touch = [touches anyObject];
   
    
    //UITouch *touch = [touches anyObject];
    //points[0] = [touch locationInNode:self];
    CGPoint p = [touch locationInNode:self];
    [_linePoints addObject:[NSValue valueWithCGPoint:p]];
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   /*// if(!done)
    //{
        //hasMoved = YES;
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInNode:self];
        points[counter] = p;
        //NSLog(@"(%f, %f)", points[counter].x, points[counter].y);
        counter++;
        
        if (counter == 5)
        {
           // done = YES;
            //points[3] = CGPointMake((points[2].x + points[4].x)/2.0 , (points[2].y + points[4].y)/2.0);
            //[path moveToPoint:points[0]];
            //[path addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
            //ADD IMAGES
            //points[0] = points[3];
            //points[1] = points[4];
            [self doMath];
            
            counter = 2;
        }
        
   // }*/
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInNode:self];
    [_linePoints addObject:[NSValue valueWithCGPoint:p]];
    /*counter++;
    points[counter] = p;
    if (counter == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0 , (points[2].y + points[4].y)/2.0);
        //[path moveToPoint:points[0]];
        //[path addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        //[self setNeedsDisplay];
        [self doMath];
        //points[0] = points[3];
        //points[1] = points[4];
        //counter = 1;
    }*/
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    /*if(!done)
    {
        if(!myTimer)
        {
            myTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
            [runLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
            
        }
        if (!hasMoved)
        {
            UITouch *touch = [touches anyObject];
            CGPoint p = [touch locationInNode:self];
            path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(p.x - STROKEWIDTH/2, p.y - STROKEWIDTH/2, STROKEWIDTH, STROKEWIDTH)];
        }
        else
        {
            while (counter != 1)
            {
                [self touchesMoved:touches withEvent:event];
            }
        }
        //ADD IMAGES
        [path removeAllPoints];
        counter = 0;
        hasMoved = NO;
    }*/
    counter = 0;
    _sizeCount = 0;
    
    [_linePoints removeAllObjects];
    
    [self rasterize];
    
    /*if(_color < 5)
    {
        _color++;
    }
    else
    {
        _color = 1;
    }*/
     
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


-(void)update:(NSTimeInterval)currentTime
{
    //_count++;
    if(_count == 100)
    {
        _count = 0;
        [self rasterize];

    }
    
    if(_linePoints.count > 3)
    {
        [self doMath];
    }
}

-(void)doMath
{
    float t;
    CGPoint p;
    CGPoint q;
    float disTotal = 0;
    float numOfSegments = 0;
    CGPoint p1 = [_linePoints[0] CGPointValue];
    CGPoint p2 = [_linePoints[1] CGPointValue];
    CGPoint p3 = [_linePoints[2] CGPointValue];
    
    
    for(int i = 0; i < 10; i++)
    {
        t = i/10.0;
        p.x = (1 - t) * (1 - t) * p1.x + 2 * (1 - t) * t * p2.x + t * t * p3.x;
        p.y = (1 - t) * (1 - t) * p1.y + 2 * (1 - t) * t * p2.y + t * t * p3.y;
        lenPoints[i] = p;
       // NSLog(@"t:%f\npoint0:(%f, %f)\npoint1:(%f, %f)\npoint2:(%f, %f)\np.x:(%f, %f)", t,
              //points[0].x, points[0].y,
             // points[1].x, points[1].y,
             // points[2].x, points[2].y,
             // p.x, p.y);
    }
    for(int i = 0; i < 9; i++)
    {
        p = lenPoints[i];
        q = lenPoints[i+1];
        
        float dx = q.x-p.x;
        float dy = q.y - p.y;
        
        disTotal += sqrtf(dx*dx + dy*dy);
        //NSLog(@"%f, %f", p.x,q.x);
    }
    
    numOfSegments = disTotal/2;
    
    
   //if (numOfSegments > 3)
    //{
        for(int i = 0; i < numOfSegments; i ++)
        {
            t = i/numOfSegments;
            p.x = (1 - t) * (1 - t) * p1.x + 2 * (1 - t) * t * p2.x + t * t * p3.x;
            p.y = (1 - t) * (1 - t) * p1.y + 2 * (1 - t) * t * p2.y + t * t * p3.y;
            [self addImageAtX:p.x Y:p.y];
        }
        //done = NO;
   /* }
    else
    {
        for(int i = 0; i < 3; i ++)
        {
            [self addImageAtX:points[i].x Y:points[i].y];
        }
        done = NO;
    }*/
    /*points[0] = points[3];
    points[1] = points[4];
    counter = 1;*/
    [_linePoints removeObjectAtIndex:1];
    [_linePoints removeObjectAtIndex:0];
    //[_linePoints removeObjectAtIndex:2];
    
    
   /* SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    sprite.position = CGPointMake(p1.x - _viewSize.width/2, p1.y - _viewSize.height/2);
    [_drawingNode addChild:sprite];
    SKSpriteNode *sprite2 = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(10, 10)];
    sprite2.position = CGPointMake(p2.x - _viewSize.width/2, p2.y - _viewSize.height/2);
    [_drawingNode addChild:sprite2];
    SKSpriteNode *sprite3 = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)];
    sprite3.position = CGPointMake(p3.x - _viewSize.width/2, p3.y - _viewSize.height/2);
    [_drawingNode addChild:sprite3];
    
    NSLog(@"\npoint0:(%f, %f)\npoint1:(%f, %f)\npoint2:(%f, %f)",
          p1.x, p1.y,
           p2.x, p2.y,
           p3.x, p3.y);*/
    
   
}

-(void)addImageAtX:(float)x Y:(float)y
{
     //UIImage *image = [UIImage imageNamed:@"brush"];
     //SKTexture *brush = [SKTexture textureWithImage:image];
     //SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithTexture:brush color:[UIColor redColor] size:CGSizeMake(25, 25)];
    SKSpriteNode *sprite;
    switch (_color) {
        case 0:
            sprite = [[SKSpriteNode alloc] initWithImageNamed:@"Black"];
            break;
        case 1:
            sprite = [[SKSpriteNode alloc] initWithImageNamed:@"Red"];
            break;
        case 2:
            sprite = [[SKSpriteNode alloc] initWithImageNamed:@"Green"];
            break;
        case 3:
            sprite = [[SKSpriteNode alloc] initWithImageNamed:@"Blue"];
            break;
        case 4:
            sprite = [[SKSpriteNode alloc] initWithImageNamed:@"Yellow"];
            break;
            
        default:
            break;
    }
    
     sprite.position = CGPointMake(x - _viewSize.width/2+100, y - _viewSize.height/2);
     //sprite.colorBlendFactor = 1.0;
     //sprite.color = [UIColor redColor];
    /*if(_sizeCount < 24)
    {
        sprite.size = CGSizeMake(_sizeCount/3 +2, _sizeCount/3);
        _sizeCount++;
    }
    else
    {*/
        sprite.size = CGSizeMake(10, 8);
    //}
     
     [_drawingNode addChild:sprite];

}

-(void)rasterize
{
    _drawing = [self.delegate snapshot:self.view];
    SKTexture *texture = [SKTexture textureWithImage:_drawing];
    
    [_drawingNode removeFromParent];
    _drawingNode = nil;
    
    _drawingNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:_drawViewSize];
    _drawingNode.position = CGPointMake(_viewSize.width/2-100, _viewSize.height/2);
    _drawingNode.size = _drawViewSize;
    
    [_drawingBackground removeFromParent];
    _drawingBackground = nil;
    _drawingBackground = [[SKSpriteNode alloc] initWithTexture:texture];
    _drawingBackground.position = CGPointMake(_viewSize.width/2, _viewSize.height/2);
    _drawingBackground.size = _viewSize;
    [self addChild:_drawingBackground];
    [self addChild:_drawingNode];
    
    
    //_drawingBackground.texture = texture;
}

- (void)reset
{
    //incrementalImage = nil;
    done = NO;
    //[self setNeedsDisplay];
}
-(void)timerFireMethod:(NSTimer *)timer
{
    
}

/*-(void)graphicUpdate:(NSSet *)touches withEvent:(UIEvent *)event
 {
 
 if(!done)
 {
 while (counter != 1)
 {
 [self touchesMoved:touches withEvent:event];
 }
 
 //[self setNeedsDisplay];
 [path removeAllPoints];
 counter = 0;
 hasMoved = NO;
 }
 }*/

@end
