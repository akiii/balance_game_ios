//
//  BGStoryMainLayer.h
//  BalanceGame
//
//  Created by  on 12/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BGStoryMainLayer : CCSprite {
    // Some screen information
    CGSize size;
    CGPoint screenMid;
    
    // The given sprites
    CCSprite *maskSprite;
    CCSprite *objectSprite;
    
    // RenderTextures use for masking
    CCRenderTexture *maskNegative;
    CCRenderTexture *masked;
}

// Initialize a masked object based on an object sprite and a mask sprite
+ (id) createMaskForObject: (CCSprite *) object withMask: (CCSprite *) mask;

// Redraw the masked image
- (void) redrawMasked;

// When dynamic masking is active, you have the ability to change the masked object or the mask itself
- (void) setObject: (CCSprite *) object;
- (void) setMask: (CCSprite *) mask;

// Return the masked object as a sprite
- (CCSprite *) getMaskedSprite;

@end