//
//  BGTopMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGTopMainLayer.h"
#import "BGSEPlayer.h"
#import "AppDelegate.h"

#define MOVE_TIME 0.22

@interface BGTopMainLayer()
@property (nonatomic, retain) CCSprite *title;
@property (nonatomic, retain) CCMenu *buttons;
@end

@implementation BGTopMainLayer
@synthesize title;
@synthesize onPressedStartButton, onPressedRankingButton;
@synthesize emitter;
@synthesize buttons;

- (void)onEnter{
    [super onEnter];
    
    [self removeAllChildrenWithCleanup:YES];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.title = [CCSprite spriteWithFile:@"title_logo.png"];
    self.title.anchorPoint = ccp(0.5, 0.5);
    self.title.position = ccp(-100, 500);
    self.title.scale = 4;
    [self addChild:self.title];
    [self.title runAction:[CCSequence actions:
                           [CCSpawn actions:[CCMoveTo actionWithDuration:1.7 position:ccp(screenSize.width/2, screenSize.height - (screenSize.height/3))],
                            [CCScaleTo actionWithDuration:1.7 scale:1],nil],
                           [CCCallFunc actionWithTarget:self selector:@selector(titleEffect)],
                            [CCCallFunc actionWithTarget:self selector:@selector(shakeTitle)],nil]];
    
    CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"start_button.png" selectedImage:@"start_button.png" block:^(id sender){
        if (self.onPressedStartButton) self.onPressedStartButton();
    }];
    startButton.position = ccp(screenSize.width/2, 50);
    
    CCMenuItemImage *rankingButton = [CCMenuItemImage itemWithNormalImage:@"oukan.png" selectedImage:@"oukan.png" block:^(id sender) {
        if (self.onPressedRankingButton) self.onPressedRankingButton();
    }];
    rankingButton.position = ccp(screenSize.width/4, 50);
    
    self.buttons = [CCMenu menuWithItems:startButton, rankingButton, nil];
    self.buttons.position = ccp(0, 0);
    [self addChild:self.buttons];
    
    for (CCMenuItemImage *b in self.buttons.children) {
        [b setIsEnabled:YES];
    }
    
    if (((AppController *)[UIApplication sharedApplication].delegate).session.state == FBSessionStateCreated) {
        rankingButton.visible = NO;
    }
}

- (void)shakeTitle {
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

- (void)titleEffect {
    self.emitter = [CCParticleFlower node];
    [self addChild:self.emitter];
//    self.emitter.autoRemoveOnFinish = YES; 
    self.emitter.position = ccp(120, 220);
    self.emitter.duration = 0.7;
    [self.emitter runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:0.7 position:ccp(360, 220)],
                             [CCCallFunc actionWithTarget:self selector:@selector(blinkStars)],nil]];
    
    self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars-grayscale.png"];
                                
}


- (void)blinkStars {
    

    [self.emitter runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
                             [CCPlace actionWithPosition:ccp(50, 320 - 50)],
                             [CCDelayTime actionWithDuration:1.2],
                             [CCPlace actionWithPosition:ccp(80, 320 - 65)],
                             [CCDelayTime actionWithDuration:0.6],
                             [CCPlace actionWithPosition:ccp(190, 320 - 60)],
                             [CCDelayTime actionWithDuration:1.7],
                                                               nil]
                             ]];
}

- (void)notActivateButtons{
    for (CCMenuItemImage *b in self.buttons.children) {
        [b setIsEnabled:NO];
    }
}

@end