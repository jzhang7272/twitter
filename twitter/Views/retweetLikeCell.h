//
//  retweetLikeCell.h
//  Pods
//
//  Created by Josey Zhang on 6/30/21.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface retweetLikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *retweetNumber;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
