//
//  CCMask.m
//
//  Created by araker on 8/3/11.
//  MIT LICENSE
//

/*
 http://www.cocos2d-iphone.org/forum/topic/15890
 Example usage
 CCSprite *mask = [CCsprite .. ];
 [mask setPosition:ccp(30.f,50.f)];
 CCMask *myMask = [CCMask createMaskForObject:myLayer withMask:mask];
 [self addChild:myMask];
 [myMask mask];
 
 //mask a new object
 [myMask setObject:newObject];
 [myMask setMask:newMask];
 [myMask maskWithoutClear];
 //myMask now contains 2 masked objects
 scratch-off effect
 CCSprite *mask = [CCSprite .. ];
 [mask setPosition:ccp(30.f,50.f)];
 CCMask *myMask = [CCMask createMaskForObject:myLayer withMask:mask];
 [self addChild:myMask];
 [myMask mask];
 
 //in a update/event
 [[myMask maskSprite] setPosition:ccp(60,60)];
 [myMask reDrawMask];
 */

#import "CCMask.h"

@implementation CCMask

@synthesize clippingRegion;
@synthesize masked = masked_;

+ (id) createMaskForObject: (CCNode *) object withMask: (CCSprite *) mask {
	return [[[self alloc] initWithObject: object mask: mask] autorelease];
}

- (id) initWithObject: (CCNode *) object mask: (CCSprite *) mask {
	NSAssert(object != nil, @"Invalid sprite for object");
    NSAssert(mask != nil, @"Invalid sprite for mask");
    
	if((self = [super init])) {
		objectSprite_ = [object retain];
        
		maskSprite_ = [mask retain]; 
        
		// Set up the burn sprite that will "knock out" parts of the darkness layer depending on the alpha value of the pixels in the image.
		[maskSprite_ setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
        
        // Get window size, we want masking over entire screen don't we?
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Create point with middle of screen
        CGPoint screenMid = ccp(size.width * 0.5f, size.height * 0.5f);
        
        // Create the rendureTextures for the mask
        masked_ = [[CCRenderTexture renderTextureWithWidth: size.width height: size.height] retain];
        
		[[masked_ sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
        
		// Set render textures at middle of screen
        masked_.position = screenMid;
        
        // Add the masked object to the screen
        [self addChild: masked_];
        
        NSLog(@"maskSprite_.textureRect.size.width %f", maskSprite_.textureRect.size.width);
//        NSLog(@"maskSprite_.contentSizeInPixels.width %f", maskSprite_.contentSizeInPixels.width);
        
        //        /NSLog(@"objectSprite_.textureRect.size.width %f", objectSprite_.textureRect.size.width);
//        NSLog(@"objectSprite_.contentSizeInPixels.width %f", objectSprite_.contentSizeInPixels.width);
	}
    
	return self;
}

- (void) mask
{
	[self maskWithClear:0.0f g:0.0f b:0.0f a:0.0f];
}



- (void) maskWithClear:(float) r g:(float) g b:(float) b a:(float) a {
    
    [masked_ beginWithClear:r g:g b:b a:a];

	// Limit drawing to the alpha channel
    
    
    glEnable(GL_SCISSOR_TEST);
    
    
    
	[objectSprite_ visit];
    
	glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw mask
    [maskSprite_ visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [masked_ end];
}

- (void) maskWithoutClear
{
	[masked_ begin];	
    
	[objectSprite_ visit];
	// Limit drawing to the alpha channel
	glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw mask
    [maskSprite_ visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [masked_ end];
}

- (void) reDrawMask
{
	//presume object is already drawed in a previous frame 
    
	[masked_ begin];
	// Limit drawing to the alpha channel
    
	glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw mask
    [maskSprite_ visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [masked_ end];
    
}

- (void) setObject: (CCSprite *) object {
	[objectSprite_ release];
	objectSprite_ = [object retain];
}

- (void) setMask: (CCSprite *) mask {
	[maskSprite_ release];
	maskSprite_ = [mask retain];
	[maskSprite_ setBlendFunc: (ccBlendFunc) { GL_ZERO, GL_ONE_MINUS_SRC_ALPHA }];
}

- (CCSprite*) maskSprite
{
	return maskSprite_;
}

- (void) dealloc {
    
    [masked_ release];
	[maskSprite_ release];
	[objectSprite_ release];
    
    [super dealloc];
}

@end