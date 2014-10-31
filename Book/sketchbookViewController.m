//
//  sketchbookViewController.m
//  drawingTest
//
//  Created by Dustin Bayer on 10/3/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "sketchbookViewController.h"

@interface sketchbookViewController ()
@end

@implementation sketchbookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view setMultipleTouchEnabled:NO];
    // Configure the view.
    //SKView * skView = (SKView *)self.view;
    _spriteView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, 1024-400, 768)];
    _spriteView.showsFPS = YES;
    _spriteView.showsNodeCount = YES;
    [self.view addSubview:_spriteView];
    
    // Create and configure the scene.
   // _scene = [SketchbookScene sceneWithSize:CGSizeMake(1024-400, 768)];
    /*SKSpriteNode *picture;
    switch (_pageNumber) {
        case 0:
            picture = [[SKSpriteNode alloc] initWithImageNamed:@"dadDrawing.png"];
            //_scene.drawing = [UIImage imageNamed:@"dadDrawing.png"];
            break;
        case 1:
            picture = [[SKSpriteNode alloc] initWithImageNamed:@"landscapeDrawing.png"];
            //_scene.drawing = [UIImage imageNamed:@"landscapeDrawing.png"];
            break;
        case 2:
            picture = [[SKSpriteNode alloc] initWithImageNamed:@"momDrawing.png"];
            //_scene.drawing = [UIImage imageNamed:@"momDrawing.png"];
            break;
            
        default:
            picture = nil;
            break;
    }
    if(picture)
    {
        picture.position = CGPointMake(0, 0);
        [_scene.drawingBackground addChild:picture];
        
    }

     _scene.delegate = self;
    // Present the scene.
    [_spriteView presentScene:_scene];*/
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
     _scene = [SketchbookScene sceneWithSize:CGSizeMake(1024-400, 768)];
    SKSpriteNode *picture;
    
    picture = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:_drawing]];
    if(picture)
    {
        picture.position = CGPointMake(0, 0);
        picture.size = CGSizeMake(1024-400, 768);
        [_scene.drawingBackground addChild:picture];
        _scene.drawing = _drawing;
        
        
    }
    NSLog(@"Page number %lu", (unsigned long)_pageNumber);
    _scene.delegate = self;
    // Present the scene.
    [_spriteView presentScene:_scene];
}

-(void)viewDidAppear:(BOOL)animated
{
   /* SKSpriteNode *picture;
    
    picture = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:_drawing]];
    if(picture)
    {
        picture.position = CGPointMake(0, 0);
        [_scene.drawingBackground addChild:picture];
        
    }
    
    _scene.delegate = self;
    // Present the scene.
    [_spriteView presentScene:_scene];*/
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self.delegate doneDrawing:_scene.drawing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)snapshot:(UIView *)view
{
    //NSLog(@"called");
    UIGraphicsBeginImageContextWithOptions(_spriteView.bounds.size, YES, 0);
    [_spriteView drawViewHierarchyInRect:_spriteView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _scene.drawing = image;
    _drawing = image;
    return image;
}

@end
