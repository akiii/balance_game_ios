//
//  BGSEPlayre.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/29.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define PLAY_SE(filename) [[BGSEPlayer sharedObject] playWithFileName:filename]

@interface BGSEPlayer : NSObject <AVAudioPlayerDelegate>
+ (BGSEPlayer *)sharedObject;
- (void)playWithFileName:(NSString *)fileName;
//- (void)playLoopSoundEffectWithFileName:(NSString *)fileName;
//- (void)pauseLoopSoundEffectWithFileName:(NSString *)fileName;
//- (void)stopLoopSoundEffectWithFileName:(NSString *)fileName;
@end
