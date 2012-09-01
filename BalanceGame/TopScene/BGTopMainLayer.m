//
//  BGTopMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGTopMainLayer.h"
#import "BGSEPlayer.h"

#define MOVE_TIME 0.22

@interface BGTopMainLayer()
@property (nonatomic, retain) CCMenu *buttons;
@end

@implementation BGTopMainLayer
@synthesize title;
@synthesize onPressedStartButton;
@synthesize emitter;
@synthesize buttons;

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
                           [CCCallBlock actionWithBlock:^(id sender){PLAY_SE(@"bigshot1.wav");}],
                           [CCCallFunc actionWithTarget:self selector:@selector(titleEffect)],
                            [CCCallFunc actionWithTarget:self selector:@selector(shakeTitle)],nil]];
    
    CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"start_button.png" selectedImage:@"start_button_on.png" block:^(id sender){
        if (self.onPressedStartButton) self.onPressedStartButton();
    }];
    startButton.position = ccp(screenSize.width/2, 50);
    
    self.buttons = [CCMenu menuWithItems:startButton, nil];
    self.buttons.position = ccp(0, 0);
    [self addChild:self.buttons];
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

- (void)titleEffect {

    self.emitter = [CCParticleFlower node];
    [self addChild:self.emitter];
    self.emitter.autoRemoveOnFinish = YES; 
    self.emitter.position = ccp(120, 220);
    self.emitter.duration = 0.7;
    [self.emitter runAction:[CCMoveTo actionWithDuration:0.7 position:ccp(360, 220)]];
    
    self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars-grayscale.png"];
                                
}
- (void)notActivateButtons{
    for (CCMenuItemImage *b in self.buttons.children) {
        [b setIsEnabled:NO];
    }
}

@end