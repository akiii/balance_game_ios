//
//  BGGameScene.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameScene.h"
#import "BGGameMainLayer.h"


@implementation BGGameScene

+ (BGGameScene *)scene{
    BGGameScene *scene = [self node];
    
    BGGameMainLayer *mainLayer = [BGGameMainLayer node];
    [scene addChild:mainLayer];
    
    return scene;
}

@end
