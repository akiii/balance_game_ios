//
//  BGTopScene.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGTopScene.h"
#import "BGTopBackgroundLayer.h"
#import "BGTopMainLayer.h"
#import "AppDelegate.h"
#import "BGFacebookManager.h"

#import "BGSelectUseFacebookScene.h"
#import "BGSelectFacebookFriendScene.h"

#import "BGBGMPlayer.h"
#import "BGSEPlayer.h"

@implementation BGTopScene

+ (BGTopScene *)scene{
    
    BGTopScene *scene = [self node];
    
    [scene addChild:[BGTopBackgroundLayer node]];
    
    BGTopMainLayer *mainLayer = [BGTopMainLayer node];
    [scene addChild:mainLayer];
    
    PLAY_BGM(@"bgm1.mp3");
        
    mainLayer.onPressedStartButton = ^(){
        STOP_BGM;
        PLAY_SE(@"click1.mp3");
        if (((AppController *)[UIApplication sharedApplication].delegate).session.state == FBSessionStateCreated) {
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectUseFacebookScene scene] withColor:ccc3(0, 0, 0)]];
        }else {
            [[BGFacebookManager sharedManager] requestUsers];
            [BGFacebookManager sharedManager].onGotUsersDictionary = ^(){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectFacebookFriendScene scene] withColor:ccc3(0, 0, 0)]];
            };
        }
    };
    
    return scene;
}

@end