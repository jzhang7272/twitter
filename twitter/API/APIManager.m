//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
        
    NSString *key= [dict objectForKey: @"consumer_Key"];
    NSString *secret = [dict objectForKey: @"consumer_Secret"];
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
 
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"tweet_mode": @"extended", @"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.idStr];

    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.idStr];

    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)getHomeTimelineWithCompletion:(int)nmbrTweets :(void(^)(NSArray *tweets, NSError *error))completion {
    NSDictionary *parameters = @{@"tweet_mode": @"extended", @"count": [NSNumber numberWithInt:nmbrTweets]};
    
    [self GET:@"1.1/statuses/home_timeline.json"
       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
           completion(tweets, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           completion(nil, error);
    }];
}

- (void)getUserTimelineWithCompletion:(NSString *)username :(void(^)(NSArray *tweets, NSError *error))completion {
    NSDictionary *parameters = @{@"tweet_mode": @"extended", @"screen_name": username};
    
    [self GET:@"1.1/statuses/user_timeline.json"
       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
           completion(tweets, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           completion(nil, error);
    }];
}

@end
