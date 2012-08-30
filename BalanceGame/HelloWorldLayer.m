//
//  HelloWorldLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/23.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCCallBlock actionWithBlock:^(){
            CCParticleMeteor *meteor = [CCParticleMeteor node];
            meteor.position = ccp(size.width/2, 0);
            meteor.gravity = ccp(0, -size.height);
            meteor.startSize = 1.0;
            meteor.endSizeVar = -10.0;
            meteor.emissionRate = 100.0;
            meteor.radialAccel = -300.0;
            meteor.life = 0.0001;
            meteor.duration = 1.3;
            meteor.startColor = ccc4f(255, 102, 51, 255);
            [self addChild:meteor];
            
            [meteor runAction:[CCMoveBy actionWithDuration:1.5 position:ccp(0, 100)]];
        }], [CCDelayTime actionWithDuration:1.5 + 0.8], [CCCallBlock actionWithBlock:^(){
            CCParticleSystemQuad *fire = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
            fire.position = ccp(size.width/2, 120);
            [self addChild:fire];
            fire.gravity = ccp(0, 0);
            fire.scale = 0.15;
            fire.duration = 0.06;
        }], [CCDelayTime actionWithDuration:0.2], [CCCallBlock actionWithBlock:^(){
            CCParticleSystemQuad *fire = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
            fire.position = ccp(size.width/2, 120);
            [self addChild:fire];
            fire.gravity = ccp(0, 0);
            fire.scale = 0.13;
            fire.duration = 0.04;
        }], [CCDelayTime actionWithDuration:0.2], [CCCallBlock actionWithBlock:^(){
            CCParticleSystemQuad *fire = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
            fire.position = ccp(size.width/2, 120);
            [self addChild:fire];
            fire.gravity = ccp(0, 0);
            fire.scale = 0.10;
            fire.duration = 0.03;
        }], [CCDelayTime actionWithDuration:0.2], nil]]];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
