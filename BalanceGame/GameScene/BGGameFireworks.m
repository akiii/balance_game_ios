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

+ (CCNode *)shotWithColor{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCParticleSystemQuad *fire[3];
    for (int i = 0; i < 3; i++) {
        fire[i] = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
        fire[i].position = ccp(screenSize.width/2, 120);
        fire[i].gravity = ccp(0, 0);
        fire[i].scale = 0.15;
        fire[i].duration = 0.06;
    }
    
    CCNode *node = [CCNode node];
    [node runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
        CCParticleMeteor *meteor = [CCParticleMeteor node];
        meteor.position = ccp(screenSize.width/2, 0);
        meteor.gravity = ccp(0, -screenSize.height);
        meteor.startSize = 1.0;
        meteor.endSizeVar = -10.0;
        meteor.emissionRate = 100.0;
        meteor.radialAccel = -300.0;
        meteor.life = 0.0001;
        meteor.duration = 1.3;
        meteor.startColor = ccc4f(255, 102, 51, 255);
        [node addChild:meteor];
        
        [meteor runAction:[CCMoveBy actionWithDuration:1.5 position:ccp(0, 100)]];
    }], [CCDelayTime actionWithDuration:1.5 + 0.8], [CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
        [node addChild:f];
    } object:fire[0]], [CCDelayTime actionWithDuration:0.2], [CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
        [node addChild:f];
    } object:fire[1]], [CCDelayTime actionWithDuration:0.2], [CCCallBlockO actionWithBlock:^(CCParticleSystemQuad *f){
        [node addChild:f];
    } object:fire[2]], [CCDelayTime actionWithDuration:0.2], nil]]];

    return node;
}

@end