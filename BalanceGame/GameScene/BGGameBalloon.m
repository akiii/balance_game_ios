//
//  BGGameBalloon.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGGameBalloon.h"

#define SPACE 3

@interface BGGameBalloon()
@property (nonatomic, retain) NSMutableArray *labels;
@end

@implementation BGGameBalloon
@synthesize labels;

+ (BGGameBalloon *)node{
    BGGameBalloon *balloon = [self spriteWithFile:@"balloon.png"];
    balloon.labels = [NSMutableArray array];
    balloon.visible = NO;
    return balloon;
}

- (void)showWithWords:(NSArray *)wordLabels{    
    for (CCLabelTTF *l in self.labels) {
        [self removeChild:l cleanup:YES];
    }
    self.labels = nil;
    
    CGPoint origin = CGPointMake(15, self.contentSize.height - 15);
    self.visible = YES;
    for (int i = 0; i < wordLabels.count; i++) {
        CCLabelTTF *l = [wordLabels objectAtIndex:i];
        l.position = ccp(origin.x + l.contentSize.width/2, origin.y - l.contentSize.height/2 - (l.contentSize.height + SPACE) * i);
        [self addChild:l];
        [self.labels addObject:l];
    }
}

- (void)notShow{
    self.visible = NO;
}

- (void)dealloc{
    self.labels = nil;
    [super dealloc];
}

@end
