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
- (void)requestUsers;
@end
