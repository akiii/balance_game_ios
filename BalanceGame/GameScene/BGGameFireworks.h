//
//  BGGameFireworks.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BGGameFireworks : CCNode {
    
}
@property (nonatomic, copy) void (^onFinished)();
- (void)shotWithColor:(ccColor4F)color;
@end
