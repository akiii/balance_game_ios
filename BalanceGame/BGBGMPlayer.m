//
//  BGBGMPlayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/29.
//
//

#import "BGBGMPlayer.h"

static BGBGMPlayer *shared = nil;

@interface BGBGMPlayer()
@property (nonatomic, retain) AVAudioPlayer *bgm;
@end

@implementation BGBGMPlayer
@synthesize bgm;

+ (BGBGMPlayer *)sharedObject{
    if (!shared) {
        shared = [[self alloc] init];
    }
    return shared;
}

- (void)playWithFileName:(NSString *)fileName{
    [self stop];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    self.bgm = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fullPath] error:nil] autorelease];
    self.bgm.currentTime = 0;
    self.bgm.numberOfLoops = -1;
    [self.bgm play];
}

- (void)stop{
    if (self.bgm) {
        [self.bgm stop];
        self.bgm = nil;
    }
}

- (void)dealloc{
    shared = nil;
    [super dealloc];
}

@end
