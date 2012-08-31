//
//  BGStoryMainLayer.m
//  BalanceGame
//
//  Created by  on 12/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

//
//  CCMask.h
//  Masking
//
//  Created by Gilles Lesire on 22/04/11.
//  Copyright 2011 iCapps. All rights reserved.
//

#import "cocos2d.h"
#import "BGStoryMainLayer.h"

@interface BGStoryMainLayer(Private)

- (id) initWithObject: (CCSprite *) object mask: (CCSprite *) mask;
- (void) resetObject;
- (void) mask;

@end

@implementation BGStoryMainLayer

+ (id) createMaskForObject: (CCSprite *) object withMask: (CCSprite *) mask {
	return [[[self alloc] initWithObject: object mask: mask] autorelease];
}

- (id) initWithObject: (CCSprite *) object mask: (CCSprite *) mask {
	NSAssert(object != nil, @"Invalid sprite for object");
    NSAssert(mask != nil, @"Invalid sprite for mask");
    
	if((self = [super init])) {
		[self setObject: object];
		[self setMask: mask];
        
        // Get window size, we want masking over entire screen don't we?
		size = [[CCDirector sharedDirector] winSize];
        
        // Create point with middle of screen
        screenMid = ccp(size.width * 0.5f, size.height * 0.5f);
        
        // Create the rendureTextures to create cut outs
        maskNegative = [CCRenderTexture renderTextureWithWidth: size.width height: size.height];
        masked = [CCRenderTexture renderTextureWithWidth: size.width height: size.height];
        
        // Set render textures at middle of screen
        maskNegative.position = screenMid;
        masked.position = screenMid;
        
        // Set correct alpha channel for textures
        [[maskNegative sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
        [[masked sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
        
        // Load object into RenderTextures
        [self resetObject];
        
        // Mask the object
        [self mask];
        
        // Add the masked object to the screen
        [self addChild: masked];
	}
    
	return self;
}

- (void) resetObject {
    // Clear textures first
    [maskNegative clear:0 g:0 b:0 a:1.0];
    [masked clear:0 g:0 b:0 a:1.0];
    
    // Begin action for cut out
    [maskNegative begin];
    
    // Load sprite
    [objectSprite visit];
    
    // End loading sprites
    [maskNegative end];
    
    // Begin action for masked
    [masked begin];
    
    // Load sprite
    [objectSprite visit];
    
    // End loading sprites
    [masked end];
}

- (void) redrawMasked {
    // Put object back on the screen
    [self resetObject];
    
    // Cut out the parts we don't want to see
    [self mask];
}

- (void) mask {
    // Set up the burn sprite that will "knock out" parts of the darkness layer depending on the alpha value of the pixels in the image.
    [maskSprite setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [maskSprite retain];
    
    // Start cutting out the parts we want to show
    [maskNegative begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw
    [maskSprite visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [maskNegative end];
    
    [self addChild: maskNegative];
    
    // Create a temporary mask of the left cut out
    CCSprite *maskCut = maskNegative.sprite;
    maskCut.position = screenMid;
    
    // Set up the burn sprite that will "knock out" parts of the darkness layer depending on the alpha value of the pixels in the image.
    [maskCut setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
    [maskCut retain];
    
    [masked begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw
    [maskCut visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [masked end];
}

- (void) setObject: (CCSprite *) object {
    objectSprite = object;
}

- (void) setMask: (CCSprite *) mask {
    maskSprite = mask;
}

- (CCSprite *) getMaskedSprite {
    return masked.sprite;
}

- (void) dealloc {
    [super dealloc];
}

@end