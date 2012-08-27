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
    
    return scene;
}

@end
