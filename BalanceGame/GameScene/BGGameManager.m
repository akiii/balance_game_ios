//
//  BGGameManager.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameManager.h"
#import "BGSEPlayer.h"
#import "BGGameVibrator.h"

#define kLabels                 @"labels"
#define kImageAnimationFrames   @"image_animation_frames"

@implementation BGGameManager
@synthesize currentGameState = _currentGameState, currentQuestionCount = _currentQuestionCount, gameTime = _gameTime, awayTouchTime = _awayTouchTime, onLeftTouchArea = _onLeftTouchArea, onRightTouchArea = _onRightTouchArea, isBalloonHidden = _isBalloonHidden, towerAngle = _towerAngle;
@synthesize onShowTouchWarning, onShowBalloon, onNotShowBalloon, onSendAcceleration;

- (id)init{
    if (self = [super init]) {
        _currentGameState = GameStateTouch;
        _currentQuestionCount = 1;
        _gameTime = 0;
        _awayTouchTime = 3.0;
        _onLeftTouchArea = _onRightTouchArea = NO;
        _isBalloonHidden = YES;
        _towerAngle = 0;
        
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
            if (self.onShowTouchWarning) self.onShowTouchWarning(NO);
            if (_isBalloonHidden) {
                NSDictionary *questionDictionary = [self getQuestionDictionary];
                if (self.onShowBalloon) self.onShowBalloon([questionDictionary objectForKey:kLabels], [questionDictionary objectForKey:kImageAnimationFrames]);
                _isBalloonHidden = NO;
            }
            break;
            
        case GameStatePlaing:
            if (!_onLeftTouchArea || !_onRightTouchArea) {
                if (self.onShowTouchWarning) self.onShowTouchWarning(YES);
                _awayTouchTime -= dt;
                if (_awayTouchTime < 0) {
                    [self gameOver];
                }
            }else {
                _awayTouchTime = 3.0;
                if (self.onShowTouchWarning) self.onShowTouchWarning(NO);
            }
            break;
            
        case GameStateOver:
            if (self.onShowTouchWarning) self.onShowTouchWarning(NO);

        default:
            break;
    }
}

- (NSDictionary *)getQuestionDictionary{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
    int difficuly = 1;
    int question = (_currentQuestionCount - 1) % 8 + 1;
    NSDictionary *questionDic = [[[[dic objectForKey:@"Difficulty"] objectForKey:[NSString stringWithFormat:@"%d", difficuly]] objectForKey:@"Tag"] objectForKey:[NSString stringWithFormat:@"%d", question]];
    
    NSMutableString *word = [NSMutableString stringWithString:[questionDic objectForKey:@"Word"]];
    NSArray *imageStrings = [questionDic objectForKey:@"Images"];
    
    NSString *devideString = @",";
    for (int i = 0; (i + 1) * 15 + i < word.length; i++) {
        int ei = (i + 1) * 15 + i;
        [word insertString:devideString atIndex:ei];
    }
    
    NSMutableArray *labels = [NSMutableArray array];
    for (NSString *str in [word componentsSeparatedByString:devideString]) {
        CCLabelTTF *l = [CCLabelTTF labelWithString:str fontName:@"American Typewriter" fontSize:26];
        l.color = ccc3(0, 0, 0);
        [labels addObject:l];
    }
    
    NSMutableArray *imageAnimationFrames = [NSMutableArray array];
    for (int i = 0; i < imageStrings.count; i++) {
        CCSprite *sprite = [CCSprite spriteWithFile:[imageStrings objectAtIndex:i]];
        [imageAnimationFrames addObject:[CCSpriteFrame frameWithTexture:sprite.texture rect:CGRectMake(0, 0, sprite.contentSize.width, sprite.contentSize.height)]];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:labels, kLabels, imageAnimationFrames, kImageAnimationFrames, nil];
}

- (void)pressedBalloonOkButton{
    _currentGameState = GameStatePlaing;
    if (self.onNotShowBalloon) self.onNotShowBalloon();
    _isBalloonHidden = YES;
}

- (void)nextQuestion{
    _currentGameState = GameStateQuestion;
    _currentQuestionCount += 1;
    _awayTouchTime = 3.0;
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
            if ((2 * sqrt(pow(acceleration.y, 2)) + 1 * sqrt(pow(acceleration.z, 2))) * 30 > _towerAngle) {
                _towerAngle += (2 * sqrt(pow(acceleration.y, 2)) + 1 * sqrt(pow(acceleration.z, 2))) * 1;
            }else {
                _towerAngle -= (2 * acceleration.x + 1 * sqrt(pow(acceleration.z, 2))) * 0.5;
                _towerAngle = max(0, _towerAngle);
            }
            
            if (_towerAngle > 20) {
                PLAY_LOOP_SE(@"alert.mp3");
            }else {
                STOP_LOOP_SE(@"alert.mp3");
            }
            
            if (_towerAngle > 50) {
                [self gameOver];
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

- (void)gameOver{
    _currentGameState = GameStateOver;
    STOP_LOOP_SE(@"alert.mp3");
    PLAY_SE(@"explosion.mp3");
    [self runAction:[CCRepeat actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
        [BGGameVibrator vibrate];
    }], [CCDelayTime actionWithDuration:0.1], nil] times:100]];
}

@end
