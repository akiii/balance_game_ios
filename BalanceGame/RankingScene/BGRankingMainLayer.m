//
//  BGRankingMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/09/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGRankingMainLayer.h"
#import "BGFacebookManager.h"
#import "AFJsonReader.h"

@interface BGRankingMainLayer()
@property (nonatomic, retain) UINavigationBar *bar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *scores;
@property (nonatomic, retain) NSString *name;
@end

@implementation BGRankingMainLayer
@synthesize bar, tableView, scores, onPressedFacebookUser, name;

+ (BGRankingMainLayer *)layerWithFacebookId:(NSString *)facebookId name:(NSString *)n{
    return [[[self alloc] initWithFacebookId:facebookId name:n] autorelease];
}

- (id)initWithFacebookId:(NSString *)facebookId name:(NSString *)n{
    if (self = [super init]) {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", @"http://akiiisuke.com:3010/scores/ranking", facebookId];
        [AFJsonReader requestWithUrl:urlString block:^(NSDictionary *jsonDic){
            NSLog(@"json dic : %@", jsonDic);
            self.scores = [jsonDic objectForKey:@"rankings"];
        }];
        self.name = n;
    }
    return self;
}

- (void)onEnter{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.bar = [[[UINavigationBar alloc] init] autorelease];
    UINavigationItem *title = [[[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ の Ranking", self.name]] autorelease];

    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(backButtonPressed:)] autorelease];
    title.leftBarButtonItem = backButton;
    
    [self.bar pushNavigationItem:title animated:YES];
    self.bar.frame = CGRectMake(0, 0, screenSize.width, 48);
    self.bar.tintColor = [UIColor blackColor];
    [[CCDirector sharedDirector].view addSubview:self.bar];    
        
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 48, screenSize.width, screenSize.height - 48) style:UITableViewStylePlain] autorelease];
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
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 43;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(!cell){
        cell = [[[UITableViewCell alloc] init] autorelease];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    NSDictionary *dic = [self.scores objectAtIndex:indexPath.row];
    NSString *imageUrl = [dic objectForKey:@"picture_url"];
    
    UILabel *rankNum = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, height, height)] autorelease];
    rankNum.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    [cell addSubview:rankNum];
    
    UILabel *scoreNum = [[[UILabel alloc] initWithFrame:CGRectMake(screenSize.width - height, 0, height, height)] autorelease];
    scoreNum.text = [NSString stringWithFormat:@"%@%%", [dic objectForKey:@"value"]];
    [cell addSubview:scoreNum];
    
    UILabel *nameLabl = [[[UILabel alloc] initWithFrame:CGRectMake(height * 2, 0, screenSize.width - height * 3, height)] autorelease];
    nameLabl.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    [cell addSubview:nameLabl];

    dispatch_queue_t q_global = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    
    cell.imageView.image = nil;
    
    dispatch_async(q_global, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]]];
        dispatch_async(q_main, ^{
            UIImageView *iv = [[[UIImageView alloc] initWithImage:image] autorelease];
            iv.frame = CGRectMake(height, 0, height, height);
            [cell addSubview:iv];
            [cell layoutSubviews];
        });
    });
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.onPressedFacebookUser) self.onPressedFacebookUser([[self.scores objectAtIndex:indexPath.row] objectForKey:@"uid"], [[self.scores objectAtIndex:indexPath.row] objectForKey:@"name"]);
}

- (void)dealloc{
    self.bar = nil;
    self.tableView = nil;
    self.scores = nil;
    [super dealloc];
}

- (void)backButtonPressed:(id)sender{
    [self.bar removeFromSuperview];
    [self.tableView removeFromSuperview];
    [[CCDirector sharedDirector] popScene];
}

@end