//
//  BGSelectUseFacebookScene.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGSelectUseFacebookScene.h"
#import "BGSelectUseFacebookMainLayer.h"

#import "BGSelectCourseScene.h"

@implementation BGSelectUseFacebookScene

+ (BGSelectUseFacebookScene *)scene{
    BGSelectUseFacebookScene *scene = [self node];
    
    BGSelectUseFacebookMainLayer *mainLayer = [BGSelectUseFacebookMainLayer node];
    [scene addChild:mainLayer];
    
    mainLayer.onPressedFacebookLoginButton = ^(){
        FBSession *session = ((AppController *)[UIApplication sharedApplication].delegate).session;
        if (!session || session.state != FBSessionStateCreated) {
            session = [[FBSession alloc] init];
        }
        [session openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (!error) {                
                [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectCourseScene scene] withColor:ccc3(0, 0, 0)]];
            }else {
            }
        }];
    };
    
    mainLayer.onPressedSkipButton = ^(){
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGSelectCourseScene scene] withColor:ccc3(0, 0, 0)]];
    };
    
    return scene;
}

@end
