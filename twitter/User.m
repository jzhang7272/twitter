//
//  User.m
//  twitter
//
//  Created by Josey Zhang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        // Init all properties
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.created = [formatter stringFromDate:date];
        
        self.followers = [dictionary[@"followers_count"] intValue];
        self.following = [dictionary[@"friends_count"] intValue];
        self.tweets = [dictionary[@"statuses_count"] intValue];
        self.defaultBackground = dictionary[@"default_profile"];
        self.defaultProfile = dictionary[@"default_profile_image"];
        if (self.defaultBackground == true){
            self.backgroundImage = dictionary[@"profile_banner_url"];
        }
        
        
    }
    return self;
}

@end
