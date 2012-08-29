//
//  BGSEPlayre.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/29.
//
//

#import "BGSEPlayer.h"

static BGSEPlayer *shared = nil;

@interface BGSEPlayer()
@property (nonatomic, retain) NSMutableDictionary *seDic;
@end

@implementation BGSEPlayer
@synthesize seDic;

+ (BGSEPlayer *)sharedObject{
    if (!shared) {
        shared = [[self alloc] init];
    }
    return shared;
}

- (id)init{
    if (self = [super init]) {
        self.seDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (AVAudioPlayer *)soundWithFileName:(NSString *)fileName{
    AVAudioPlayer *player;
    if (![self.seDic objectForKey:fileName]) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath] error:nil];
    }else {
        player = [self.seDic objectForKey:fileName];
    }
    return player;
}

- (void)playWithFileName:(NSString *)fileName{
    AVAudioPlayer *player = [self soundWithFileName:fileName];
    if (![self.seDic objectForKey:fileName]) {
        [self.seDic setObject:player forKey:fileName];
        [player prepareToPlay];
    }else {
        [player pause];
        player.currentTime = 0;
    }
    [player play];    
}

/*
- (void)playLoopSoundEffectWithFileName:(NSString *)fileName{
    AVAudioPlayer *player = [self soundWithFileName:fileName];
    player.numberOfLoops = -1;
    [player play];
}

- (void)pauseLoopSoundEffectWithFileName:(NSString *)fileName{
    [[self soundWithFileName:fileName] pause];
}

- (void)stopLoopSoundEffectWithFileName:(NSString *)fileName{
    AVAudioPlayer *player = [self soundWithFileName:fileName];
    [player stop];
    NSLog(@"stop");
//    player.currentTime = player.duration;
}
*/

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    for (NSString *key in [self.seDic allKeysForObject:player]) {
        NSLog(@"key : %@", key);
        [player release];
        [seDic removeObjectForKey:key];
    }
}

- (void)dealloc{
    shared = nil;
    self.seDic = nil;
    [super dealloc];
}

@end
