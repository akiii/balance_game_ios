//
//  BGStoryMainLayer.m
//  BalanceGame
//
//  Created by  on 12/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

//
//  CCMask.h
//  Masking
//
//  Created by Gilles Lesire on 22/04/11.
//  Copyright 2011 iCapps. All rights reserved.
//

#import "cocos2d.h"
#import "BGStoryMainLayer.h"
#import "CCMask.h"

@implementation BGStoryMainLayer

//@synthesize titleName;
//@synthesize scrollLabel;
//@synthesize myMask;
@synthesize onPressedSkipButton;
@synthesize letter;

int labelPositionY;

- (void) onEnter {
    [super onEnter];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //手紙の描画
    
    self.letter = [CCSprite spriteWithFile:@"story_letter.png"];
    self.letter.anchorPoint = ccp(0.5, 1);
    self.letter.position = ccp(screenSize.width/2 + 16, 0);
    
    [self addChild:self.letter];
    
    [self.letter runAction:[CCSequence actions:
                            [CCMoveTo actionWithDuration:23 position:ccp(screenSize.width/2, 800)],
                           [CCCallBlock actionWithBlock:^(id sender){self.onPressedSkipButton();}],nil ]];
    
    //----スキップボタン----
    
    CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"skip_button.png" selectedImage:@"skip_button.png" block:^(id sender){
            self.onPressedSkipButton();
    }];
    
    startButton.position = ccp(screenSize.width/2, 50);
    
    CCMenu *menu = [CCMenu menuWithItems:startButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    //----スキップボタンここまで----
 
}

/* もういらない文字の動き
- (void)update:(ccTime)dt {
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // 文字の位置を移動する
    labelPositionY = labelPositionY + 1.5;
    
    if(labelPositionY > 340 + 100){
//        labelPositionY = 10;
        
        //タイトル画面へ遷移
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self runAction:[CCCallBlock actionWithBlock:^(){
                if (self.onPressedSkipButton) self.onPressedSkipButton();
            }]];
        });
    }
    
    self.scrollLabel.position = ccp(screenSize.width/2, labelPositionY);

//    [myMask mask];
    
}
*/

@end