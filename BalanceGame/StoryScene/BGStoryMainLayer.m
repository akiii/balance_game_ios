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
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // 文字を表示する
    titleName = @"むかしむかしあるところにそれはそれは\r\nファンキーなおじいさんとおばあさんが\n住んでおりました。ある日おじいさんは\nザギンでシースーに、おばあさんは渋谷の\nディスコで一晩中踊りに行きました。\nいつもは何人ものキャッチに声を\nかけられるおばあさんですが、\n今日はちょっと様子が違います。";
    
    // 文字数が多い場合 lineBreakMode で調整 (テクスチャサイズが大きくなる為)
    /*
     NSLog(@"titleName length %d", [titleName length]);
     title =  [CCLabelTTF labelWithString:titleName dimensions:CGSizeMake(1200,12) alignment:CCTextAlignmentLeft lineBreakMode:CCLineBreakModeTailTruncation fontName:@"Arial" fontSize:12];
     */
    
    scrollLabel =  [CCLabelTTF labelWithString:titleName fontName:@"Marker felt" fontSize:22];
    labelPositionY = 10;
    scrollLabel.anchorPoint = ccp(0.5, 1);
    scrollLabel.position = ccp(screenSize.width/2, labelPositionY);
    scrollLabel.color = ccc3(48, 0, 0);
    
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
    [self schedule:@selector(update:) interval:0.05];
    
    //----スキップボタン----
    
    CCMenuItemImage *startButton = [CCMenuItemImage itemWithNormalImage:@"skip_button.png" selectedImage:@"start_button.png" block:^(id sender){
        if (self.onPressedSkipButton) {
            self.onPressedSkipButton();
            //                [self removeChild:myMask cleanup:YES];
        }
    }];
    
    startButton.position = ccp(screenSize.width/2, 50);
    
    CCMenu *menu = [CCMenu menuWithItems:startButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    //----スキップボタンここまで----
 
}

- (void)update:(ccTime)dt {
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    // 文字の位置を移動する
    labelPositionY = labelPositionY + 1.5;
    
    if(labelPositionY > 340 + 100){
//        labelPositionY = 10;
        
        //タイトル画面へ遷移
        //self.onPressedSkipButton();
    }
    
    self.scrollLabel.position = ccp(screenSize.width/2, labelPositionY);

//    [myMask mask];
    
}


@end