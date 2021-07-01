//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "Tweet.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"

//ComposeViewControllerDelegate,
@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (nonatomic) int nmbrTweets;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (self.arrayOfTweets.count == 0){
        self.nmbrTweets = 20;
    }
    
    [self loadTweets];

    
    // Refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loadTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:self.nmbrTweets :^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎 Successfully loaded home timeline");
            // self.arrayOfTweets = [Tweet tweetsWithArray:tweets];
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            self.nmbrTweets = (int) self.arrayOfTweets.count;

            [self.tableView reloadData];
//            for (NSDictionary *dictionary in tweets) {
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//           }
        } else {
            NSLog(@"😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

// Log Out
- (IBAction)onTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

// Segue to profile
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


// Add own tweet to timeline
- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

// Infinite Scroll
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row + 1 == self.arrayOfTweets.count){
        self.nmbrTweets += 20;
        [self loadTweets];
    }
}

// Number of Cells
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// Cell Contents
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.delegate = self;
    cell.tweetLabel.text = tweet.text;
    cell.userLabel.text = tweet.user.name;
    cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.timeLabel.text = tweet.timeAgo;
    
    // Like button
    [cell.likeButton setTitle:[NSString stringWithFormat:@"%i",tweet.favoriteCount] forState: UIControlStateNormal];
    if (cell.tweet.favorited == YES) {
        [cell.likeButton setSelected:YES];
    }
    else{
        [cell.likeButton setSelected:NO];
    }
    
    // Retweet button
    [cell.retweetButton setTitle:[NSString stringWithFormat:@"%i",tweet.retweetCount] forState: UIControlStateNormal];
    if (cell.tweet.retweeted == YES) {
        [cell.retweetButton setSelected:YES];
    }
    else{
        [cell.retweetButton setSelected:NO];
    }
    
    // Not showing because only for premium :'(
    [cell.replyButton setTitle:[NSString stringWithFormat:@"%i",tweet.replyCount] forState: UIControlStateNormal];
    // Get pfp
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    // ? NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.userView.image = nil;
    [cell.userView setImageWithURL:url];
    cell.userView.layer.cornerRadius = cell.userView.frame.size.width / 2;;
    cell.userView.layer.masksToBounds = YES;

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"composeSeque"]) {
        UINavigationController *navigationController = [segue destinationViewController];
            ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
            composeController.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
    if ([[segue identifier] isEqualToString:@"profileSegue"]) {
        User *user = sender;
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
}




@end
