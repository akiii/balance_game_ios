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
@property (nonatomic, retain) CCSprite *leftTouchArea, *rightTouchArea;
@property (nonatomic, retain) CCLabelTTF *touchWarning;
@end

@implementation BGGameMainLayer
@synthesize gameOver, tower, leftTouchArea, rightTouchArea, touchWarning;
@synthesize isOnLeftArea, onSetLeftAreaState, isOnRightArea, onSetRightAreaState;

- (void)onEnter{
    [super onEnter];
    
    self.gameOver = NO;
    
    self.isTouchEnabled = YES;
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.tower = [BGGameTower spriteWithFile:@"tokyo_tower.png"];
    self.tower.anchorPoint = ccp(1, 0);
    self.tower.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.tower];
    
    self.leftTouchArea = [CCSprite spriteWithFile:@"touch_normal_button_pink.png"];
    self.leftTouchArea.position = ccp(self.leftTouchArea.contentSize.width/2, screenSize.height/2);
    [self addChild:self.leftTouchArea];
    
    self.rightTouchArea = [CCSprite spriteWithFile:@"touch_normal_button_blue.png"];
    self.rightTouchArea.position = ccp(screenSize.width - self.rightTouchArea.contentSize.width/2, screenSize.height/2);
    [self addChild:self.rightTouchArea];
    
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

- (void)getTouchWarningState:(BOOL)show{
    if (show) {
        if (self.touchWarning == nil) {
            CGSize screenSize = [CCDirector sharedDirector].winSize;
            self.touchWarning = [CCLabelTTF labelWithString:@"Touch!" fontName:@"American Typewriter" fontSize:72];
            self.touchWarning.color = ccc3(255, 0, 0);
            self.touchWarning.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:self.touchWarning];
        }
    }else {
        if (self.touchWarning) {
            [self removeChild:self.touchWarning cleanup:YES];
            self.touchWarning = nil;
        }
    }
}

- (CGRect)getRectOfSprite:(CCSprite *)sprite{
    return CGRectMake(sprite.position.x - sprite.contentSize.width/2, sprite.position.y - sprite.contentSize.height/2, sprite.contentSize.width, sprite.contentSize.height);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint cp = [self convertTouchToNodeSpace: touch];
        if (CGRectContainsPoint([self getRectOfSprite:self.leftTouchArea], cp)) {
            if (self.isOnLeftArea) if (!self.isOnLeftArea()) if (self.onSetLeftAreaState) self.onSetLeftAreaState(YES);
        }
        if (CGRectContainsPoint([self getRectOfSprite:self.rightTouchArea], cp)) {
            if (self.isOnRightArea) if (!self.isOnRightArea()) if (self.onSetRightAreaState) self.onSetRightAreaState(YES);
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint pp = [touch previousLocationInView:[CCDirector sharedDirector].view];
        CGPoint cp = [self convertTouchToNodeSpace:touch];
        
        CGRect leftAreaRect = [self getRectOfSprite:self.leftTouchArea];
        if (CGRectContainsPoint(leftAreaRect, pp) && !CGRectContainsPoint(leftAreaRect, cp)) {
            if (self.isOnLeftArea) if (self.isOnLeftArea()) if (self.onSetLeftAreaState) self.onSetLeftAreaState(NO);
        }
        CGRect rightAreaRect = [self getRectOfSprite:self.rightTouchArea];
        if (CGRectContainsPoint(rightAreaRect, pp) && !CGRectContainsPoint(rightAreaRect, cp)) {
            if (self.isOnRightArea) if (self.isOnRightArea()) if (self.onSetRightAreaState) self.onSetRightAreaState(NO);
        }
        
        if (CGRectContainsPoint(leftAreaRect, cp)) {
            if (self.isOnLeftArea) if (!self.isOnLeftArea()) if (self.onSetLeftAreaState) self.onSetLeftAreaState(YES);
        }
        if (CGRectContainsPoint(rightAreaRect, cp)) {
            if (self.isOnRightArea) if (!self.isOnRightArea()) if (self.onSetRightAreaState) self.onSetRightAreaState(YES);
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint cp = [self convertTouchToNodeSpace: touch];
        if (CGRectContainsPoint([self getRectOfSprite:self.leftTouchArea], cp)) {
            if (self.isOnLeftArea) if (self.isOnLeftArea()) if (self.onSetLeftAreaState) self.onSetLeftAreaState(NO);
        }
        if (CGRectContainsPoint([self getRectOfSprite:self.rightTouchArea], cp)) {
            if (self.isOnRightArea) if (self.isOnRightArea()) if (self.onSetRightAreaState) self.onSetRightAreaState(NO);
        }
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    if (!gameOver) {
        [self moveTowerWithAcceleration:acceleration];
    }
}

- (void)dealloc{
    self.tower = nil;
    self.leftTouchArea = nil;
    self.rightTouchArea = nil;
    self.touchWarning = nil;
    [super dealloc];
}

@end
