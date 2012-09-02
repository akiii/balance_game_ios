//
//  BGSelectFacebookFriendTableLayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGRFacebookUser.h"

@interface BGSelectFacebookFriendTableLayer : CCLayer <UITableViewDelegate, UITableViewDataSource> {
    
}
@property (nonatomic, retain) void (^onPressedFacebookFriend)(BGRFacebookUser *selectUser);
@end
