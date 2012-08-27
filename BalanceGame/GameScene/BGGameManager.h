//
//  BGGameManager.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    GameStateTouch,
    GameStateQuestion,
    GameStatePlaing,
    GameStateOver,
} GameState;

@interface BGGameManager : CCNode {
    
}
@property (readonly) GameState currentGameState;
@property (readonly) ccTime gameTime;
@property (readonly) BOOL onLeftTouchArea, onRightTouchArea;
- (void)setOnLeftTouchArea:(BOOL)flag;
- (void)setOnRightTouchArea:(BOOL)flag;
@end
