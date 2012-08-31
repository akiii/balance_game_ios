//
//  BGGameScene.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameScene.h"
#import "BGGameManager.h"
#import "BGGameCityLayer.h"
#import "BGGameMainLayer.h"

#import "BGSelectCourseScene.h"

@implementation BGGameScene

+ (BGGameScene *)sceneWithTower:(BGGameTower *)tower{
    BGGameScene *scene = [self node];
    
    BGGameManager *manager = [BGGameManager node];
    [scene addChild:manager];
    
    BGGameCityLayer *backgroundLayer = [BGGameCityLayer node];
    [scene addChild:backgroundLayer];
    
    BGGameMainLayer *mainLayer = [BGGameMainLayer layerWithTower:tower];
    [scene addChild:mainLayer];
    
    manager.onShowTouchWarning = ^(BOOL flag){
        [mainLayer getTouchWarningState:flag];
    };
    
    manager.onShowBalloon = ^(NSArray *words, NSArray *frame){
        [mainLayer showBalloonWithWords:words imagesAnimationFrame:frame];
        [mainLayer notShowNextButton];
    };
    
    manager.onNotShowBalloon = ^(){
        [mainLayer notShowBalloon];
        [mainLayer showNextButton];
    };
    
    manager.onSendAcceleration = ^(UIAcceleration *acceleration){
        [mainLayer moveTowerWithAngle:manager.towerAngle acceleration:acceleration];
    };
    
    manager.onNoticeAllClear = ^(){
        [mainLayer allClear];
    };
    
    mainLayer.onOkButtonPressed = ^(){
        [manager pressedBalloonOkButton];
    };
    
    mainLayer.onNextButtonPressed = ^(){
        ccTime time;
        if (manager.currentQuestionCount < 3) {
            time = 3.0;
        }else {
            time = 5.0;
        }
        [mainLayer clearWithShowTime:time];
        [scene runAction:[CCSequence actions:[CCDelayTime actionWithDuration:time], [CCCallBlock actionWithBlock:^(){
            if (manager.currentQuestionCount == 2) {
                [backgroundLayer night];
            }
            [manager nextQuestion];
        }], nil]];
        
        if (manager.currentQuestionCount > 2) {
            [mainLayer showFireworks];
        }
    };
    
    mainLayer.isOnLeftArea = ^(){
        return manager.onLeftTouchArea;
    };
    
    mainLayer.isOnRightArea = ^(){
        return manager.onRightTouchArea;
    };
    
    mainLayer.onSetLeftAreaState = ^(BOOL flag){
        [manager setOnLeftTouchArea:flag];
        return manager.onLeftTouchArea;
    };
    
    mainLayer.onSetRightAreaState = ^(BOOL flag){
        [manager setOnRightTouchArea:flag];
        return manager.onRightTouchArea;
    };
    
    mainLayer.onSendAcceleration = ^(UIAcceleration *acceleration){
        [manager getAcceleration:acceleration];
    };
    
    mainLayer.onGetCurrentGameState = ^(){
        return manager.currentGameState;
    };
    
    mainLayer.onPressedRestartButton = ^(){        
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectCourseScene scene] withColor:ccc3(0, 0, 0)]];
    };
    
    return scene;
}

@end
