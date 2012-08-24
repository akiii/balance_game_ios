//
//  BGGameTower.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameTower.h"

#define MOVE_TIME 0.3

@implementation BGGameTower

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
    if (acceleration.y > 0) {
        id moveRight = [CCRotateBy actionWithDuration:MOVE_TIME angle:90];
        [self runAction:moveRight];
    }else {
        id moveLeft = [CCRotateBy actionWithDuration:MOVE_TIME angle:-90];
        [self runAction:moveLeft];
    }
}

@end
