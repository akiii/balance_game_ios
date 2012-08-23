//
//  BGGameBackgroundCityLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameCityLayer.h"


@implementation BGGameCityLayer

- (void)onEnter{
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *s = [CCSprite spriteWithFile:@"city.png"];
    s.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:s];
}

@end
