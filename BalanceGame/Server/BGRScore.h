//
//  BGRScore.h
//  BalanceGame
//
//  Created by Akifumi on 2012/09/02.
//
//

#import <Foundation/Foundation.h>
#import "NSRails.h"

@interface BGRScore : NSRRemoteObject
@property (assign) int first_user_id;
@property (assign) int second_user_id;
@property (assign) int value;
@end
