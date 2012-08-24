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
    
    [self moveTower];
}

- (void)moveTower{
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    ccTime moveTime = 1.0;
    float angle = 15;
    
    id moveLeft = [CCSequence actions:[CCRotateBy actionWithDuration:moveTime/2 angle:-angle], [CCRotateBy actionWithDuration:moveTime/2 angle:angle], nil];
    id moveRight = [CCSequence actions:[CCRotateBy actionWithDuration:moveTime/2 angle:angle], [CCRotateBy actionWithDuration:moveTime/2 angle:-angle], nil];
    
    [self.tower runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
        self.tower.anchorPoint = ccp(0, 0);
        self.tower.position = ccp(self.tower.position.x - self.tower.contentSize.width, self.position.y + screenSize.height/2 - self.tower.contentSize.height/2);
        [self.tower runAction:moveLeft];
    }], [CCDelayTime actionWithDuration:moveTime + 0.1], [CCCallBlock actionWithBlock:^(){
        self.tower.anchorPoint = ccp(1, 0);
        self.tower.position = ccp(self.tower.position.x + self.tower.contentSize.width, self.position.y + screenSize.height/2 - self.tower.contentSize.height/2);
        [self.tower runAction:moveRight];
    }], [CCDelayTime actionWithDuration:moveTime + 0.1], nil]]];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    NSLog(@"x : %f, y : %f, z : %f", acceleration.x, acceleration.y, acceleration.z);
}

- (void)dealloc{
    self.tower = nil;
    [super dealloc];
}

@end
