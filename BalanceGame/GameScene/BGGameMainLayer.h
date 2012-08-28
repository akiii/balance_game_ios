//
//  BGGameMainLayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGGameManager.h"

@interface BGGameMainLayer : CCLayer {
    
}
@property (nonatomic, copy) void (^onOkButtonPressed)();
@property (nonatomic, copy) BOOL (^isOnLeftArea)();
@property (nonatomic, copy) BOOL (^onSetLeftAreaState)(BOOL flag);
@property (nonatomic, copy) BOOL (^isOnRightArea)();
@property (nonatomic, copy) BOOL (^onSetRightAreaState)(BOOL flag);
@property (nonatomic, copy) void (^onSendAcceleration)(UIAcceleration *acceleration);
@property (nonatomic, copy) GameState (^onGetCurrentGameState)();
@property (nonatomic, copy) void (^onPressedRestartButton)();
- (void)getTouchWarningState:(BOOL)show;
- (void)showBalloonWithWords:(NSArray *)words;
- (void)notShowBalloon;
- (void)moveTowerWithAcceleration:(UIAcceleration *)acceleration;
@end
