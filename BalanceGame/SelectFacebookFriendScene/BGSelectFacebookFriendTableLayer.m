//
//  BGSelectFacebookFriendTableLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/08/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGSelectFacebookFriendTableLayer.h"
#import "BGFacebookManager.h"

@interface BGSelectFacebookFriendTableLayer()
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation BGSelectFacebookFriendTableLayer
@synthesize tableView;
@synthesize onPressedFacebookFriend;

- (void)onEnter{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[CCDirector sharedDirector].view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cellCount;
    if ([BGFacebookManager sharedManager].setUsers) {
        cellCount = [BGFacebookManager sharedManager].friends.count;
    }else {
        cellCount = ((NSArray *)[[BGFacebookManager sharedManager].usersDictionary objectForKey:kFriends]).count;
    }
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(!cell){
        cell = [[[UITableViewCell alloc] init] autorelease];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    NSString *imageUrl;
    if ([BGFacebookManager sharedManager].setUsers) {
        BGRFacebookUser *friend = [[BGFacebookManager sharedManager].friends objectAtIndex:indexPath.row];
        cell.textLabel.text = friend.name;
        imageUrl = friend.picture_url;
    }else {
        NSDictionary *friendDic = [((NSArray *)[[BGFacebookManager sharedManager].usersDictionary objectForKey:kFriends]) objectAtIndex:indexPath.row];
        cell.textLabel.text = [friendDic objectForKey:@"name"];
        imageUrl = [friendDic objectForKey:@"picture"];
    }
    
//    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_global = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    
    cell.imageView.image = nil;
    
    dispatch_async(q_global, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageUrl]]];
        dispatch_async(q_main, ^{
            cell.imageView.image = image;
            [cell layoutSubviews];
        });
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView removeFromSuperview];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.onPressedFacebookFriend) self.onPressedFacebookFriend([[BGFacebookManager sharedManager].friends objectAtIndex:indexPath.row]);
    });    
}

- (void)dealloc{
    self.tableView = nil;
    [super dealloc];
}

@end
