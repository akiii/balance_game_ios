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
    
    self.bgImg = [CCSprite spriteWithFile:@"background.png"];
    self.bgImg.position = ccp(screenSize.width/2, screenSize.height/2);
    
    [self addChild:self.bgImg];
    
    
    //後ろの街
    
    CCSprite *backCity = [CCSprite spriteWithFile:@"city_back.png"];
    backCity.anchorPoint = ccp(1, 0);
    backCity.position = ccp(580, 0);
    
    [self addChild:backCity];
    
    [backCity runAction:[CCMoveTo actionWithDuration:3.5 position:ccp(720, 0)]];
    
    //前の街
    
    CCSprite *frontCity = [CCSprite spriteWithFile:@"city_front.png"];
    frontCity.anchorPoint = ccp(1, 0);
    frontCity.position = ccp(480, 0);
    
    [self addChild:frontCity];
    
    [frontCity runAction:[CCMoveTo actionWithDuration:3.5 position:ccp(750, 0)]];
    
    //タワー
    
    CCSprite *titleTower = [CCSprite spriteWithFile:@"title_tower.png"];
    titleTower.anchorPoint = ccp(1, 0);
    titleTower.position = ccp(500, -40);
    titleTower.opacity = 0;
    
    [self addChild:titleTower];

    [titleTower runAction:[CCFadeIn actionWithDuration:2]];
}

@end
