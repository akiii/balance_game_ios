//
//  BGBGMPlayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/29.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define PLAY_BGM(filename)  [[BGBGMPlayer sharedObject] playWithFileName:filename]
#define STOP_BGM            [[BGBGMPlayer sharedObject] stop]

@interface BGBGMPlayer : NSObject
+ (BGBGMPlayer *)sharedObject;
- (void)playWithFileName:(NSString *)fileName;
- (void)stop;
@end
