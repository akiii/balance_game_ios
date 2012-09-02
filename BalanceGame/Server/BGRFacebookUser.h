//
//  BGRFacebookUser.h
//  BalanceGame
//
//  Created by Akifumi on 2012/09/02.
//
//

#import <Foundation/Foundation.h>
#import "NSRails.h"

@interface BGRFacebookUser : NSRRemoteObject
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *picture_url;
@end
