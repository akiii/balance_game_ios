//
//  BGFacebookManager.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//
//

#import "BGFacebookManager.h"
#import "AppDelegate.h"

#import "BGRFacebookUser.h"

static BGFacebookManager *shared = nil;

@implementation BGFacebookManager
@synthesize currentUser, friends, usersDictionary, setUsers;
@synthesize onGotUsersDictionary, onSetUsers;

+ (BGFacebookManager *)sharedManager{
    if (!shared) {
        shared = [[self alloc] init];
    }
    return shared;
}

- (void)requestUsers{
    FBSession *session = ((AppController *)[UIApplication sharedApplication].delegate).session;

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"name, picture", @"fields", nil];
    
    self.usersDictionary = [NSMutableDictionary dictionary];

    FBRequest *reqMe = [[FBRequest alloc] initWithSession:session graphPath:@"me" parameters:params HTTPMethod:@"GET"];
    FBRequest *reqFriends = [[FBRequest alloc] initWithSession:session graphPath:@"me/friends" parameters:params HTTPMethod:@"GET"];

    [reqMe startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self.usersDictionary setObject:result forKey:kMe];
            
            dispatch_queue_t q = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(q, ^(){
                self.currentUser = [[[BGFacebookUser alloc] init] autorelease];
                self.currentUser.userId = [result objectForKey:@"id"];
                self.currentUser.name = [result objectForKey:@"name"];
                self.currentUser.pictureUrl = [result objectForKey:@"picture"];
                
                BGRFacebookUser *fu = [[[BGRFacebookUser alloc] init] autorelease];
                fu.uid = [result objectForKey:@"id"];
                fu.name = [result objectForKey:@"name"];
                fu.picture_url = [result objectForKey:@"picture"];
                [fu remoteCreateAsync:^(NSError *error) {}];
            });
            
            [reqFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSArray *fs = [result objectForKey:@"data"];
                    [self.usersDictionary setObject:fs forKey:kFriends];
                    
                    if (self.onGotUsersDictionary) self.onGotUsersDictionary();
                    
                    self.friends = [NSMutableArray array];
                    
                    dispatch_queue_t q = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(q, ^(){
                        for (NSDictionary *d in fs) {
                            BGFacebookUser *u = [[[BGFacebookUser alloc] init] autorelease];
                            u.userId = [d objectForKey:@"id"];
                            u.name = [d objectForKey:@"name"];
                            u.pictureUrl = [d objectForKey:@"picture"];
                            [self.friends addObject:u];
                            
                            BGRFacebookUser *fu = [[[BGRFacebookUser alloc] init] autorelease];
                            fu.uid = [d objectForKey:@"id"];
                            fu.name = [d objectForKey:@"name"];
                            fu.picture_url = [d objectForKey:@"picture"];
                            [fu remoteCreateAsync:^(NSError *error) {}];
                        }
                        self.setUsers = YES;
                        if (self.onSetUsers) self.onSetUsers();
                    });
                }
            }];
        }
    }];
}

- (void)postWall{
    NSLog(@"post wall method");

//    FBSession *session = ((AppController *)[UIApplication sharedApplication].delegate).session;
    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"name, picture", @"fields", nil];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"test post to wall", @"message", nil];
//    NSLog(@"activate session : %@", [FBSession activeSession]);
//    
//    FBRequest *req = [FBRequest requestWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"];
//    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            NSLog(@"success");
//        }
//    }];
    
//    UIImage *img = [UIImage imageNamed:@"Default.png"];
//    [FBRequestConnection startForUploadPhoto:img completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            NSLog(@"success");
//        }else {
//            NSLog(@"error : %@", error);
//        }
//    }];
    FBRequest *req = [FBRequest requestWithGraphPath:@"feed" parameters:params HTTPMethod:@"POST"];
    [req startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"res : %@", result);
    }];
}

- (void)dealloc{
    shared = nil;
    [super dealloc];
}

@end
