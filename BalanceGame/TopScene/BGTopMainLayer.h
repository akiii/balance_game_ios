//
//  BGTopMainLayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BGTopMainLayer : CCLayer {

}
@property (nonatomic, retain) BGTopMainLayer *title;
@property (nonatomic, copy) void (^onPressedStartButton)();
@property (nonatomic, retain) CCParticleSystem *emitter;

@end
