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

@synthesize titleName;
@synthesize scrollLabel;
@synthesize myMask;
@synthesize onPressedSkipButton;

int labelPositionY;

- (void) onEnter {
    [super onEnter];
    
    //スキップボタン
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"start_button.png" selectedImage:@"start_button_on.png" block:^(id sender){
            if (self.onPressedSkipButton) {
                self.onPressedSkipButton();
//                [self removeChild:myMask cleanup:YES];
            }
        }];
    
    startButton.position = ccp(screenSize.width/2, 50);

    CCMenu *menu = [CCMenu menuWithItems:startButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];

    // 文字を表示する
    titleName = @"2012/03/21(水) おはようニュースABC\r\n2行目です";
    
    // 文字数が多い場合 lineBreakMode で調整 (テクスチャサイズが大きくなる為)
    /*
     NSLog(@"titleName length %d", [titleName length]);
     title =  [CCLabelTTF labelWithString:titleName dimensions:CGSizeMake(1200,12) alignment:CCTextAlignmentLeft lineBreakMode:CCLineBreakModeTailTruncation fontName:@"Arial" fontSize:12];
     */
    
    scrollLabel =  [CCLabelTTF labelWithString:titleName fontName:@"Arial" fontSize:35];
    labelPositionY = -10;
    scrollLabel.position = ccp(0, labelPositionY);
    scrollLabel.color = ccc3(255, 255 ,255);
    scrollLabel.anchorPoint = ccp(0, 0);
    [self addChild:scrollLabel];
    NSLog(@"titleLable.contentSize.height: %f", scrollLabel.contentSize.height);

    /*
    // マスクのスプライトを作成する
    CCSprite *mask = [CCSprite spriteWithFile:@"BGStoryMask.png"];        
    mask.position = ccp(0, 0);
    mask.anchorPoint = ccp(0, 0);
    
    // マスクを適用する
    myMask = [CCMask createMaskForObject:scrollLabel withMask:mask];
    myMask.position = ccp(0, 0);
    myMask.anchorPoint = ccp(0, 0);
    [self addChild:myMask z:100];
    [myMask mask];
     */
    
    // 文字をスクロールさせる為のスケジューラの呼び出し
    [self schedule:@selector(update:) interval:0.1];
 
}

- (void)update:(ccTime)dt {
    // 文字の位置を移動する
        
    labelPositionY = labelPositionY + 3;
    
    if(labelPositionY > 330){
        labelPositionY = -10;
    }
    
//    [self.scrollLabel setPosition: ccp(0, labelPositionY)];
    self.scrollLabel.position = ccp(0, labelPositionY);

//    [myMask mask];
    
}


@end