//
//  BGFacebookManager.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/30.
//
//

#import "BGFacebookManager.h"
#import "AppDelegate.h"

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
                self.currentUser = [[[BGRFacebookUser alloc] init] autorelease];
                self.currentUser.uid = [result objectForKey:@"id"];
                self.currentUser.name = [result objectForKey:@"name"];
                self.currentUser.picture_url = [result objectForKey:@"picture"];
                [self.currentUser remoteCreateAsync:^(NSError *error) {}];
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
                            BGRFacebookUser *u = [[[BGRFacebookUser alloc] init] autorelease];
                            u.uid = [d objectForKey:@"id"];
                            u.name = [d objectForKey:@"name"];
                            u.picture_url = [d objectForKey:@"picture"];
                            [self.friends addObject:u];
                            
                            if ([[fs objectAtIndex:fs.count-1] isEqual:d]) {
                                self.setUsers = YES;
                                if (self.onSetUsers) self.onSetUsers();
                            }
                            
                            [u remoteCreateAsync:^(NSError *error) {}];
                        }
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
