//
//  BGGameScene.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGGameTower.h"
#import "BGRFacebookUser.h"
#import "BGFacebookManager.h"

@interface BGGameScene : CCScene {
    
}
+ (BGGameScene *)sceneWithTower:(BGGameTower *)tower selectedUser:(BGRFacebookUser *)selectedUser;
@end
