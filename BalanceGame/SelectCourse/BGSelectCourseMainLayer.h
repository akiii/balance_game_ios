//
//  BGSelectCourseMainLayer.h
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGGameTower.h"

@interface BGSelectCourseMainLayer : CCLayer {
    
}
@property (nonatomic, copy) void (^onPressedButton)(BGGameTower *tower);
@end
