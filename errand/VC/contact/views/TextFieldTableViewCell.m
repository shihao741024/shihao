//
//  TextFieldTableViewCell.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = COMMON_BACK_COLOR;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 44)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = COMMON_FONT_BLACK_COLOR; //COMMON_FONT_GRAY_COLOR
    [self.contentView addSubview:_titleLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, kWidth-105, 44)];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textColor = COMMON_FONT_BLACK_COLOR;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.font = GDBFont(15);
    [self.contentView addSubview:_textField];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 43, kWidth-105, 0.5)];
    _lineView.backgroundColor = kLineColor;
    [self.contentView addSubview:_lineView];
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
