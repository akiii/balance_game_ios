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


@implementation BGGameScene

+ (BGGameScene *)scene{
    BGGameScene *scene = [self node];
    
    BGGameManager *manager = [BGGameManager node];
    [scene addChild:manager];
    
    [scene addChild:[BGGameCityLayer node]];
    
    BGGameMainLayer *mainLayer = [BGGameMainLayer node];
    [scene addChild:mainLayer];
    
    manager.onShowTouchWarning = ^(BOOL flag){
        [mainLayer getTouchWarningState:flag];
    };
    
    manager.onShowBalloon = ^(NSArray *words){
        [mainLayer showBalloonWithWords:words];
        [mainLayer notShowNextButton];

    };
    
    manager.onNotShowBalloon = ^(){
        [mainLayer notShowBalloon];
        [mainLayer showNextButton];
    };
    
    manager.onSendAcceleration = ^(UIAcceleration *acceleration){
        [mainLayer moveTowerWithAngle:manager.towerAngle acceleration:acceleration];
    };
    
    mainLayer.onOkButtonPressed = ^(){
        [manager pressedBalloonOkButton];
    };
    
    mainLayer.onNextButtonPressed = ^(){
        [manager nextQuestion];
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
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGGameScene scene] withColor:ccc3(0, 0, 0)]];
    };
    
    return scene;
}

@end
