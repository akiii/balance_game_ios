//
//  BGSelectUseFacebookMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGSelectUseFacebookMainLayer.h"


@implementation BGSelectUseFacebookMainLayer
@synthesize onPressedFacebookLoginButton, onPressedSkipButton;

- (void)onEnter{
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCMenuItemImage *loginButton = [CCMenuItemImage itemWithNormalImage:@"facebook_login_button.png" selectedImage:@"facebook_login_button.png" block:^(id sender){
        if (self.onPressedFacebookLoginButton) self.onPressedFacebookLoginButton();
    }];
    loginButton.position = ccp(screenSize.width/2, screenSize.height/2);
    
    CCMenuItemImage *skipButton = [CCMenuItemImage itemWithNormalImage:@"ok_button.png" selectedImage:@"ok_button.png" block:^(id sender){
        if (self.onPressedSkipButton) self.onPressedSkipButton();
    }];
    skipButton.position = ccp(screenSize.width/2, screenSize.height/4);
    
    CCMenu *menu = [CCMenu menuWithItems:loginButton, skipButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
}

@end
