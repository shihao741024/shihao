//
//  SignStatusTableViewCell.m
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SignStatusTableViewCell.h"

@implementation SignStatusTableViewCell
{
    UILabel *_nameLabel;
    UILabel *_departmentLabel;
    UIImageView *_iconPhoto;
    
    UILabel *_distanceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _iconPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 44, 44)];
    _iconPhoto.layer.cornerRadius = 22;
    _iconPhoto.clipsToBounds = YES;
    [self.contentView addSubview:_iconPhoto];
    
    _nameLabel = [self.contentView createGeneralLabel:15 frame:CGRectMake(10+kFrameX(_iconPhoto)+kFrameW(_iconPhoto), kFrameY(_iconPhoto), 100, 18) textColor:COMMON_FONT_BLACK_COLOR];
    
    
    _departmentLabel = [self.contentView createGeneralLabel:13 frame:CGRectMake(kFrameX(_nameLabel), kFrameY(_nameLabel)+kFrameH(_nameLabel)+10, kWidth-45, 16) textColor:COMMON_FONT_GRAY_COLOR];
    
    _distanceLabel = [self.contentView createGeneralLabel:14 frame:CGRectMake(kWidth-30-150, kFrameY(_nameLabel), 150, kFrameH(_nameLabel)) textColor:COMMON_FONT_GRAY_COLOR];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.hidden = YES;
    
}

- (void)fillData:(NSDictionary *)dic
{
    [self hideAllView:NO];
    [_iconPhoto sd_setImageWithURL:dic[@"avatar"] placeholderImage:[UIImage imageNamed:@"headerImg_default"]];
    
    _nameLabel.text = dic[@"userName"];
    _departmentLabel.text = dic[@"org"];
    float distance = [dic[@"distance"] floatValue];
    _distanceLabel.text = [NSString stringWithFormat:@"今日里程：%.1fkm", distance];
    _distanceLabel.hidden = YES;
}

- (void)hideAllView:(BOOL)hide
{
    _nameLabel.hidden = hide;
    _departmentLabel.hidden = hide;
    _distanceLabel.hidden = hide;
    
    _iconPhoto.hidden = hide;
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
