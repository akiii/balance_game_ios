//
//  BGGameResultLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/09/02.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameResultLayer.h"
#import "BGGameTower.h"
#import "BGFacebookManager.h"
#import "BGRFacebookUser.h"


@interface BGGameResultLayer()
@property (assign) BOOL success;
@property (nonatomic, retain) BGRFacebookUser *selectedUser;
@property (assign) int score, towerNumber;
@end

@implementation BGGameResultLayer
@synthesize success, selectedUser, score, towerNumber;
@synthesize onPressedRestartButton;

+ (BGGameResultLayer *)layerWithSuccess:(BOOL)suc score:(int)sc selectedUser:(BGRFacebookUser *)su towerNumber:(int)tn{
    return [[[self alloc] initWithSuccess:suc score:sc selectedUser:su towerNumber:tn] autorelease];
}

- (id)initWithSuccess:(BOOL)suc score:(int)sc selectedUser:(BGRFacebookUser *)su towerNumber:(int)tn{
    if (self = [super init]) {
        self.success = suc;
        self.score = sc;
        self.selectedUser = su;
        self.towerNumber = tn;
    }
    return self;
}

- (void)onEnter{
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *bg = [CCSprite spriteWithFile:@"result_background.png"];
    bg.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:bg];
    
    NSString *labelString;
    BGGameTower *tower;
    switch (self.towerNumber) {
        case 1:
            tower = [BGGameTower spriteWithFile:@"tokyo_tower.png"];
            labelString = @"東京タワー";
            break;
            
        case 2:
            tower = [BGGameTower spriteWithFile:@"tutenkaku_tower.png"];
            labelString = @"通天閣";
            break;
            
        case 3:
            tower = [BGGameTower spriteWithFile:@"pisa_tower.png"];
            labelString = @"ピサの斜塔";
            break;
            
        default:
            break;
    }
    tower.position = ccp(385, 188);
    [self addChild:tower];
    
    CCSprite *comment;
    if (self.success) {
        labelString = [NSString stringWithFormat:@"%@%@", labelString, @"を救いました！"];
        comment = [CCSprite spriteWithFile:@"congratulations.png"];
    }else {
        labelString = [NSString stringWithFormat:@"%@%@", labelString, @"を崩壊させました."];
        comment = [CCSprite spriteWithFile:@"gameover.png"];
    }
    CCLabelTTF *label = [CCLabelTTF labelWithString:labelString fontName:@"American Typewriter" fontSize:20];
    label.position = ccp(215, 225);
    [self addChild:label];
    
    comment.position = ccp(screenSize.width/2, 270);
    [self addChild:comment];
    
    float actionTime = 5.0;
    
    __block UIImageView *imageView;
    __block UIImageView *friendImageView;
    if ([BGFacebookManager sharedManager].currentUser != nil) {
        CCLabelTTF *myName = [CCLabelTTF labelWithString:[BGFacebookManager sharedManager].currentUser.name fontName:@"American Typewriter" fontSize:18];
        myName.position = ccp(51 + myName.contentSize.width/2, 95);
        [self addChild:myName];
                
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[BGFacebookManager sharedManager].currentUser.picture_url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
                imageView.frame = CGRectMake(54, 126, 76, 76);
                [[CCDirector sharedDirector].view addSubview:imageView];
                imageView.alpha = 0;
                [self fadeInImage:imageView time:actionTime];
            });
        });

        if (self.selectedUser != nil) {
            CCLabelTTF *friendName = [CCLabelTTF labelWithString:selectedUser.name fontName:@"American Typewriter" fontSize:18];
            friendName.position = ccp(222 + friendName.contentSize.width/2, 95);
            [self addChild:friendName];
            
            dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *friendImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selectedUser.picture_url]]];
                dispatch_async(dispatch_get_main_queue(), ^{                    
                    friendImageView = [[[UIImageView alloc] initWithImage:friendImage] autorelease];
                    friendImageView.frame = CGRectMake(225, 126, 76, 76);
                    [[CCDirector sharedDirector].view addSubview:friendImageView];
                    friendImageView.alpha = 0;
                    [self fadeInImage:friendImageView time:actionTime];
                });
            });
        }
    }
    
    CCSprite *heart;
    if (self.score < 30) {
        heart = [CCSprite spriteWithFile:@"heart0.png"];
    }else if (self.score < 80) {
        heart = [CCSprite spriteWithFile:@"heart50.png"];
    }else {
        heart = [CCSprite spriteWithFile:@"heart100.png"];
    }
    heart.position = ccp(175, 155);
    [self addChild:heart];
    
    CCLabelTTF *parcent = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d%%", self.score] fontName:@"American Typewriter" fontSize:24];
    parcent.color = ccc3(0, 0, 0);
    parcent.position = ccp(175, 112);
    [self addChild:parcent];
    
    CCMenuItemImage *retryButton = [CCMenuItemImage itemWithNormalImage:@"totop_button.png" selectedImage:@"totop_button.png" block:^(id sender) {
        if ([BGFacebookManager sharedManager].currentUser != nil) {
            [imageView removeFromSuperview];
            if (self.selectedUser != nil) {
                [friendImageView removeFromSuperview];
            }
        }
        if (self.onPressedRestartButton) self.onPressedRestartButton();
    }];
    retryButton.position = ccp(screenSize.width/2, 60);
    
    CCMenu *menu = [CCMenu menuWithItems:retryButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    for (CCSprite *s in self.children) {
        s.opacity = 0;
        [s runAction:[CCFadeIn actionWithDuration:actionTime]];
    }
}

- (void)fadeInImage:(UIImageView *)iv time:(float)time{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:time];
    iv.alpha = 1.0;
    [UIView commitAnimations];
    
}
- (void)dealloc {
    self.selectedUser = nil;
    [super dealloc];
}

@end
