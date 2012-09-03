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

+ (BGRankingScene *)sceneWithFacebookId:(NSString *)facebookId name:(NSString *)name{
    BGRankingScene *scene = [self node];
    
    BGRankingMainLayer *mainLayer = [BGRankingMainLayer layerWithFacebookId:facebookId name:name];
    [scene addChild:mainLayer];
    
    mainLayer.onPressedFacebookUser = ^(NSString *fid, NSString *name){
        [[CCDirector sharedDirector] pushScene:[BGRankingScene sceneWithFacebookId:fid name:name]];
    };
    
    return scene;
}

@end
