//
//  DetailsViewController.m
//  twitter
//
//  Created by Josey Zhang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailCell.h"
#import "ButtonViewCell.h"
#import "ReplyCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "retweetLikeCell.h"

@interface DetailsViewController () <ButtonViewCellDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView reloadData];
}

- (void)updateData:(Tweet *)tweet {
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        Tweet *tweet = self.tweet;
        cell.tweet = tweet;
        cell.tweetLabel.text = tweet.text;
        cell.userLabel.text = tweet.user.name;
        cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
        cell.timeLabel.text = tweet.createdAtString;
        NSString *URLString = tweet.user.profilePicture;
        NSURL *url = [NSURL URLWithString:URLString];
        cell.profileView.image = nil;
        [cell.profileView setImageWithURL:url];
        cell.profileView.layer.cornerRadius = cell.profileView.frame.size.width / 2;;
        cell.profileView.layer.masksToBounds = YES;
        return cell;
    }
    else if (indexPath.row == 1){
        retweetLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"retweetLikeCell"];
        Tweet *tweet = self.tweet;
        cell.tweet = tweet;
        cell.likeNumber.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
        cell.retweetNumber.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
        return cell;
    }
    else{
        ButtonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        Tweet *tweet = self.tweet;
        cell.delegate = self;
        cell.tweet = tweet;
        if (cell.tweet.favorited == YES) {
            [cell.likeButton setSelected:YES];
        }
        else{
            [cell.likeButton setSelected:NO];
        }
        [cell.retweetButton setTitle:[NSString stringWithFormat:@"%i",tweet.retweetCount] forState: UIControlStateNormal];
        if (cell.tweet.retweeted == YES) {
            [cell.retweetButton setSelected:YES];
        }
        else{
            [cell.retweetButton setSelected:NO];
        }
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


@end
