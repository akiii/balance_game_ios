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
@property (nonatomic, retain) BGGameTower *tower;
@property (nonatomic, retain) CCSprite *leftTouchArea, *rightTouchArea;
@property (nonatomic, retain) CCLabelTTF *touchWarningLabel, *gameOverLabel;
@end

@implementation BGGameMainLayer
@synthesize tower, leftTouchArea, rightTouchArea, touchWarningLabel, gameOverLabel;
@synthesize isOnLeftArea, onSetLeftAreaState, isOnRightArea, onSetRightAreaState, onSendAcceleration, onGetCurrentGameState, onPressedRestartButton;

- (void)onEnter{
    [super onEnter];
        
    self.isTouchEnabled = YES;
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.tower = [BGGameTower spriteWithFile:@"tokyo_tower.png"];
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
    GameState state;
    if (self.onGetCurrentGameState) state = self.onGetCurrentGameState();

    switch (state) {
        case GameStatePlaing:
            [self.tower shakeWithAngle:TOWER_ANGLE(acceleration)];
            break;
            
        case GameStateOver:            
            if (self.gameOverLabel == nil) {
                CGSize screenSize = [CCDirector sharedDirector].winSize;
                [self.tower fallWithAcceleration:acceleration];

                ccTime actionTime = 0.8;
                self.gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"American Typewriter" fontSize:72];
                self.gameOverLabel.color = ccc3(255, 0, 0);
                self.gameOverLabel.scale = 0.0;
                self.gameOverLabel.position = ccp(screenSize.width/2, screenSize.height/2);
                [self addChild:self.gameOverLabel];
                
                [self.gameOverLabel runAction:[CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:actionTime scale:1.0] rate:10]];
                
                double delayInSeconds = actionTime;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    CCMenuItemImage *restartButton = [CCMenuItemImage itemWithNormalImage:@"restart_button.png" selectedImage:@"restart_button_on.png" block:^(id sender){
                        if (self.onPressedRestartButton) self.onPressedRestartButton();
                    }];
                    restartButton.position = ccp(screenSize.width/2, screenSize.height/4);
                    
                    CCMenu *menu = [CCMenu menuWithItems:restartButton, nil];
                    menu.position = ccp(0, 0);
                    [self addChild:menu];
                });
            }
            break;
            
        default:
            break;
    }
}

- (void)getTouchWarningState:(BOOL)show{
    if (show) {
        if (self.touchWarningLabel == nil) {
            CGSize screenSize = [CCDirector sharedDirector].winSize;
            self.touchWarningLabel = [CCLabelTTF labelWithString:@"Touch!" fontName:@"American Typewriter" fontSize:72];
            self.touchWarningLabel.color = ccc3(255, 0, 0);
            self.touchWarningLabel.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:self.touchWarningLabel];
        }
    }else {
        if (self.touchWarningLabel) {
            [self removeChild:self.touchWarningLabel cleanup:YES];
            self.touchWarningLabel = nil;
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
    if (self.onSendAcceleration) self.onSendAcceleration(acceleration);
}

- (void)dealloc{
    self.tower = nil;
    self.leftTouchArea = nil;
    self.rightTouchArea = nil;
    self.touchWarningLabel = nil;
    self.gameOverLabel = nil;
    [super dealloc];
}

@end
