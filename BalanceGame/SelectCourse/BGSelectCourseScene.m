//
//  BGSelectCourseScene.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGSelectCourseScene.h"
#import "BGSelectCourseMainLayer.h"
#import "BGGameTower.h"
#import "BGFacebookManager.h"

#import "BGGameScene.h"

@implementation BGSelectCourseScene

+ (BGSelectCourseScene *)sceneWithSelectedUser:(BGRFacebookUser *)selectedUser{
    BGSelectCourseScene *scene = [self node];
    
    BGSelectCourseMainLayer *mainLayer = [BGSelectCourseMainLayer node];
    [scene addChild:mainLayer];
    
    mainLayer.onPressedButton = ^(BGGameTower *tower){
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGGameScene sceneWithTower:tower selectedUser:selectedUser] withColor:ccc3(0, 0, 0)]];
    };
    
    return scene;
}

@end
