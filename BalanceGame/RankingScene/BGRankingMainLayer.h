//
//  BGRankingMainLayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/09/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGRFacebookUser.h"

@interface BGRankingMainLayer : CCLayer <UITableViewDelegate, UITableViewDataSource> {
    
}
+ (BGRankingMainLayer *)layerWithFacebookId:(NSString *)facebookId name:(NSString *)name;
@property (nonatomic, retain) void (^onPressedFacebookUser)(NSString *facebookId, NSString *name);
@end