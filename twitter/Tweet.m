//
//  Tweet.m
//  twitter
//
//  Created by Josey Zhang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {

         // Is this a re-tweet?
         NSDictionary *originalTweet = dictionary[@"retweeted_status"];
         if(originalTweet != nil){
             NSDictionary *userDictionary = dictionary[@"user"];
             self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

             // Change tweet to original tweet
             dictionary = originalTweet;
         }
         self.ID = dictionary[@"id"];
         self.idStr = dictionary[@"id_str"];
         self.text = dictionary[@"full_text"];
         self.truncated = dictionary[@"truncated"];
         self.favoriteCount = [dictionary[@"favorite_count"] intValue];
         self.favorited = [dictionary[@"favorited"] boolValue];
         self.retweetCount = [dictionary[@"retweet_count"] intValue];
         self.retweeted = [dictionary[@"retweeted"] boolValue];
         self.replyCount = [dictionary[@"reply_count"] intValue];
         self.originalTweet = dictionary[@"retweeted_status"];
         
         // initialize user
         NSDictionary *user = dictionary[@"user"];
         self.user = [[User alloc] initWithDictionary:user];

         // format and set createdAtString
         NSString *createdAtOriginalString = dictionary[@"created_at"];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // Configure the input format to parse the date string
         formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
         // Convert String to Date
         NSDate *date = [formatter dateFromString:createdAtOriginalString];
         formatter.dateStyle = NSDateFormatterShortStyle;
         formatter.timeStyle = NSDateFormatterShortStyle;
         self.createdAtString = [formatter stringFromDate:date];
         
         NSDate *current = [NSDate date];
         NSInteger yearsApart = [date yearsFrom:current];
         NSInteger monthsApart = [date monthsFrom:current];
         NSInteger daysApart = [date daysFrom:current];
         NSInteger hoursApart = [date hoursFrom:current];
         NSInteger minutesApart = [date minutesFrom:current];
         NSInteger secondsApart = [date secondsFrom:current];
         if (yearsApart > 0){
             formatter.dateStyle = NSDateFormatterShortStyle;
             formatter.timeStyle = NSDateFormatterNoStyle;
             self.timeAgo = [formatter stringFromDate:date];
         }
         else if (monthsApart > 0){
             NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:monthsApart];
             self.timeAgo = timeAgoDate.shortTimeAgoSinceNow;
         }
         else if (daysApart > 0){
             NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:daysApart];
             self.timeAgo = timeAgoDate.shortTimeAgoSinceNow;
         }
         else if (hoursApart > 0){
             NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:hoursApart];
             self.timeAgo = timeAgoDate.shortTimeAgoSinceNow;
         }
         else if (minutesApart > 0){
             NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:minutesApart];
             self.timeAgo = timeAgoDate.shortTimeAgoSinceNow;
         }
         else{
             NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:secondsApart];
             self.timeAgo = timeAgoDate.shortTimeAgoSinceNow;
         }
    
     }
     return self;
 }

// convert array of tweets to array of Tweet objects
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
