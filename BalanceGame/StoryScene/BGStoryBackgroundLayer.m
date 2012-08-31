//
//  BGStoryBackgroundLayer.m
//  BalanceGame
//
//  Created by  on 12/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGStoryBackgroundLayer.h"


@implementation BGStoryBackgroundLayer
@synthesize storyBGImage;

-(void)onEnter {
    [super onEnter];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.storyBGImage = [CCSprite spriteWithFile:@"StoryBackground.png"];
    self.storyBGImage.position = ccp(screenSize.width/2, screenSize.height/2);
    
    [self addChild:self.storyBGImage];
}

@end
