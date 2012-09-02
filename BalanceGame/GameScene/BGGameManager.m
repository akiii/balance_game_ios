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
@synthesize currentGameState = _currentGameState, questionsOrder = _questionsOrder, currentQuestionCount = _currentQuestionCount, gameTime = _gameTime, awayTouchTime = _awayTouchTime, onLeftTouchArea = _onLeftTouchArea, onRightTouchArea = _onRightTouchArea, isBalloonHidden = _isBalloonHidden, towerAngle = _towerAngle, remainGameTime = _remainGameTime, comatibilityParcent = _comatibilityParcent, totalTowerAngles = _totalTowerAngles, totalPlayGameTime = _totalPlayGameTime, totalGameFrameCount = _totalGameFrameCount;
@synthesize onShowTouchWarning, onShowBalloon, onNotShowBalloon, onSendAcceleration, onNoticeAllClear, onNoticeGameOver;

- (id)init{
    if (self = [super init]) {
        srand(time(NULL));
        
        _currentGameState = GameStateTouch;
        _questionsOrder = [[NSMutableArray array] retain];

        NSMutableArray *firstHalf = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
        NSMutableArray *secondHalf = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil];
        [self swap:firstHalf times:10];
        [self swap:secondHalf times:10];
        
        [_questionsOrder addObjectsFromArray:firstHalf];
        [_questionsOrder addObjectsFromArray:secondHalf];
        
        for (int i = 0; i < 5; i++) {
            [_questionsOrder addObject:[NSNumber numberWithInt:i+1]];
        }
        _currentQuestionCount = 1;
        _gameTime = 0;
        _awayTouchTime = 3.0;
        _remainGameTime = 30.0;
        _onLeftTouchArea = _onRightTouchArea = NO;
        _isBalloonHidden = YES;
        _towerAngle = 0;
        _comatibilityParcent = 50.0;
        _totalTowerAngles = 0.0;
        _totalPlayGameTime = 0.0;
        _totalGameFrameCount = 0;
        
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
            _totalPlayGameTime += dt;
            _totalGameFrameCount++;
            _totalTowerAngles += _towerAngle;
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
            if (_remainGameTime > 0) {
                _remainGameTime -= dt;
            }else {
                [self gameOver];
            }
            break;
            
        case GameStateOver:
            if (self.onShowTouchWarning) self.onShowTouchWarning(NO);

        default:
            break;
    }
}

- (void)swap:(NSMutableArray *)array times:(int)times{
    for (int i = 0; i < times; i++) {
        [array exchangeObjectAtIndex:rand()%array.count withObjectAtIndex:rand()%array.count];
    }
}

- (NSDictionary *)getQuestionDictionary{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"]];
//    int difficuly = 1;
//    int question = (_currentQuestionCount - 1) % 8 + 1;
//    NSDictionary *questionDic = [[[[dic objectForKey:@"Difficulty"] objectForKey:[NSString stringWithFormat:@"%d", difficuly]] objectForKey:@"Tag"] objectForKey:[NSString stringWithFormat:@"%d", question]];
//    int question = (_currentQuestionCount - 1) % 5 + 1;
    int question = [[_questionsOrder objectAtIndex:_currentQuestionCount - 1] intValue];
    NSDictionary *questionDic = [[[[dic objectForKey:@"TowerNumber"] objectForKey:[NSString stringWithFormat:@"%d", 1]] objectForKey:@"Tag"] objectForKey:[NSString stringWithFormat:@"%d", question]];
    
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
    if (_currentQuestionCount == 5) {
        _comatibilityParcent = ((int)((150 - _totalPlayGameTime) * _totalTowerAngles / _totalGameFrameCount) % 50) + 10 * _currentQuestionCount;
        _currentGameState = GameStateAllClear;
        if (self.onNoticeAllClear) self.onNoticeAllClear();
    }else if (_currentQuestionCount < 5) {
        _currentGameState = GameStateQuestion;
        _currentQuestionCount += 1;
        _awayTouchTime = 3.0;
        _remainGameTime = 30.0;
    }
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
            
        case GameStateAllClear:
            
//            NSLog(@"total : %f", _totalTowerAngles / _totalGameFrameCount);
            break;
            
        default:
            break;
    }
}

- (void)gameOver{
    _comatibilityParcent = ((int)((150 - _totalPlayGameTime) * _totalTowerAngles / _totalGameFrameCount) % 50) + 10 * _currentQuestionCount;
    _currentGameState = GameStateOver;
    if (self.onNoticeGameOver) self.onNoticeGameOver();
    STOP_LOOP_SE(@"alert.mp3");
    PLAY_SE(@"explosion.mp3");
    [self runAction:[CCRepeat actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
        [BGGameVibrator vibrate];
    }], [CCDelayTime actionWithDuration:0.1], nil] times:100]];
}

- (void)postScoreWithSelectedUser:(BGRFacebookUser *)selectedUser{
    if (selectedUser != nil) {
        BGRFacebookUser *me = [BGFacebookManager sharedManager].currentUser;
        NSString *urlStr = @"http://akiiisuke.com:3011/scores/post_score/";
        urlStr = [urlStr stringByAppendingPathComponent:me.uid];
        urlStr = [urlStr stringByAppendingPathComponent:selectedUser.uid];
        urlStr = [urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", (int)_comatibilityParcent]];
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [NSURLConnection connectionWithRequest:req delegate:self];
    }
}

- (void)dealloc{
    [_questionsOrder release];
    [super dealloc];
}

@end
