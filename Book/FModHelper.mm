//
//  FMod.m
//  FMOD_TEST
//
//  Created by Alec Tyre on 7/10/14.
//  Copyright (c) 2014 GetItDoneDotCom. All rights reserved.
//

#import "FModHelper.h"
#include "fmod_studio.hpp"
#include "fmod.hpp"
//#include "Fmod_errors.h"


/// Utility method to find FMod friendly path names
const char *GetMediaPath(const char *fileName)
{
    return [[NSString stringWithFormat:@"%@/%s", [[NSBundle mainBundle] resourcePath], fileName] UTF8String];
}



/////////////////////////////////////////////////////////////
///
/// Interfaces for FModHelper, FModBank, and FModEvent
//
/////////////////////////////////////////////////////////////

/// FMod bank wrapper class INTERFACE
/// Private utility class, used by FModHelper to track banks
/// Fun fac: may be entirely unnecessary
@interface FModBank : NSObject

@property (nonatomic, readwrite, assign) FMOD::Studio::Bank* bankPointer;

@end

/// FMod event wrapper class INTERFACE
/// Private utility class, used by FModHelper to track events
@interface FModEvent ()

@property (nonatomic, readwrite, assign) FMOD::Studio::EventDescription* eventDescriptionPointer;
@property (nonatomic, readwrite, assign) FMOD::Studio::EventInstance* eventInstancePointer;

@end

/// FModHelper class INTERFACE
/// Externally visible, has static functions for using FMod
@interface FModHelper ()

+(FModHelper *)sharedSingleton;
@property (nonatomic, readwrite, assign) FMOD::Studio::System* fmodsystem;
@property NSMutableArray* loadedBanks;
@property NSMutableArray* loadedEvents;

@end




/////////////////////////////////////////////////////////////
///
/// Implementation for FModHelper, FModBank, and FModEvent
//
/////////////////////////////////////////////////////////////

/// FMod bank wrapper class IMPLEMENTATION
/// Private utility class
@implementation FModBank
@synthesize bankPointer = _bankPointer;

+(id)bankWithPath:(NSString*)bankPath {
    
    FModBank* newBank = [[FModBank alloc] init];
    
    if (newBank) {
        FMOD::Studio::Bank* newBankPointer = NULL;
        
        [FModHelper sharedSingleton].fmodsystem->loadBankFile(GetMediaPath([bankPath UTF8String]), FMOD_STUDIO_LOAD_BANK_NORMAL, &newBankPointer);
        
        newBank.bankPointer = newBankPointer;
    }
    
    return newBank;
}


@end

/// FMod event wrapper class IMPLEMENTATION
/// Externally visible, FModEvent represents a sound or something
@implementation FModEvent
@synthesize eventDescriptionPointer = _eventDescriptionPointer;
@synthesize eventInstancePointer = _eventInstancePointer;

+(id)eventWithPath:(NSString*)eventPath {
    
    FModEvent* newEvent = [[FModEvent alloc] init];
    
    if (newEvent) {
        FMOD::Studio::ID eventID = {0};
        [FModHelper sharedSingleton].fmodsystem->lookupID([eventPath UTF8String], &eventID);
        
        FMOD::Studio::EventDescription* newEventPointer = NULL;
                [FModHelper sharedSingleton].fmodsystem->getEvent(&eventID, FMOD_STUDIO_LOAD_BEGIN_NOW, &newEventPointer);
        
        newEventPointer->loadSampleData();
        
        newEvent.eventDescriptionPointer = newEventPointer;
    }
    
    return newEvent;
}

-(void)play {
    if (_eventInstancePointer == NULL && _eventDescriptionPointer != NULL) {
        
        FMOD::Studio::EventInstance* newEventInstance = NULL;
        _eventDescriptionPointer->createInstance(&newEventInstance);
    
        _eventInstancePointer = newEventInstance;
    }
    
    if(_eventInstancePointer != NULL) {
        _eventInstancePointer->start();
    }
}

-(void)stop {
    _eventInstancePointer->stop(FMOD_STUDIO_STOP_ALLOWFADEOUT);
}



@end

/// FModHelper class IMPLEMENTATION
/// Externally visible, has static functions for using FMod
@implementation FModHelper
@synthesize fmodsystem = _fmodsystem;

//Static singleton access
+(FModHelper *)sharedSingleton
{
    static FModHelper *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton) {
            sharedSingleton = [[FModHelper alloc] init];
            sharedSingleton.loadedBanks = [NSMutableArray array];
            sharedSingleton.loadedEvents = [NSMutableArray array];
        }
        
        return sharedSingleton;
    }
}

/// Creates CADisplay link that runs FModHelper's update function
+(CADisplayLink *)displayLink
{
    static CADisplayLink* displayLink = nil;
    
    if (displayLink == nil)
    {
        displayLink = [CADisplayLink displayLinkWithTarget:[FModHelper sharedSingleton] selector:@selector(update)];
    }
    
    return displayLink;
}

/// Update loop, which just runs the fmodsystem update function
-(void)update
{
    [FModHelper sharedSingleton].fmodsystem->update();
}

/// Initialized FMod system and adds our update function to the run loop
+(void)initializeFModSystem
{
    FMOD::Studio::System* newSystem;
    
    FMOD::Studio::System::create(&newSystem);
    newSystem->initialize(32, FMOD_STUDIO_INIT_NORMAL, FMOD_INIT_NORMAL, NULL);
    
    [[FModHelper displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [FModHelper sharedSingleton].fmodsystem = newSystem;
}

+(void)loadBankWithPath:(NSString*)bankPath
{
    FModBank* newBank = [FModBank bankWithPath:bankPath];
    
    [[FModHelper sharedSingleton].loadedBanks addObject:newBank];
}



@end
