//
//  User.h
//  twitter
//
//  Created by Josey Zhang on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *created;
@property (nonatomic) int followers;
@property (nonatomic) int tweets;
@property (nonatomic) int following;
@property (nonatomic) BOOL defaultBackground;
@property (nonatomic) BOOL defaultProfile;
@property (nonatomic, strong) NSString *backgroundImage;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
