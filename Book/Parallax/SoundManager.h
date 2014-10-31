#import <Foundation/Foundation.h>

#import <AVFoundation/AVAudioPlayer.h>

@interface SoundManager : NSObject <AVAudioPlayerDelegate>


+ (void) playSoundFromFile:(NSString*)theFileName withExt:(NSString*)theFileExt atVolume:(float) volume;
+ (void) muteSound;
+ (void) unmuteSound;
+ (void) stopSound;
+ (void) pauseSound;
+ (void) resumeSound;


+ (void) playNarrationFromFile:(NSString*)theFileName withExt:(NSString*)theFileExt atVolume:(float)volume;
+ (void) muteNarration;
+ (void) unmuteNarration;
+ (void) stopNarration;
+ (void) pauseNarration;
+ (void) resumeNarration;


+ (void) playMusicFromFile:(NSString*)theFileName withExt:(NSString*)theFileExt atVolume:(float)volume;
+ (void) muteMusic;
+ (void) unmuteMusic;
+ (void) stopMusic;
+ (void) pauseMusic;
+ (void) resumeMusic;


+ (void) stopAll;
+ (void) pauseAll;
+ (void) resumeAll;


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
