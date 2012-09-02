//
//  BGRankingScene.m
//  BalanceGame
//
//  Created by Akifumi on 2012/09/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGRankingScene.h"
#import "BGRankingMainLayer.h"

@implementation BGRankingScene

+ (BGRankingScene *)scene{
    BGRankingScene *scene = [self node];
    
    BGRankingMainLayer *mainLayer = [BGRankingMainLayer node];
    [scene addChild:mainLayer];
    
    return scene;
}

@end
