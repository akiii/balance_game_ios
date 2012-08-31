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
    
    CCParticleSystemQuad *fire[3];
    for (int i = 0; i < 3; i++) {
        fire[i] = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
        fire[i].position = ccp(0, 120);
        fire[i].gravity = ccp(0, 0);
        fire[i].scale = 0.15;
        fire[i].duration = 0.10;
        fire[i].startColor = color;
        fire[i].autoRemoveOnFinish = YES;
    }
    
    [self runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
        CCParticleMeteor *meteor = [CCParticleMeteor node];
        meteor.position = ccp(0, 0);
        meteor.gravity = ccp(0, -screenSize.height);
        meteor.startSize = 1.0;
        meteor.endSizeVar = -10.0;
        meteor.emissionRate = 100.0;
        meteor.radialAccel = -300.0;
        meteor.life = 0.0001;
        meteor.duration = 1.3;
        meteor.startColor = color;
        meteor.autoRemoveOnFinish = YES;
        [self addChild:meteor];
        
        [meteor runAction:[CCMoveBy actionWithDuration:1.5 position:ccp(0, 100)]];
    }], [CCDelayTime actionWithDuration:1.5 + 0.8], [CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
        [self addChild:f];
    } object:fire[0]], [CCDelayTime actionWithDuration:0.2], [CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
        [self addChild:f];
    } object:fire[1]], [CCDelayTime actionWithDuration:0.2], [CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
        [self addChild:f];
    } object:fire[2]], [CCDelayTime actionWithDuration:0.2], [CCCallBlock actionWithBlock:^(){
        [self removeAllChildrenWithCleanup:YES];
        if (self.onFinished) self.onFinished();
    }], nil]];
}

@end