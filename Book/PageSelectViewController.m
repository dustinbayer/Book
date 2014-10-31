//
//  PageSelectViewController.m
//  Book
//
//  Created by Dustin Bayer on 2/21/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "PageSelectViewController.h"

@interface PageSelectViewController ()

@end

@implementation PageSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(800.0, 800.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageSelectMenu.png"]];
    //self.view.backgroundColor = [UIColor blackColor];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageSelectMenu.png"]];
    
    
    _pageList = [@[@"Page1.png",
                   @"Page2.png",
                   @"Page3.png",
                   @"Page4.png",
                   @"Page5.png",
                   @"Page6.png",
                   @"Page7.png",
                   @"Page8.png",
                   @"Page9.png"] mutableCopy];
    
    _buttonList = [@[_page1, _page2, _page3,_page4,_page5,_page6,_page7,_page8,_page9] mutableCopy];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
  
#pragma mark UICollectionViewDataSource

/*-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return _pageList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    image = [UIImage imageNamed:_pageList[row]];
    
    
    myCell.pageSelectView.image = image;
    [_buttonList addObject: (id)myCell.pageButton];
    
    return myCell;
}*/

- (IBAction)pageClicked:(id)sender {
    
    
    for (int i = 0; i < _buttonList.count; i++)
    {
        id button = _buttonList[i];
        if(button == sender)
        {
            [self.delegate gotoPage:i];
            break;
        }
    }
    [self.delegate pageSelectViewControllerDidFinish:self];
}


-(void) setTheDelegate:(id<PageSelectViewControllerDelegate>)delegate
{
    _delegate = delegate;
    NSLog(@"%@", _delegate);
}



@end
