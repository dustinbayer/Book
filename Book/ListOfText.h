//
//  ListOfText.h
//  Book
//
//  Created by Dustin Bayer on 2/26/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListOfText : NSObject

-(NSString *) getText:(NSUInteger) page getPart:(NSUInteger) part;

-(int) getnumParts:(NSUInteger) page;

@end
