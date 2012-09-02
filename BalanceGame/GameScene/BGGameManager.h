//
//  BGGameManager.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGRFacebookUser.h"
#import "BGFacebookManager.h"

typedef enum {
    GameStateTouch,
    GameStateQuestion,
    GameStatePlaing,
    GameStateOver,
    GameStateAllClear
} GameState;

@interface BGGameManager : CCNode {
    
}
@property (readonly) GameState currentGameState;
@property (readonly) NSMutableArray *questionsOrder;
@property (readonly) int currentQuestionCount;
@property (readonly) ccTime gameTime, awayTouchTime;
@property (readonly) BOOL onLeftTouchArea, onRightTouchArea, isBalloonHidden;
@property (readonly) float towerAngle;
@property (readonly) float remainGameTime;
@property (readonly) float comatibilityParcent;
@property (readonly) float totalTowerAngles;
@property (readonly) float totalPlayGameTime;
@property (readonly) int totalGameFrameCount;
@property (nonatomic, copy) void (^onShowTouchWarning)(BOOL flag);
@property (nonatomic, copy) void (^onShowBalloon)(NSArray *words, NSArray *frame);
@property (nonatomic, copy) void (^onNotShowBalloon)();
@property (nonatomic, copy) void (^onSendAcceleration)(UIAcceleration *acceleration);
@property (nonatomic, copy) void (^onNoticeAllClear)(), (^onNoticeGameOver)(UIAcceleration *acceleration);
- (void)pressedBalloonOkButton;
- (void)nextQuestion;
- (void)setOnLeftTouchArea:(BOOL)flag;
- (void)setOnRightTouchArea:(BOOL)flag;
- (void)getAcceleration:(UIAcceleration *)acceleration;
- (void)postScoreWithSelectedUser:(BGRFacebookUser *)selectedUser;
@end
