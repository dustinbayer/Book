//
//  FMod.h
//  FMOD_TEST
//
//  Created by Alec Tyre on 7/10/14.
//  Copyright (c) 2014 GetItDoneDotCom. All rights reserved.
//

#import <Foundation/Foundation.h>

/* No need to be externally visible?
@interface FModBank : NSObject

@end
*/

@interface FModEvent : NSObject

+(id)eventWithPath:(NSString*)eventName;
-(void)play;
-(void)stop;

@end

@interface FModHelper : NSObject

+(void)initializeFModSystem;
+(void)loadBankWithPath:(NSString*)bankPath;

@end






