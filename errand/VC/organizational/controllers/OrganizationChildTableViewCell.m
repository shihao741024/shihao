//
//  OrganizationChildTableViewCell.m
//  errand
//
//  Created by 高道斌 on 16/4/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "OrganizationChildTableViewCell.h"

@implementation OrganizationChildTableViewCell
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    CGFloat _cellWidth;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellWidth = kWidth-20;
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
    _titleLabel.textColor = COMMON_FONT_GRAY_COLOR;
    _titleLabel.font = GDBFont(17);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+100, 0, _cellWidth-100-10-20, 20)];
    _contentLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _contentLabel.font = GDBFont(17);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    
}

- (void)fillDataTitle:(NSString *)title content:(NSString *)content
{
    _titleLabel.text = title;
    
    CGSize contentSize = [Function sizeOfStr:content andFont:GDBFont(17) andMaxSize:CGSizeMake(kFrameW(_contentLabel), CGFLOAT_MAX)];
    _contentLabel.text = content;
    
    _contentLabel.frame  =CGRectMake(kFrameX(_contentLabel), 0, kFrameW(_contentLabel), contentSize.height);
    
    self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), contentSize.height+20);
    
    
    
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
