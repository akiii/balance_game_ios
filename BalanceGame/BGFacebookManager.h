//
//  BGFacebookManager.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//
//

#import <Foundation/Foundation.h>
#import "BGFacebookUser.h"

@interface BGFacebookManager : NSObject
+ (BGFacebookManager *)sharedManager;
@property (nonatomic, retain) BGFacebookUser *currentUser;
@property (nonatomic, retain) NSMutableArray *friends;
@property (assign) BOOL setUsers;
@property (nonatomic, copy) void (^onGotUsersDictionary)(NSDictionary *dic);
@property (nonatomic, copy) void (^onSetUsers)();
- (void)requestUsers;
@end
