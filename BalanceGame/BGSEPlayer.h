//
//  BGSEPlayre.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/29.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define PLAY_SE(filename)           [[BGSEPlayer sharedObject] playWithFileName:filename]
#define PLAY_LOOP_SE(filename)      [[BGSEPlayer sharedObject] playLoopSoundEffectWithFileName:filename]
#define PAUSE_LOOP_SE(filename)     [[BGSEPlayer sharedObject] pauseLoopSoundEffectWithFileName:filename]
#define RESUME_LOOP_SE(filename)    [[BGSEPlayer sharedObject] resumeLoopSoundEffectWithFileName:filename]
#define STOP_LOOP_SE(filename)      [[BGSEPlayer sharedObject] stopLoopSoundEffectWithFileName:filename]

@interface BGSEPlayer : NSObject <AVAudioPlayerDelegate>
+ (BGSEPlayer *)sharedObject;
- (void)playWithFileName:(NSString *)fileName;
- (void)playLoopSoundEffectWithFileName:(NSString *)fileName;
- (void)pauseLoopSoundEffectWithFileName:(NSString *)fileName;
- (void)resumeLoopSoundEffectWithFileName:(NSString *)fileName;
- (void)stopLoopSoundEffectWithFileName:(NSString *)fileName;
@end
