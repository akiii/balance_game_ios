//
//  BGTopMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGTopMainLayer.h"

#define MOVE_TIME 0.22

@implementation BGTopMainLayer
@synthesize title;
@synthesize onPressedStartButton;

- (void)onEnter{
    [super onEnter];  
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.title = [CCSprite spriteWithFile:@"title.png"];
    self.title.anchorPoint = ccp(0.5, 0.5);
    self.title.position = ccp(-100, 500);
    self.title.scale = 4;
    [self addChild:self.title];
    [self.title runAction:[CCSequence actions:
                           [CCSpawn actions:[CCMoveTo actionWithDuration:1.7 position:ccp(screenSize.width/2, screenSize.height - (screenSize.height/3))],
                            [CCScaleTo actionWithDuration:1.7 scale:1],nil],
                            [CCCallFunc actionWithTarget:self selector:@selector(shakeTitle)],nil]];
    
    CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"start_button.png" selectedImage:@"start_button_on.png" block:^(id sender){
        if (self.onPressedStartButton) self.onPressedStartButton();
    }];
    startButton.position = ccp(screenSize.width/2, screenSize.height/3);
    
    CCMenu *menu = [CCMenu menuWithItems:startButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

- (void)shakeTitle {
//    [CCSpawn actions:[self.title.anchorPoint = ccp(0.2, 0.5)],
//     [CCPlace actionWithPosition:ccp() ]
    [self.title runAction:
     [CCRepeatForever actionWithAction:
      [CCSequence actions:
       [CCRotateTo actionWithDuration:MOVE_TIME angle:(-5)],
       [CCRotateTo actionWithDuration:MOVE_TIME angle:0],
       [CCRotateTo actionWithDuration:MOVE_TIME angle:5],
       [CCRotateTo actionWithDuration:MOVE_TIME angle:0],      
       nil]
      ]];
}

@end