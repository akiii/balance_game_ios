//
//  BGSelectCourseScene.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGRFacebookUser.h"

@interface BGSelectCourseScene : CCScene {
    
}
+ (BGSelectCourseScene *)sceneWithSelectedUser:(BGRFacebookUser *)selectedUser;
@end
