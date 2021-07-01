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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
