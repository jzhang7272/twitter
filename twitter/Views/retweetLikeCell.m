//
//  retweetLikeCell.m
//  Pods
//
//  Created by Josey Zhang on 6/30/21.
//

#import "retweetLikeCell.h"
#import "ButtonViewCell.h"

@interface retweetLikeCell () <ButtonViewCellDelegate>

@end

@implementation retweetLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateData:(Tweet *)tweet {
    NSLog(@"updateData called.");
    self.likeNumber.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    self.retweetNumber.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
