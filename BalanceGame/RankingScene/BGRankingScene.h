//
//  BGRankingScene.h
//  BalanceGame
//
//  Created by Akifumi on 2012/09/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BGRankingScene : CCScene {
    
}
+ (BGRankingScene *)sceneWithFacebookId:(NSString *)facebookId name:(NSString *)name;
@end
