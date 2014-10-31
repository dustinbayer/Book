#import "SoundManager.h"

@interface SoundManager()

//Arrays to store AVAudioPlayers
+(NSMutableArray *)soundArray;
+(NSMutableArray *)narrationArray;
+(NSMutableArray *)musicArray;

//Arrays to store volumes to facilitate mute/unmute
//Index of player and matching volume should be the same for easy look up
+(NSMutableArray *)soundVolumes;
+(NSMutableArray *)narrationVolumes;
+(NSMutableArray *)musicVolumes;

+(SoundManager *)sharedSingleton;

//+(Boolean)soundMuted;
//+(Boolean)narrationMuted;
//+(Boolean)musicMuted;

@end

@implementation SoundManager

////////////////////////////////////////////////////////////////////////////////
//        Static Object access functions
////////////////////////////////////////////////////////////////////////////////

+(SoundManager *)sharedSingleton
{
    static SoundManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[SoundManager alloc] init];
            
        return sharedSingleton;
    }
}

+(NSMutableArray *)soundArray
{
    static NSMutableArray* soundArray = nil;
    
    if (soundArray == nil)
    {
        soundArray = [[NSMutableArray alloc] init];
    }
    
    return soundArray;
}

+(NSMutableArray *)narrationArray
{
    static NSMutableArray* narrationArray = nil;
    
    if (narrationArray == nil)
    {
        narrationArray = [[NSMutableArray alloc] init];
    }
    
    return narrationArray;
}

+(NSMutableArray *)musicArray
{
    static NSMutableArray* musicArray = nil;
    
    if (musicArray == nil)
    {
        musicArray = [[NSMutableArray alloc] init];
    }
    
    return musicArray;
}

+(NSMutableArray *)soundVolumes
{
    static NSMutableArray* soundVolumes = nil;
    
    if (soundVolumes == nil)
    {
        soundVolumes = [[NSMutableArray alloc] init];
    }
    
    return soundVolumes;
}

+(NSMutableArray *)narrationVolumes
{
    static NSMutableArray* narrationVolumes = nil;
    
    if (narrationVolumes == nil)
    {
        narrationVolumes = [[NSMutableArray alloc] init];
    }
    
    return narrationVolumes;
}

+(NSMutableArray *)musicVolumes
{
    static NSMutableArray* musicVolumes = nil;
    
    if (musicVolumes == nil)
    {
        musicVolumes = [[NSMutableArray alloc] init];
    }
    
    return musicVolumes;
}



////////////////////////////////////////////////////////////////////////////////
//        Sound functions
////////////////////////////////////////////////////////////////////////////////

+ (void) playSoundFromFile:(NSString*)theFileName withExt:(NSString*)theFileExt atVolume:(float)volume {
    
	//Get the path of the file
    NSString *path = [[NSBundle mainBundle] pathForResource:theFileName ofType:theFileExt];
    
    NSError *error;
    
    //Make newPlayer with file at path
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    
    //Prepare to play it? I guess?
    [newPlayer prepareToPlay];
    
    //Add to array or dictionary or whatever
    [[SoundManager soundArray] addObject:newPlayer];
    
    //Make SoundManager the delegate of the newPlayer
    newPlayer.delegate = [SoundManager sharedSingleton];
    
    //Assign volume argument to newPlayer volume
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SoundState"]) {
          [newPlayer setVolume:volume];
    }
    else {
        [newPlayer setVolume:0];
    }
    
    //Create an NSNumber to store the volume and then DO it
    NSNumber *newVolume = [[NSNumber alloc] initWithFloat:volume];
    [[SoundManager soundVolumes] addObject:newVolume];
    
    [newPlayer play];
}

+ (void) muteSound {
	
	for (AVAudioPlayer *player in [SoundManager soundArray]) {
        [player setVolume: 0];
    }
}

+ (void) unmuteSound {
	
	for (AVAudioPlayer *player in [SoundManager soundArray]) {
        [player setVolume: [[[SoundManager soundVolumes] objectAtIndex:[[SoundManager soundArray] indexOfObject:player]] floatValue]];
    }
}

+ (void) stopSound {
	
	for (AVAudioPlayer *player in [SoundManager soundArray]) {
        [player stop];
    }
    
    [[SoundManager soundVolumes] removeAllObjects];
    [[SoundManager soundArray] removeAllObjects];
}

+ (void) pauseSound {
    
    for (AVAudioPlayer *player in [SoundManager soundArray]) {
        [player pause];
    }
}

+ (void) resumeSound {
    
    for (AVAudioPlayer *player in [SoundManager soundArray]) {
        [player play];
    }
}



////////////////////////////////////////////////////////////////////////////////
//        Narration Functions
////////////////////////////////////////////////////////////////////////////////

+ (void) playNarrationFromFile:(NSString*)theFileName withExt:(NSString*)theFileExt atVolume:(float)volume {
    
	//Get the path of the file
    NSString *path = [[NSBundle mainBundle] pathForResource:theFileName ofType:theFileExt];
    
    NSError *error;
    
    //Make newPlayer with file at path
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    
    //Prepare to play it? I guess?
    [newPlayer prepareToPlay];
    
    //Add to array or dictionary or whatever
    [[SoundManager narrationArray] addObject:newPlayer];

    //Make SoundManager the delegate of the newPlayer
    newPlayer.delegate = [SoundManager sharedSingleton];
    
    //Assign volume argument to newPlayer volume
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NarrState"])
        [newPlayer setVolume:volume];
    else
        [newPlayer setVolume:0];
    
    //Create an NSNumber to store the volume and then DO it
    NSNumber *newVolume = [[NSNumber alloc] initWithFloat:volume];
    [[SoundManager narrationVolumes] addObject:newVolume];
    
    [newPlayer play];
}

+ (void) muteNarration {
    
    for (AVAudioPlayer *player in [SoundManager narrationArray]) {
        [player setVolume: 0];
    }
}

+ (void) unmuteNarration {
    
    for (AVAudioPlayer *player in [SoundManager narrationArray]) {
        [player setVolume: [[[SoundManager narrationVolumes] objectAtIndex:[[SoundManager narrationArray] indexOfObject:player]] floatValue]];
    }
}

+ (void) stopNarration {
	
	for (AVAudioPlayer *player in [SoundManager narrationArray]) {
        [player stop];
    }
    
    [[SoundManager narrationVolumes] removeAllObjects];
    [[SoundManager narrationArray] removeAllObjects];
}

+ (void) pauseNarration {
    
    for (AVAudioPlayer *player in [SoundManager narrationArray]) {
        [player pause];
    }
}

+ (void) resumeNarration {
    
    for (AVAudioPlayer *player in [SoundManager narrationArray]) {
        [player play];
    }
}



////////////////////////////////////////////////////////////////////////////////
//        Music Functions
////////////////////////////////////////////////////////////////////////////////

+ (void) playMusicFromFile:(NSString*)theFileName withExt:(NSString*)theFileExt atVolume:(float)volume {
    
	//Get the path of the file
    NSString *path = [[NSBundle mainBundle] pathForResource:theFileName ofType:theFileExt];
    
    NSError *error;
    
    //Make newPlayer with file at path
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    
    //Prepare to play it? I guess?
    [newPlayer prepareToPlay];
    
    //Add to array or dictionary or whatever
    [[SoundManager musicArray] addObject:newPlayer];
  
    //Make SoundManager the delegate of the newPlayer
    newPlayer.delegate = [SoundManager sharedSingleton];
    
    //Assign volume argument to newPlayer volume
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MusicState"])
        [newPlayer setVolume:volume];
    else
        [newPlayer setVolume:0];
    
    //Create an NSNumber to store the volume and then DO it
    NSNumber *newVolume = [[NSNumber alloc] initWithFloat:volume];
    [[SoundManager musicVolumes] addObject:newVolume];
    
    //Set to loop infinitely
    [newPlayer setNumberOfLoops:-1];
    
    [newPlayer play];
}

 + (void) muteMusic {
     
     for (AVAudioPlayer *player in [SoundManager musicArray]) {
         [player setVolume: 0];
     }
 }
 
 + (void) unmuteMusic {
     
        for (AVAudioPlayer *player in [SoundManager musicArray]) {
        [player setVolume: [[[SoundManager musicVolumes] objectAtIndex:[[SoundManager musicArray] indexOfObject:player]] floatValue]];
      }
}

+ (void) stopMusic {
    
    for (AVAudioPlayer *player in [SoundManager musicArray]) {
        [player stop];
    }
    
    [[SoundManager musicVolumes] removeAllObjects];
    [[SoundManager musicArray] removeAllObjects];
}

+ (void) pauseMusic {

    for (AVAudioPlayer *player in [SoundManager musicArray]) {
        [player pause];
    }
}

+ (void) resumeMusic {
    
    for (AVAudioPlayer *player in [SoundManager musicArray]) {
        [player play];
    }
}



////////////////////////////////////////////////////////////////////////////////
//        Universal Functions
////////////////////////////////////////////////////////////////////////////////

+ (void) stopAll {
    [SoundManager stopSound];
    [SoundManager stopNarration];
    [SoundManager stopMusic];
}

+ (void) pauseAll {
    [SoundManager pauseSound];
    [SoundManager pauseNarration];
    [SoundManager pauseMusic];
}

+ (void) resumeAll {
    [SoundManager resumeSound];
    [SoundManager resumeNarration];
    [SoundManager resumeMusic];
}



////////////////////////////////////////////////////////////////////////////////
//        Utility Functions
////////////////////////////////////////////////////////////////////////////////

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSUInteger soundIndex = [[SoundManager soundArray] indexOfObject:player];
    NSUInteger narrationIndex = [[SoundManager narrationArray] indexOfObject:player];
    NSUInteger musicIndex = [[SoundManager musicArray] indexOfObject:player];
    
    if(soundIndex != NSNotFound) {
        [[SoundManager soundVolumes] removeObjectAtIndex:soundIndex];
        [[SoundManager soundArray] removeObjectAtIndex:soundIndex];
    }
    else if(narrationIndex != NSNotFound) {
        [[SoundManager narrationVolumes] removeObjectAtIndex:narrationIndex];
        [[SoundManager narrationArray] removeObjectAtIndex:narrationIndex];
    }
    else if(musicIndex != NSNotFound) {
        [[SoundManager musicVolumes] removeObjectAtIndex:musicIndex];
        [[SoundManager musicArray] removeObjectAtIndex:musicIndex];
    }
}

@end
