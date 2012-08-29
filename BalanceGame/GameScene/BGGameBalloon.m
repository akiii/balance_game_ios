//
//  BGGameBalloon.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameBalloon.h"

#define SPACE 3

@interface BGGameBalloon()
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) CCMenu *menu;
@end

@implementation BGGameBalloon
@synthesize labels, menu;
@synthesize onOkButtonPressed;

+ (BGGameBalloon *)node{
    BGGameBalloon *balloon = [self spriteWithFile:@"balloon.png"];
    balloon.labels = [NSMutableArray array];
    balloon.visible = NO;
    
    CCMenuItemImage *okButton = [CCMenuItemImage itemWithNormalImage:@"ok_button.png" selectedImage:@"ok_button.png" block:^(id sender){
        if (balloon.onOkButtonPressed) balloon.onOkButtonPressed();
    }];
    okButton.position = ccp(balloon.contentSize.width/2, -5);
    
    balloon.menu = [CCMenu menuWithItems:okButton, nil];
    balloon.menu.position = ccp(0, 0);
    [balloon addChild:balloon.menu];
    
    return balloon;
}

- (void)showWithWords:(NSArray *)wordLabels imagesAnimationFrame:(NSArray *)frame{
    for (CCLabelTTF *l in self.labels) {
        [self removeChild:l cleanup:YES];
    }
    [self.labels removeAllObjects];
    
    CGPoint origin = CGPointMake(15, self.contentSize.height - 15);
    self.visible = YES;
    for (int i = 0; i < wordLabels.count; i++) {
        CCLabelTTF *l = [wordLabels objectAtIndex:i];
        l.position = ccp(origin.x + l.contentSize.width/2, origin.y - l.contentSize.height/2 - (l.contentSize.height + SPACE) * i);
        [self addChild:l];
        [self.labels addObject:l];
    }
    
    CCSprite *image = [CCSprite node];
    image.position = ccp(self.contentSize.width/2, 100);
    [self addChild:image];
    
    [image runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:frame delay:0.8]], nil]]];
}

- (void)notShow{
    self.visible = NO;
}

- (void)dealloc{
    self.labels = nil;
    [super dealloc];
}

@end
