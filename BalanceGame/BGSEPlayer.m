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
        player.delegate = self;
        [self.seDic setObject:player forKey:fileName];
    }else {
        player = [self.seDic objectForKey:fileName];
    }
    return player;
}

- (void)playWithFileName:(NSString *)fileName loop:(BOOL)loop{
    AVAudioPlayer *player = [self soundWithFileName:fileName];
    if (loop) {
        player.numberOfLoops = -1;
    }else {
        player.numberOfLoops = 0;
        [player pause];
        player.currentTime = 0;
    }
    [player prepareToPlay];
    [player play];
}

- (void)playWithFileName:(NSString *)fileName{
    [self playWithFileName:fileName loop:NO];
}

- (void)playLoopSoundEffectWithFileName:(NSString *)fileName{
    [self playWithFileName:fileName loop:YES];
}

- (void)pauseLoopSoundEffectWithFileName:(NSString *)fileName{
    [[self soundWithFileName:fileName] pause];
}

- (void)resumeLoopSoundEffectWithFileName:(NSString *)fileName{

}

- (void)stopLoopSoundEffectWithFileName:(NSString *)fileName{
    AVAudioPlayer *player = [self soundWithFileName:fileName];
    player.numberOfLoops = 0;
    player.currentTime = player.duration;
    [player stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player.numberOfLoops == 0) {
        for (NSString *key in [self.seDic allKeysForObject:player]) {
            [player release];
            [seDic removeObjectForKey:key];
        }
    }
}

- (void)dealloc{
    shared = nil;
    self.seDic = nil;
    [super dealloc];
}

@end
