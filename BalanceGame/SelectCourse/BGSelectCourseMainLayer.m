//
//  BGSelectCourseMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGSelectCourseMainLayer.h"

#define SPACE 30

@implementation BGSelectCourseMainLayer
@synthesize courseBGImage;
@synthesize onPressedButton;


/*
- (void)onEnter{
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //背景ここから
    
    self.courseBG = [CCSprite spriteWithFile:@"course_bg.png"];
    self.courseBG.position = ccp(screenSize.width/2, screenSize.height/2);
    
    [self addChild:self.courseBG];
    
    //背景ここまで
}
*/

- (id)init{
    if (self = [super init]) {
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //背景ここから
        
        courseBGImage = [CCSprite spriteWithFile:@"course_bg.png"];
        self.courseBGImage.position = ccp(screenSize.width/2, screenSize.height/2);
        
        [self addChild:self.courseBGImage];
        
        //背景ここまで
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"ロケーションをせんたくしてね" fontName:@"American Typewriter" fontSize:22];
        title.position = ccp(screenSize.width/2, screenSize.height - SPACE - title.contentSize.height/2);
        [self addChild:title];
        
        CCMenuItemImage *tokyoButton = [CCMenuItemImage itemWithNormalImage:@"tokyo_button.png" selectedImage:@"tokyo_button.png" block:^(id sender){
            BGGameTower *tower = [BGGameTower spriteWithFile:@"tokyo_tower.png"];
            tower.number = 1;
            if (self.onPressedButton) self.onPressedButton(tower);
        }];
        tokyoButton.position = ccp(SPACE + tokyoButton.contentSize.width/2, title.position.y - title.contentSize.height/2 - SPACE - tokyoButton.contentSize.height/2);
        
        CCMenuItemImage *tokyoPictureButton = [CCMenuItemImage itemWithNormalImage:@"tokyo_tower_picture.png" selectedImage:@"tokyo_tower_picture.png" block:^(id sender){
            BGGameTower *tower = [BGGameTower spriteWithFile:@"tokyo_tower.png"];
            tower.number = 1;
            if (self.onPressedButton) self.onPressedButton(tower);        }];
        tokyoPictureButton.position = ccp(tokyoButton.position.x, tokyoButton.position.y - tokyoButton.contentSize.height/2 - SPACE - tokyoPictureButton.contentSize.height/2);
        
        CCMenuItemImage *osakaButton = [CCMenuItemImage itemWithNormalImage:@"osaka_button.png" selectedImage:@"osaka_button.png" block:^(id sender){
            BGGameTower *tower = [BGGameTower spriteWithFile:@"tutenkaku_tower.png"];
            tower.number = 2;
            if (self.onPressedButton) self.onPressedButton(tower);
        }];
        osakaButton.position = ccp(tokyoButton.position.x + tokyoButton.contentSize.width/2 + SPACE + osakaButton.contentSize.width/2, tokyoButton.position.y);
        
        CCMenuItemImage *osakaPictureButton = [CCMenuItemImage itemWithNormalImage:@"tutenkaku_tower_picture.png" selectedImage:@"tutenkaku_tower_picture.png" block:^(id sender){
            BGGameTower *tower = [BGGameTower spriteWithFile:@"tutenkaku_tower.png"];
            tower.number = 2;
            if (self.onPressedButton) self.onPressedButton(tower);
        }];
        osakaPictureButton.position = ccp(osakaButton.position.x, osakaButton.position.y - osakaButton.contentSize.height/2 - SPACE - osakaPictureButton.contentSize.height/2);
        
        CCMenuItemImage *italyButton = [CCMenuItemImage itemWithNormalImage:@"italy_button.png" selectedImage:@"italy_button.png" block:^(id sender){
            BGGameTower *tower = [BGGameTower spriteWithFile:@"pisa_tower.png"];
            tower.number = 3;
            if (self.onPressedButton) self.onPressedButton(tower);
        }];
        italyButton.position = ccp(osakaButton.position.x + osakaButton.contentSize.width/2 + SPACE + italyButton.contentSize.width/2, tokyoButton.position.y);
        
        CCMenuItemImage *italyPictureButton = [CCMenuItemImage itemWithNormalImage:@"pisa_tower_picture.png" selectedImage:@"pisa_tower_picture.png" block:^(id sender){
            BGGameTower *tower = [BGGameTower spriteWithFile:@"pisa_tower.png"];
            tower.number = 3;
            if (self.onPressedButton) self.onPressedButton(tower);
        }];
        italyPictureButton.position = ccp(italyButton.position.x, italyButton.position.y - italyButton.contentSize.height/2 - SPACE - italyPictureButton.contentSize.height/2);

        CCMenu *menu = [CCMenu menuWithItems:tokyoButton, tokyoPictureButton, osakaButton, osakaPictureButton, italyButton, italyPictureButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
    }
    return self;
}

@end
