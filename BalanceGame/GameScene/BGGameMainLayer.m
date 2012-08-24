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
    self.tower.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.tower];
    
    ccTime moveTime = 1.0;
    float angle = 15;

    self.tower.anchorPoint = ccp(0, 0);
    id moveLeft = [CCSequence actions:[CCRotateBy actionWithDuration:moveTime angle:-angle], [CCRotateBy actionWithDuration:moveTime angle:angle], nil];

    [self.tower runAction:moveLeft];
//    [self.tower runAction:[CCRotateTo actionWithDuration:3.0 angle:30]];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    NSLog(@"x : %f, y : %f, z : %f", acceleration.x, acceleration.y, acceleration.z);
}

- (void)dealloc{
    self.tower = nil;
    [super dealloc];
}

@end
