//
//  BGGameFireworks.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameFireworks.h"

@interface BGGameFireworks() {
}
@end

@implementation BGGameFireworks
@synthesize onFinished;

- (void)shotWithColor:(ccColor4F)color{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    NSMutableArray *actions = [NSMutableArray array];
    [actions addObjectsFromArray:[NSArray arrayWithObjects:[CCCallBlock actionWithBlock:^(){
        CCParticleMeteor *meteor = [CCParticleMeteor node];
        meteor.position = ccp(0, 0);
        meteor.gravity = ccp(0, -screenSize.height);
        meteor.startSize = 1.0;
        meteor.endSizeVar = -10.0;
        meteor.emissionRate = 100.0;
        meteor.radialAccel = -300.0;
        meteor.life = 0.0001;
        meteor.duration = 1.5;
        meteor.startColor = color;
        meteor.autoRemoveOnFinish = YES;
        [self addChild:meteor];
        
        [meteor runAction:[CCMoveBy actionWithDuration:1.5 position:ccp(0, 100)]];
    }], [CCDelayTime actionWithDuration:1.5 + 0.8], nil]];
    
    float scale = rand()%15 / 100.0 + 0.05;
    int count = scale / 0.03;
    CCParticleSystemQuad *fire[count];
    for (int i = 0; i < count; i++) {
        fire[i] = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
        fire[i].position = ccp(0, 120);
        fire[i].gravity = ccp(0, 0);
        fire[i].scale = scale;
        fire[i].duration = 0.03 * (count - i);
        fire[i].startColor = color;
        fire[i].autoRemoveOnFinish = YES;
    }
    float duration = scale;
    
    for (int i = 0; i < count; i++) {
        [actions addObjectsFromArray:[NSArray arrayWithObjects:[CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
            [self addChild:f];
        } object:fire[i]], [CCDelayTime actionWithDuration:duration], nil]];
    }
    [actions addObjectsFromArray:[NSArray arrayWithObjects:[CCDelayTime actionWithDuration:duration * 2], [CCCallBlock actionWithBlock:^(){
        [self removeAllChildrenWithCleanup:YES];
        if (self.onFinished) self.onFinished();
    }], nil]];
    
    [self runAction:[CCSequence actionWithArray:actions]];
}

@end