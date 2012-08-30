//
//  AppDelegate.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) FBSession *session;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
