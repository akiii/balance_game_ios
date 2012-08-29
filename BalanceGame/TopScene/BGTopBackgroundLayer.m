//
//  BGTopBackgroundLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGTopBackgroundLayer.h"


@implementation BGTopBackgroundLayer

@synthesize bgImg;

-(void)onEnter {
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.bgImg = [CCSprite spriteWithFile:@"title_bg.png"];
    self.bgImg.position = ccp(screenSize.width/2, screenSize.height/2);
    
    [self addChild:self.bgImg];
}

@end
