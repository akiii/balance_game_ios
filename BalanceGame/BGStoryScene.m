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
#import "BGBGMPlayer.h"
#import "BGStoryBackgroundLayer.h"

@implementation BGStoryScene

+ (BGStoryScene *)scene{
    
    BGStoryScene *scene = [self node];
    
    [scene addChild:[BGStoryBackgroundLayer node]];
    
    BGStoryMainLayer *mainLayer = [BGStoryMainLayer node];
    [scene addChild:mainLayer];
    
    PLAY_BGM(@"bgm1.mp3");
    
    return scene;
}

@end
