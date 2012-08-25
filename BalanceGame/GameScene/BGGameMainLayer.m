//
//  BGGameMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameMainLayer.h"
#import "BGGameTower.h"

@interface BGGameMainLayer()
@property (assign) BOOL gameOver;
@property (nonatomic, retain) BGGameTower *tower;
@end

@implementation BGGameMainLayer
@synthesize gameOver, tower;

- (void)onEnter{
    [super onEnter];
    
    self.gameOver = NO;
    
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.tower = [BGGameTower spriteWithFile:@"tokyo_tower.png"];
    self.tower.anchorPoint = ccp(1, 0);
    self.tower.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.tower];
    
    [self moveTowerWithAcceleration:nil];
}

- (void)moveTowerWithAcceleration:(UIAcceleration *)acceleration{
    float angle = 60 * pow(acceleration.y, 2) + 30 * pow(acceleration.z, 2);
    
    if (!gameOver) {
        if (angle < 50) {
            [self.tower shakeWithAngle:angle];
        }else {
            gameOver = YES;
        }
    }
    if (gameOver) {
        [self.tower fallWithAcceleration:acceleration];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *l = [CCLabelTTF labelWithString:@"Game Over" fontName:@"American Typewriter" fontSize:72];
        l.color = ccc3(255, 0, 0);
        l.scale = 0.0;
        l.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:l];
        
        [l runAction:[CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.8 scale:1.0] rate:10]];
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    if (!gameOver) {
        [self moveTowerWithAcceleration:acceleration];
    }
}

- (void)dealloc{
    self.tower = nil;
    [super dealloc];
}

@end
