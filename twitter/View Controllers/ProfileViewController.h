//
//  ProfileViewController.h
//  twitter
//
//  Created by Josey Zhang on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User* user;
@property (nonatomic, strong) Tweet* tweet;

@end

NS_ASSUME_NONNULL_END
