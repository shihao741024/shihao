//
//  DoctorDetailShowTableViewCell.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorDetailShowTableViewCell.h"

@implementation DoctorDetailShowTableViewCell

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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 18)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = COMMON_FONT_GRAY_COLOR;
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, kWidth-105, 0)];
    _contentLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _contentLabel.font = GDBFont(15);
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
}

- (void)fillData:(NSString *)str
{
    CGSize size = [Function sizeOfStr:str andFont:GDBFont(15) andMaxSize:CGSizeMake(kFrameW(_contentLabel), CGFLOAT_MAX)];
    _contentLabel.text = str;
    
    if (size.height < 18) {
        _contentLabel.frame = CGRectMake(kFrameX(_contentLabel), 0, kFrameW(_contentLabel), 18);
    }else {
        _contentLabel.frame = CGRectMake(kFrameX(_contentLabel), 0, kFrameW(_contentLabel), size.height);
    }
    
    self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameH(_contentLabel)+20);
    
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
