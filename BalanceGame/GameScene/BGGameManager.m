//
//  BGGameManager.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameManager.h"


@implementation BGGameManager
@synthesize currentGameState = _currentGameState, currentQuestionCount = _currentQuestionCount, gameTime = _gameTime, awayTouchTime = _awayTouchTime, onLeftTouchArea = _onLeftTouchArea, onRightTouchArea = _onRightTouchArea, isBalloonHidden = _isBalloonHidden;
@synthesize onShowTouchWarning, onShowBalloon, onNotShowBalloon, onSendAcceleration;

- (id)init{
    if (self = [super init]) {
        _currentGameState = GameStateTouch;
        _currentQuestionCount = 1;
        _gameTime = 0;
        _awayTouchTime = 3.0;
        _onLeftTouchArea = _onRightTouchArea = NO;
        _isBalloonHidden = YES;
        
        [self schedule:@selector(timer:)];
    }
    return self;
}

- (void)timer:(ccTime)dt{
    _gameTime += dt;
    
    switch (_currentGameState) {
        case GameStateTouch:
            if (!_onLeftTouchArea || !_onRightTouchArea) {
                if (self.onShowTouchWarning) self.onShowTouchWarning(YES);
            }else {
                if (self.onShowTouchWarning) self.onShowTouchWarning(NO);
                _currentGameState = GameStateQuestion;
            }
            break;
            
        case GameStateQuestion:
            if (_isBalloonHidden) {
                NSArray *words = [self getQuestionWords];                
                NSMutableArray *labels = [NSMutableArray array];
                for (NSString *str in words) {
                    CCLabelTTF *l = [CCLabelTTF labelWithString:str fontName:@"American Typewriter" fontSize:26];
                    l.color = ccc3(0, 0, 0);
                    [labels addObject:l];
                }
                if (self.onShowBalloon) self.onShowBalloon(labels);
                _isBalloonHidden = NO;
            }
            break;
            
        case GameStatePlaing:
            if (!_onLeftTouchArea || !_onRightTouchArea) {
                if (self.onShowTouchWarning) self.onShowTouchWarning(YES);
                _awayTouchTime -= dt;
                if (_awayTouchTime < 0) {
                    _currentGameState = GameStateOver;
                }
            }else {
                _awayTouchTime = 3;
                if (self.onShowTouchWarning) self.onShowTouchWarning(NO);
            }
            break;
            
        case GameStateOver:
            if (self.onShowTouchWarning) self.onShowTouchWarning(NO);

        default:
            break;
    }
}

- (NSArray *)getQuestionWords{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
    int difficuly = 1;
    int question = (_currentQuestionCount - 1) % 3 + 1;
    NSMutableString *word = [NSMutableString stringWithString:[[[[[dic objectForKey:@"Difficulty"] objectForKey:[NSString stringWithFormat:@"%d", difficuly]] objectForKey:@"Tag"] objectForKey:[NSString stringWithFormat:@"%d", question]] objectForKey:@"Word"]];
    NSString *devideString = @",";
    for (int i = 0; (i + 1) * 15 + i < word.length; i++) {
        int ei = (i + 1) * 15 + i;
            [word insertString:devideString atIndex:ei];
    }
    return [word componentsSeparatedByString:devideString];
}

- (void)pressedBalloonOkButton{
    _currentGameState = GameStatePlaing;
    if (self.onNotShowBalloon) self.onNotShowBalloon();
    _isBalloonHidden = YES;
}

- (void)nextQuestion{
    _currentGameState = GameStateQuestion;
    _currentQuestionCount += 1;
}

- (void)setOnLeftTouchArea:(BOOL)flag{
    _onLeftTouchArea = flag;
}

- (void)setOnRightTouchArea:(BOOL)flag{
    _onRightTouchArea = flag;
}

- (void)getAcceleration:(UIAcceleration *)acceleration{
    switch (_currentGameState) {
        case GameStatePlaing:
            if (TOWER_ANGLE(acceleration) > 50) {
                _currentGameState = GameStateOver;
            }
            if (self.onSendAcceleration) self.onSendAcceleration(acceleration);
            break;
            
        case GameStateOver:
            if (self.onSendAcceleration) self.onSendAcceleration(acceleration);
            break;
            
        default:
            break;
    }
}

@end
