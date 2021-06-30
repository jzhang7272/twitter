//
//  ButtonViewCell.h
//  twitter
//
//  Created by Josey Zhang on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ButtonViewCellDelegate

- (void)updateData:(Tweet *)tweet;

@end

@interface ButtonViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) id<ButtonViewCellDelegate> delegate;

@property (strong, nonatomic) Tweet* tweet;

@end

NS_ASSUME_NONNULL_END
