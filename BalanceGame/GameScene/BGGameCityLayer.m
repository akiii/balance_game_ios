//
//  BGGameBackgroundCityLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameCityLayer.h"

@interface BGGameCityLayer()
@property (nonatomic, retain) CCSprite *background;
@end

@implementation BGGameCityLayer
@synthesize background;

- (void)onEnter{
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.background = [CCSprite spriteWithFile:@"city_morning.png"];
    self.background.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.background];
}

- (void)night{
    [self removeChild:self.background cleanup:YES];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.background = [CCSprite spriteWithFile:@"city_night.png"];
    self.background.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:self.background];
}

@end
