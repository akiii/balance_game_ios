//
//  BGGameManager.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameManager.h"


@implementation BGGameManager
@synthesize currentGameState = _currentGameState, gameTime = _gameTime, onLeftTouchArea = _onLeftTouchArea, onRightTouchArea = _onRightTouchArea;

- (id)init{
    if (self = [super init]) {
        _currentGameState = GameStateTouch;
        _gameTime = 0;
        _onLeftTouchArea = _onRightTouchArea = NO;
        
        [self schedule:@selector(timer:)];
    }
    return self;
}

- (void)timer:(ccTime)dt{
    _gameTime += dt;
}

- (void)setOnLeftTouchArea:(BOOL)flag{
    _onLeftTouchArea = flag;
}

- (void)setOnRightTouchArea:(BOOL)flag{
    _onRightTouchArea = flag;
}

@end
