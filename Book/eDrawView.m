//
//  eDrawView.m
//  eDraw
//
//  Created by Oleksandra Keehl on 3/10/14.
//  Copyright (c) 2014 Oleksandra Keehl. All rights reserved.
//

#import "eDrawView.h"

@implementation eDrawView

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
    
}

- (void)reset
{
    incrementalImage = nil;
    done = NO;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame colors:(UIImage *) colorDrawing tones:(UIImage *) toneDrawing
{
    runLoop = [NSRunLoop currentRunLoop];
    done = NO;
    
 
   
    
    
    //NSLog(@"woah");
    self = [super initWithFrame:frame];
    if (self)
    {
        self.strokeColor = [UIColor colorWithRed:207/255.0 green:31/255.0 blue:52/255.0 alpha:255];
        myFlatColors = colorDrawing;
        myShading = toneDrawing;
        [self setMultipleTouchEnabled:NO];
        path = [UIBezierPath bezierPath];
        STROKEWIDTH = 5.0;
        [path setLineWidth: STROKEWIDTH];
        path.lineCapStyle = kCGLineCapRound;
        self.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        hasMoved = NO;
        self.opaque = NO;
        // Initialization code
    }
   
    return self;
}

//########### do I need this? #############
-(void) drawRect:(CGRect)rect
{
    [incrementalImage drawInRect:rect];
    [self.strokeColor setStroke];
    [path stroke];
}//########################################

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touched");
    if(myTimer)
    {
        //NSLog(@"the timer was on");
        [myTimer invalidate];
        myTimer = nil;
    
    }

    UITouch *touch = [touches anyObject];
    points[0] = [touch locationInView:self];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
    if(!done)
    {
        hasMoved = YES;
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self];
        counter++;
        points[counter] = p;
        if (counter == 4)
        {
            points[3] = CGPointMake((points[2].x + points[4].x)/2.0 , (points[2].y + points[4].y)/2.0);
            [path moveToPoint:points[0]];
            [path addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
            [self setNeedsDisplay];
            points[0] = points[3];
            points[1] = points[4];
            counter = 1;
        }
    }
}

-(void)timerFireMethod:(NSTimer *)timer
{

}


-(void)graphicUpdate:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(!done)
    {
        while (counter != 1)
        {
            [self touchesMoved:touches withEvent:event];
        }

        [self setNeedsDisplay];
        [path removeAllPoints];
        counter = 0;
        hasMoved = NO;
    }
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(!done)
    {
        if(!myTimer)
        {
            myTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
            [runLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
            //NSLog(@"added a timer");
        }
        if (!hasMoved)
        {
            UITouch *touch = [touches anyObject];
            CGPoint p = [touch locationInView:self];
            path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(p.x - STROKEWIDTH/2, p.y - STROKEWIDTH/2, STROKEWIDTH, STROKEWIDTH)];
        }
        else
        {
            while (counter != 1)
            {
                [self touchesMoved:touches withEvent:event];
            }
        }
        [self drawBitmap];
        [self setNeedsDisplay];
        [path removeAllPoints];
        counter = 0;
        hasMoved = NO;
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(void)drawBitmap
{
   
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (!incrementalImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:0.0f] setFill];
        [rectpath fill];
    }
    
    [incrementalImage drawAtPoint:CGPointZero];
    
    if(!hasMoved)
    {
        [self.strokeColor setFill];
        [path fill];
        [self.strokeColor setStroke];
        [path setLineWidth:STROKEWIDTH];
        [path setLineCapStyle:kCGLineCapRound];
    }
    else
    {
        [self.strokeColor setStroke];
        [path setLineWidth:STROKEWIDTH];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    }
   // [myLineart drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
}

-(void)finalDrawing
{
    if(!done)
    {
    done = YES;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (!incrementalImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f] setFill];
        [rectpath fill];
    }
    [myFlatColors drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];
    [incrementalImage drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:0.4];
    if(!hasMoved)
    {
        [self.strokeColor setFill];
        [path fill];
        [self.strokeColor setStroke];
        [path setLineWidth:STROKEWIDTH];
        [path setLineCapStyle:kCGLineCapRound];
    }
    else
    {
        [self.strokeColor setStroke];
        [path setLineWidth:STROKEWIDTH];
        [path setLineCapStyle:kCGLineCapRound];
        [path stroke];
    }
    

    [myShading drawAtPoint:CGPointZero blendMode:kCGBlendModeLuminosity alpha:1.0];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
    }

}

- (UIImage *)getImage
{
    return incrementalImage;
}



@end
