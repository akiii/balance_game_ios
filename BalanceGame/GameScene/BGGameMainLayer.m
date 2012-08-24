//
//  BGGameMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameMainLayer.h"

@interface BGGameMainLayer()
@property (nonatomic, retain) CCSprite *tower;
@end

@implementation BGGameMainLayer
@synthesize tower;

- (void)onEnter{
    [super onEnter];
    
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.tower = [CCSprite spriteWithFile:@"tokyo_tower.png"];
    self.tower.anchorPoint = ccp(1, 0);
    self.tower.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.tower];
    
    [self moveTowerWithAcceleration:nil];
}

- (void)moveTowerWithAcceleration:(UIAcceleration *)acceleration{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    ccTime moveTime = 0.5;
    float angle = 60 * pow(acceleration.y, 2) + 30 * pow(acceleration.z, 2);
    
    id moveLeft = [CCRotateBy actionWithDuration:moveTime/2 angle:-angle];
    id moveRight = [CCRotateBy actionWithDuration:moveTime/2 angle:angle];
    
    if ([self.tower numberOfRunningActions] == 0) {
        [self.tower runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
            self.tower.anchorPoint = ccp(0, 0);
            self.tower.position = ccp(self.tower.position.x - self.tower.contentSize.width, self.position.y + screenSize.height/2 - self.tower.contentSize.height/2);
        }], moveLeft, [moveLeft reverse], [CCCallBlock actionWithBlock:^(){
            self.tower.anchorPoint = ccp(1, 0);
            self.tower.position = ccp(self.tower.position.x + self.tower.contentSize.width, self.position.y + screenSize.height/2 - self.tower.contentSize.height/2);
        }], moveRight, [moveRight reverse], nil]];
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    [self moveTowerWithAcceleration:acceleration];
}

- (void)dealloc{
    self.tower = nil;
    [super dealloc];
}

@end
