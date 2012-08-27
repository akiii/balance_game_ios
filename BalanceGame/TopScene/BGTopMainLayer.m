//
//  BGTopMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGTopMainLayer.h"

#define MOVE_TIME 0.5

@implementation BGTopMainLayer
@synthesize title;

- (void)onEnter{
    [super onEnter];  
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.title = [CCSprite spriteWithFile:@"title.png"];
    self.title.anchorPoint = ccp(0.5, 0.5);
    self.title.position = ccp(-100, 500);
    [self addChild:self.title];
    
    [self.title runAction:[CCSequence actions:
      [CCMoveTo actionWithDuration:2 position:ccp(screenSize.width/2, screenSize.height - (screenSize.height/3))],
      [CCScaleTo actionWithDuration:0.75 scale:1.25],
      [CCScaleTo actionWithDuration:0.75 scale:1],nil]];
}

@end