//
//  ProfileViewController.m
//  twitter
//
//  Created by Josey Zhang on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "pfpCell.h"
#import "userTweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self loadTweets];
    
    [self.tableView reloadData];

}

- (void)loadTweets {
    [[APIManager shared] getUserTimelineWithCompletion:self.user.screenName :^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];

        } else {
            NSLog(@"😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

// Adds K and m for thousands and millions
-(NSString*)convertNumber:(NSNumber*)number{
    long long num = [number longLongValue];
    
    if (num < 1000){
        return [NSString stringWithFormat:@"%i", (int)num];
    }
    else if (num < pow(10, 6)){
        double thousand = num / 1000.;
        return [NSString stringWithFormat:@"%.1fK", thousand];
    }
    else {
        double million = num / 1000000.;
        return [NSString stringWithFormat:@"%.1fm", million];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        pfpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pfpCell"];
        cell.createdLabel.text = [@"Joined: " stringByAppendingString:self.user.created];
        cell.userLabel.text = self.user.name;
        cell.handleLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
        cell.followerLabel.text = [[self convertNumber:[NSNumber numberWithInt:self.user.followers]] stringByAppendingString:@" Followers"];
        cell.followingLabel.text = [[self convertNumber:[NSNumber numberWithInt:self.user.following]] stringByAppendingString:@" Following"];
        cell.tweetsLabel.text = [[self convertNumber:[NSNumber numberWithInt:self.user.tweets]] stringByAppendingString:@" Tweets"];
        NSString *backdropURLString = self.user.backgroundImage;
        NSURL *backdropurl = [NSURL URLWithString:backdropURLString];
        cell.backdropView.image = nil;
        [cell.backdropView setImageWithURL:backdropurl];
        NSString *URLString = self.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        cell.profileView.image = nil;
        [cell.profileView setImageWithURL:url];
        
        [cell.profileView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [cell.profileView.layer setBorderWidth: 2.0];
        
        return cell;
    }
    else{
        userTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userTweetCell"];
        Tweet *tweet = self.arrayOfTweets[indexPath.row - 1];
        
        cell.tweet = tweet;
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
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count + 1;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
