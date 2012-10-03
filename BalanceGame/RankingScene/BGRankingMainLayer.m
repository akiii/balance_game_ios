//
//  BGRankingMainLayer.m
//  BalanceGame
//
//  Created by Akifumi on 2012/09/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BGRankingMainLayer.h"
#import "BGFacebookManager.h"
#import "CCUIViewWrapper.h"
#import "AFJsonReader.h"

#define SIZE_OF_NAVBAR  CGSizeMake([CCDirector sharedDirector].winSize.width, 48)

@interface BGRankingMainLayer()
@property (nonatomic, retain) CCUIViewWrapper *bar;
@property (nonatomic, retain) UITableView *uiTableView;
@property (nonatomic, retain) CCUIViewWrapper *tableView;
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
            self.scores = [jsonDic objectForKey:@"rankings"];
        }];
        self.name = n;
    }
    return self;
}

- (void)onEnter{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    UINavigationBar *uiBar = [[[UINavigationBar alloc] init] autorelease];
    UINavigationItem *title = [[[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ の Ranking", self.name]] autorelease];

    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(backButtonPressed:)] autorelease];
    title.leftBarButtonItem = backButton;
    
    [uiBar pushNavigationItem:title animated:YES];
    uiBar.frame = CGRectMake(0, 0, SIZE_OF_NAVBAR.width, SIZE_OF_NAVBAR.height);
    uiBar.tintColor = [UIColor blackColor];
    
    self.bar = [CCUIViewWrapper wrapperForUIView:uiBar];
    self.bar.position = ccp(SIZE_OF_NAVBAR.height/2 - screenSize.width/2, SIZE_OF_NAVBAR.width/2 + SIZE_OF_NAVBAR.height/2);
    self.bar.rotation = -90;
    [self addChild:self.bar];
    
    self.uiTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, SIZE_OF_NAVBAR.height, screenSize.width, screenSize.height - SIZE_OF_NAVBAR.height) style:UITableViewStylePlain] autorelease];
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    
    self.tableView = [CCUIViewWrapper wrapperForUIView:self.uiTableView];
    self.tableView.position = ccp(self.uiTableView.frame.size.height/2 - screenSize.width/2 + SIZE_OF_NAVBAR.height, self.uiTableView.frame.size.width/2 + self.uiTableView.frame.size.height/2 + SIZE_OF_NAVBAR.height);
    self.tableView.rotation = -90;
    [self addChild:self.tableView];
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
    UITableViewCell *cell = [self.uiTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
    self.uiTableView = nil;
    self.tableView = nil;
    self.scores = nil;
    [super dealloc];
}

- (void)backButtonPressed:(id)sender{
    [self removeChild:self.bar cleanup:YES];
    [self removeChild:self.tableView cleanup:YES];
    [[CCDirector sharedDirector] popScene];
}

@end