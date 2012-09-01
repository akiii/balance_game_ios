//
//  BGFacebookManager.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BGFacebookUser.h"

#define kMe         @"me"
#define kFriends    @"friends"

@interface BGFacebookManager : NSObject
+ (BGFacebookManager *)sharedManager;
@property (nonatomic, retain) BGFacebookUser *currentUser;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) NSMutableDictionary *usersDictionary;
@property (assign) BOOL setUsers;
@property (nonatomic, copy) void (^onGotUsersDictionary)();
@property (nonatomic, copy) void (^onSetUsers)();
- (void)requestUsers;
- (void)postWall;
@end
