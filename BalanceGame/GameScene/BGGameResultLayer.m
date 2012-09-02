//
//  BGGameResultLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/09/02.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameResultLayer.h"


@implementation BGGameResultLayer

+ (BGGameResultLayer *)layerWithSuccess:(BOOL)success score:(int)score selectedUser:(BGRFacebookUser *)selectedUser towerNumber:(int)towerNumber{
    return [self node];
}

@end
