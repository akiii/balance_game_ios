//
//  BGGameMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameMainLayer.h"
#import "BGGameBalloon.h"
#import "BGGameFireworks.h"

enum _BGGameMainLayerZ{
    BGGameMainLayerZTower       = 0,
    BGGameMainLayerZTouchArea   = 1,
    BGGameMainLayerZBalloon     = 2,
    BGGameMainLayerZLabel       = 3
} BGGameMainLayerZ;

@interface BGGameMainLayer()
@property (nonatomic, retain) BGGameTower *tower;
@property (nonatomic, retain) BGGameBalloon *balloon;
@property (nonatomic, retain) CCMenuItemImage *nextButton;
@property (nonatomic, retain) CCSprite *leftTouchArea, *rightTouchArea;
@property (nonatomic, retain) CCLabelTTF *touchWarningLabel, *gameOverLabel;
@end

@implementation BGGameMainLayer
@synthesize tower, balloon, nextButton, leftTouchArea, rightTouchArea, touchWarningLabel, gameOverLabel;
@synthesize onOkButtonPressed, onNextButtonPressed, isOnLeftArea, onSetLeftAreaState, isOnRightArea, onSetRightAreaState, onSendAcceleration, onGetCurrentGameState, onPressedRestartButton;

+ (BGGameMainLayer *)layerWithTower:(BGGameTower *)t{
    BGGameMainLayer *layer = [self node];
    layer.tower = t;
    return layer;
}

- (void)onEnter{
    [super onEnter];
        
    self.isTouchEnabled = YES;
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    self.isAccelerometerEnabled = YES;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.tower.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.tower z:BGGameMainLayerZTower];
    
    self.balloon = [BGGameBalloon node];
    self.balloon.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.balloon z:BGGameMainLayerZBalloon];
    
    self.balloon.onOkButtonPressed = ^(){
        if (self.onOkButtonPressed) self.onOkButtonPressed();
    };
    
    self.nextButton = [CCMenuItemImage itemWithNormalImage:@"ok_button.png" selectedImage:@"ok_button.png" block:^(id sender){
        if (self.onNextButtonPressed) self.onNextButtonPressed();
    }];
    self.nextButton.position = ccp(screenSize.width/2, self.nextButton.contentSize.height/2);
    [self notShowNextButton];
    
    CCMenu *menu = [CCMenu menuWithItems:nextButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu z:BGGameMainLayerZTouchArea];
    
    self.leftTouchArea = [CCSprite spriteWithFile:@"touch_normal_button_pink.png"];
    self.leftTouchArea.position = ccp(self.leftTouchArea.contentSize.width/2, screenSize.height/2);
    [self addChild:self.leftTouchArea z:BGGameMainLayerZTouchArea];
    
    self.rightTouchArea = [CCSprite spriteWithFile:@"touch_normal_button_blue.png"];
    self.rightTouchArea.position = ccp(screenSize.width - self.rightTouchArea.contentSize.width/2, screenSize.height/2);
    [self addChild:self.rightTouchArea z:BGGameMainLayerZTouchArea];
    
    [self moveTowerWithAngle:0 acceleration:nil];
}

- (void)moveTowerWithAngle:(float)angle acceleration:(UIAcceleration *)acceleration{
    GameState state;
    if (self.onGetCurrentGameState) state = self.onGetCurrentGameState();

    switch (state) {
        case GameStatePlaing:
            [self.tower shakeWithAngle:angle];
            break;
            
        case GameStateOver:
            [self notShowNextButton];
            if (self.gameOverLabel == nil) {
                CGSize screenSize = [CCDirector sharedDirector].winSize;
                [self.tower fallWithAcceleration:acceleration];

                ccTime actionTime = 0.8;
                self.gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"American Typewriter" fontSize:72];
                self.gameOverLabel.color = ccc3(255, 0, 0);
                self.gameOverLabel.scale = 0.0;
                self.gameOverLabel.position = ccp(screenSize.width/2, screenSize.height/2);
                [self addChild:self.gameOverLabel z:BGGameMainLayerZLabel];
                
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
                    [self addChild:menu z:BGGameMainLayerZLabel];
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
            [self addChild:self.touchWarningLabel z:BGGameMainLayerZLabel];
        }
    }else {
        if (self.touchWarningLabel) {
            [self removeChild:self.touchWarningLabel cleanup:YES];
            self.touchWarningLabel = nil;
        }
    }
}

- (void)showNextButton{
    self.nextButton.visible = YES;
}

- (void)notShowNextButton{
    self.nextButton.visible = NO;
}

- (void)showBalloonWithWords:(NSArray *)words imagesAnimationFrame:(NSArray *)frame{
    [self.balloon showWithWords:words imagesAnimationFrame:frame];
}

- (void)notShowBalloon{
    [self.balloon notShow];
}

- (CGRect)getRectOfSprite:(CCSprite *)sprite{
    return CGRectMake(sprite.position.x - sprite.contentSize.width/2, sprite.position.y - sprite.contentSize.height/2, sprite.contentSize.width, sprite.contentSize.height);
}

- (void)clearWithShowTime:(ccTime)time{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.nextButton.visible = NO;

    CCSprite *circle = [CCSprite spriteWithFile:@"circle.png"];
    circle.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:circle];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:time], [CCCallBlock actionWithBlock:^(){
        [self removeChild:circle cleanup:YES];
    }], nil]];
}

- (void)showFireworksForever:(BOOL)forever{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    NSMutableArray *blocks = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        [blocks addObjectsFromArray:[NSArray arrayWithObjects:[CCCallBlock actionWithBlock:^(){
            BGGameFireworks *firewords = [BGGameFireworks node];
            float x = rand()%(int)screenSize.width;
            float y = rand()%100 + 50;
            firewords.position = ccp(x, y);
            float r = rand()%10 / 10.0;
            float g = rand()%10 / 10.0;
            float b = rand()%10 / 10.0;
            [firewords shotWithColor:ccc4f(r, g, b, 1)];
            [self addChild:firewords];
            firewords.onFinished = ^(){
                [self removeChild:firewords cleanup:YES];
            };
        }], [CCDelayTime actionWithDuration:0.1], nil]];
    }
    
    if (forever) {
        [self runAction:[CCRepeatForever actionWithAction:[CCSequence actionWithArray:blocks]]];
    }else {
        [self runAction:[CCSequence actionWithArray:blocks]];
    }
}

- (void)allClear{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.leftTouchArea.visible = self.rightTouchArea.visible = NO;
    
    ccTime actionTime = 0.8;
    double delayInSeconds = actionTime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CCMenuItemImage *restartButton = [CCMenuItemImage itemWithNormalImage:@"restart_button.png" selectedImage:@"restart_button_on.png" block:^(id sender){
            if (self.onPressedRestartButton) self.onPressedRestartButton();
        }];
        restartButton.position = ccp(screenSize.width/2, screenSize.height/5);
        
        CCMenu *menu = [CCMenu menuWithItems:restartButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu z:BGGameMainLayerZLabel];
    });
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
    self.balloon = nil;
    self.nextButton = nil;
    self.leftTouchArea = nil;
    self.rightTouchArea = nil;
    self.touchWarningLabel = nil;
    self.gameOverLabel = nil;
    [super dealloc];
}

@end
