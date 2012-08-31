//
//  BGStoryMainLayer.h
//  BalanceGame
//
//  Created by  on 12/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMask.h"

@interface BGStoryMainLayer : CCLayer {

    
}

@property (nonatomic, copy) void (^onPressedSkipButton)();
@property (nonatomic, retain) CCLabelTTF *scrollLabel;
@property (nonatomic, retain) CCMask *myMask;
@property (nonatomic, retain) NSString *titleName;

@end