//
//  BGStoryScene.m
//  BalanceGame
//
//  Created by  on 12/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGStoryScene.h"
#import "BGStoryBackgroundLayer.h"
#import "BGStoryMainLayer.h"
#import "BGStoryBackgroundLayer.h"

#import "CCMask.h"

#import "BGTopScene.h"

#import "BGBGMPlayer.h"
#import "BGSEPlayer.h"

@implementation BGStoryScene


+ (BGStoryScene *)scene{
    
    BGStoryScene *scene = [self node];
    
    [scene addChild:[BGStoryBackgroundLayer node]];
    
    BGStoryMainLayer *mainLayer = [BGStoryMainLayer node];
    [scene addChild:mainLayer];
    
    mainLayer.onPressedSkipButton = ^(){
        
        STOP_BGM;
        PLAY_SE(@"click1.mp3");
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BGTopScene scene] withColor:ccc3(0, 0, 0)]];
    };
    
    
    return scene;
}

@end
