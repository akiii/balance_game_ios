//
//  BGGameResultLayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/09/02.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGRFacebookUser.h"

@interface BGGameResultLayer : CCLayer {
    
}
@property (nonatomic, copy) void (^onPressedRestartButton)();
+ (BGGameResultLayer *)layerWithSuccess:(BOOL)success score:(int)score selectedUser:(BGRFacebookUser *)selectedUser towerNumber:(int)towerNumber;
@end
