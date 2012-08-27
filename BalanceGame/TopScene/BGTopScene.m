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
#import "BGGameScene.h"

@implementation BGTopScene

+ (BGTopScene *)scene{
    
    BGTopScene *scene = [self node];
    
    [scene addChild:[BGTopBackgroundLayer node]];
    
    BGTopMainLayer *mainLayer = [BGTopMainLayer node];
    [scene addChild:mainLayer];
    
    mainLayer.onPressedStartButton = ^(){
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGGameScene scene] withColor:ccc3(0, 0, 0)]];
    };
    
    return scene;
}

@end