//
//  ButtonViewCell.m
//  twitter
//
//  Created by Josey Zhang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ButtonViewCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation ButtonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// Favoriting and unfavoriting
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == NO) {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 self.tweet = tweet;
                 NSLog(@"%@", tweet);
                 [self refreshData];
                 [self.delegate updateData:tweet];
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    else{
        self.tweet.favorited = NO;
        if (self.tweet.favoriteCount > 0){
            self.tweet.favoriteCount -= 1;
        }
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 self.tweet = tweet;
                 NSLog(@"%@", tweet);
                 [self refreshData];
                 [self.delegate updateData:tweet];
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}

// Retweet
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 self.tweet = tweet;
                 [self refreshData];
                 [self.delegate updateData:tweet];
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
    else{
        self.tweet.retweeted = NO;
        if (self.tweet.retweetCount > 0){
            self.tweet.retweetCount -= 1;
        }
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 self.tweet = tweet;
                 [self refreshData];
                 [self.delegate updateData:tweet];
                 NSLog(@"Successfully unretweeted following Tweet: %@", tweet.text);
             }
         }];
    }
}


- (void)refreshData {
    if (self.tweet.favorited == YES) {
        [self.likeButton setSelected:YES];
    }
    else{
        [self.likeButton setSelected:NO];
    }
    
    if (self.tweet.retweeted == YES) {
        [self.retweetButton setSelected:YES];
    }
    else{
        [self.retweetButton setSelected:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end