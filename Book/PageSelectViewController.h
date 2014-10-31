//
//  PageSelectViewController.h
//  Book
//
//  Created by Dustin Bayer on 2/21/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionViewCell.h"

@class PageSelectViewController;

@protocol PageSelectViewControllerDelegate
- (void)pageSelectViewControllerDidFinish:(PageSelectViewController *)controller;
-(void)gotoPage:(int) pageNum;
@end


@interface PageSelectViewController : UIViewController /*<UICollectionViewDataSource, UICollectionViewDelegate>*/

@property (strong, nonatomic) NSMutableArray *pageList;
@property (strong, nonatomic) NSMutableArray *buttonList;

@property (weak, nonatomic) id <PageSelectViewControllerDelegate> delegate;

-(void) setTheDelegate:(id<PageSelectViewControllerDelegate>)delegate;
@property (weak, nonatomic) IBOutlet UIButton *page1;
@property (weak, nonatomic) IBOutlet UIButton *page2;
@property (weak, nonatomic) IBOutlet UIButton *page3;
@property (weak, nonatomic) IBOutlet UIButton *page4;
@property (weak, nonatomic) IBOutlet UIButton *page5;
@property (weak, nonatomic) IBOutlet UIButton *page6;
@property (weak, nonatomic) IBOutlet UIButton *page7;
@property (weak, nonatomic) IBOutlet UIButton *page8;
@property (weak, nonatomic) IBOutlet UIButton *page9;


@end
