//
//  BGGameTower.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameTower.h"

#define MOVE_TIME 0.3

@interface BGGameTower()
@property (readwrite,retain) CCParticleSystem *emitter;
@end

@implementation BGGameTower
@synthesize emitter;

- (void)shakeWithAngle:(float)angle{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    id moveLeft = [CCRotateBy actionWithDuration:MOVE_TIME/2 angle:-angle];
    id moveRight = [CCRotateBy actionWithDuration:MOVE_TIME/2 angle:angle];
    
    if ([self numberOfRunningActions] == 0) {
        [self runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
            self.anchorPoint = ccp(0, 0);
            self.position = ccp(screenSize.width/2 - self.contentSize.width/2, screenSize.height/2 - self.contentSize.height/2);
        }], moveLeft, [moveLeft reverse], [CCCallBlock actionWithBlock:^(){
            self.anchorPoint = ccp(1, 0);
            self.position = ccp(screenSize.width/2 + self.contentSize.width/2, screenSize.height/2 - self.contentSize.height/2);
        }], moveRight, [moveRight reverse], nil]];
    }
}

- (void)fallWithAcceleration:(UIAcceleration *)acceleration{
    [self stopAllActions];
    id action;
    if (acceleration.y > 0) {
        action = [CCRotateBy actionWithDuration:MOVE_TIME angle:90];
    }else {
        action = [CCRotateBy actionWithDuration:MOVE_TIME angle:-90];
    }
    [self runAction:[CCSequence actions:action, [CCCallBlock actionWithBlock:^(){
        [self fire];
    }], nil]];
}

- (void)fire{
	self.emitter = [CCParticleFire node];
    self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"fire.pvr"];
    self.emitter.scale = 0.8;
    self.emitter.life = 0.7;
    self.emitter.endColor = ccc4f(255, 0, 0, 255);
    self.emitter.autoRemoveOnFinish = YES;
    self.emitter.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:self.emitter];
}

@end
