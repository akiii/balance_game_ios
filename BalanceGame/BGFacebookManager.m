//
//  BGFacebookManager.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//
//

#import "BGFacebookManager.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

static BGFacebookManager *shared = nil;

@implementation BGFacebookManager
@synthesize currentUser, friends, setUsers;
@synthesize onGotUsersDictionary;

+ (BGFacebookManager *)sharedManager{
    if (!shared) {
        shared = [[self alloc] init];
    }
    return shared;
}

- (void)requestUsers{
    FBSession *session = ((AppController *)[UIApplication sharedApplication].delegate).session;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"name, picture", @"fields", nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    FBRequest *reqMe = [[FBRequest alloc] initWithSession:session graphPath:@"me" parameters:params HTTPMethod:@"GET"];
    FBRequest *reqFriends = [[FBRequest alloc] initWithSession:session graphPath:@"me/friends" parameters:params HTTPMethod:@"GET"];

    [reqMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [dic setObject:result forKey:@"me"];            
            [reqFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSArray *fs = [result objectForKey:@"data"];
                    [dic setObject:fs forKey:@"friends"];
                    
                    if (self.onGotUsersDictionary) self.onGotUsersDictionary(dic);
                    
                    dispatch_queue_t q = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(q, ^(){
                        for (NSDictionary *d in fs) {
                            BGFacebookUser *u = [[[BGFacebookUser alloc] init] autorelease];
                            u.userId = [d objectForKey:@"id"];
                            u.name = [d objectForKey:@"name"];
                            u.pictureUrl = [d objectForKey:@"picture"];
                        }
                        self.setUsers = YES;
                        if (self.onSetUsers) self.onSetUsers();
                    });
                }
                
                dispatch_queue_t q = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(q, ^(){
                    self.currentUser = [[[BGFacebookUser alloc] init] autorelease];
                    self.currentUser.userId = [result objectForKey:@"id"];
                    self.currentUser.name = [result objectForKey:@"name"];
                    self.currentUser.pictureUrl = [result objectForKey:@"picture"];
                });
            }];
        }
    }];
}

- (void)dealloc{
    shared = nil;
    [super dealloc];
}

@end
