//
//  EndScene.m
//  Book
//
//  Created by Dustin Bayer on 4/12/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "EndScene.h"
#import "ToychestScene.h"

@interface EndScene ()
@property BOOL contentCreated;

@end

@implementation EndScene

-(id)initWithSize:(CGSize)size
{
    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor whiteColor];
        _contentCreated = NO;
        SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"placeholder-touse.png"];
        background.position = CGPointMake(512, 300);
        [self addChild:background];
        
        SKSpriteNode *nodeSeb = [[SKSpriteNode alloc] initWithImageNamed:@"sebImage.png"];
        nodeSeb.position = CGPointMake(512+10, 576/2 + 150);
        [self addChild:nodeSeb];
        
        _chestNode = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(120, 130)];
        _chestNode.position = CGPointMake(850, 400);
        //_node.zRotation = M_PI/-7;
        _chestNode.name = @"chest";
        [self addChild:_chestNode];
        self.touchEnabled = true;
        //[self didMoveToView:self.view];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    
    if(!self.contentCreated)
    {
        NSLog(@"CALLED++++++");
        self.contentCreated = YES;
        int yPlacement = 200;
        int yPlacement2 = 200;
        int xPlacement = 430;
        int j = [self.drawings count] -4;
        if(j< 0)
        {
            j = 0;
        }
        for (int i = j; i < [self.drawings count]; i++)
        {
            
            UIImage *tempImage = [self.drawings objectAtIndex:i];
            SKSpriteNode *nodeTemp = [[SKSpriteNode alloc] initWithImageNamed:@"tornPage.png"];
            nodeTemp.position = CGPointMake(xPlacement +40, yPlacement2 +95 );
            [self addChild:nodeTemp];
             CGRect frame = CGRectMake(xPlacement, yPlacement + 55, 80, 50);
             yPlacement += tempImage.size.height/6 +50;
             yPlacement2 -= tempImage.size.height/6 +50;
             if(yPlacement > 576 - tempImage.size.height/2)
             {
                 yPlacement = 200;
                 yPlacement2 = 200;
                 xPlacement += 100;
             }
            
             UIImageView* temp = [[UIImageView alloc]initWithFrame:frame];
             temp.image = tempImage;
            
            
             temp.transform = CGAffineTransformMakeRotation(M_PI/-2);
             [self.view addSubview:temp];
    
        }
        
        
        _node = [[SKSpriteNode alloc] initWithImageNamed:@"Home"];
        _node.position = CGPointMake(900, 124);
        _node.name = @"homeButton";
        [self addChild:_node];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node2 = [self nodeAtPoint:location];
    //NSLog(@"%@", _drawings);
    //if fire button touched, bring the rain
    if ([node2.name isEqualToString:@"homeButton"]) {
        [self.delegate returnHome];
    }
    else if ([node2.name isEqualToString:@"chest"] && self.touchEnabled) {
        
        [self.delegate addSubsceen:[[ToychestScene alloc] initWithSize:CGSizeMake(1024, 576)] moveX:-900 moveY:-200 scale:2 fadeDelay:NO duration:2];
    }

}



@end
