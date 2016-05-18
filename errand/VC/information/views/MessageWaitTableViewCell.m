//
//  MessageWaitTableViewCell.m
//  errand
//
//  Created by 高道斌 on 16/4/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MessageWaitTableViewCell.h"

@implementation MessageWaitTableViewCell
{
    UILabel *timeLabel;
    UIImageView *_iconImgView;
    UILabel *_detailLabel;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COMMON_FONT_GRAY_COLOR;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
