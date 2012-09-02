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
#import "BGSelectCourseScene.h"
#import "BGRankingScene.h"

#import "BGBGMPlayer.h"
#import "BGSEPlayer.h"

@implementation BGTopScene

+ (BGTopScene *)scene{
    
    BGTopScene *scene = [self node];
    
    [scene addChild:[BGTopBackgroundLayer node]];
    
    BGTopMainLayer *mainLayer = [BGTopMainLayer node];
    [scene addChild:mainLayer];
    
    PLAY_BGM(@"bgm_top.mp3");
        
    mainLayer.onPressedStartButton = ^(){
        [mainLayer notActivateButtons];
        STOP_BGM;
        PLAY_SE(@"click1.mp3");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認" message:@"二人はFacebookで友達ですか？" delegate:scene cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        [alert release];        
    };
    
    mainLayer.onPressedRankingButton = ^(){
        if (![BGFacebookManager sharedManager].setUsers) {
            [[BGFacebookManager sharedManager] requestUsers];
            [BGFacebookManager sharedManager].onGotUsersDictionary = ^(){
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGRankingScene scene] withColor:ccc3(0, 0, 0)]];
            };
        }else {
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGRankingScene scene] withColor:ccc3(0, 0, 0)]];
        }
    };
    
    return scene;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectCourseScene sceneWithSelectedUser:nil] withColor:ccc3(0, 0, 0)]];
    }else if (buttonIndex == 1) {
        if (((AppController *)[UIApplication sharedApplication].delegate).session.state == FBSessionStateCreated) {
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectUseFacebookScene scene] withColor:ccc3(0, 0, 0)]];
        }else {
            if (![BGFacebookManager sharedManager].setUsers) {
                [[BGFacebookManager sharedManager] requestUsers];
                [BGFacebookManager sharedManager].onGotUsersDictionary = ^(){
                    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectFacebookFriendScene scene] withColor:ccc3(0, 0, 0)]];
                };
            }else {
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectFacebookFriendScene scene] withColor:ccc3(0, 0, 0)]];
            }
        }
    }
}

@end