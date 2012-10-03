//
//  CCUIViewWrapper.h
//  BalanceGame
//
//  Created by Akifumi on 2012/10/04.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite
{
	UIView *uiItem;
	float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end
