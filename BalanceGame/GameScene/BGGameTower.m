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
@property (readwrite, retain) CCParticleSystem *fire;
@end

@implementation BGGameTower
@synthesize fire;

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
    [self runAction:[CCSequence actions:[CCRotateTo actionWithDuration:0 angle:0], action, [CCCallBlock actionWithBlock:^(){
        [self fireWithAcceleration:(UIAcceleration *)acceleration];
    }], nil]];
}

- (void)fireWithAcceleration:(UIAcceleration *)acceleration{
	self.fire = [CCParticleFire node];
    self.fire.texture = [[CCTextureCache sharedTextureCache] addImage:@"fire.pvr"];
    self.fire.scaleX = 0.8;
    self.fire.scaleY = 1.5;
    self.fire.life = 0.7;
    self.fire.endColor = ccc4f(255, 0, 0, 255);
    if (acceleration.y > 0) {
        self.fire.gravity = ccp(-300, -50);
    }else {
        self.fire.gravity = ccp(300, -100);
    }
    self.fire.autoRemoveOnFinish = YES;
    self.fire.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:self.fire];
}

@end
