//
//  FillVisitTextViewTableViewCell.m
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "FillVisitTextViewTableViewCell.h"

@implementation FillVisitTextViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 150)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = COMMON_FONT_GRAY_COLOR;
    [self.contentView addSubview:_titleLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(90, 0, kWidth-105, 150)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = COMMON_FONT_BLACK_COLOR;
    [self.contentView addSubview:_textView];
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
