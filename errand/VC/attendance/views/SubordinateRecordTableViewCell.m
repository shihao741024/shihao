//
//  SubordinateRecordTableViewCell.m
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SubordinateRecordTableViewCell.h"

@implementation SubordinateRecordTableViewCell
{
    UIImageView *_locImg;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    
    CGFloat _cellW;
    
    UIView *_bgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellW = kWidth - 75;
        self.contentView.backgroundColor = GDBColorRGB(0.85, 0.85, 0.85, 1);
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, _cellW-16, 0)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 3;
    _bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:_bgView];
    
    _locImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 50, 20)];
    _locImg.contentMode = UIViewContentModeCenter;
    _locImg.image = [UIImage imageNamed:@"locationAtt"];
    [_bgView addSubview:_locImg];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 50, 20)];
    _timeLabel.font = GDBFont(15);
    _timeLabel.textColor = COMMON_BLUE_COLOR;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_timeLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, kFrameW(_bgView)-50-10, 0)];
    _contentLabel.font = GDBFont(15);
    _contentLabel.numberOfLines = 0;
    [_bgView addSubview:_contentLabel];
    
}

- (void)fillData:(NSDictionary *)dic
{
    _timeLabel.text = [dic[@"createDate"] substringWithRange:NSMakeRange(11, 5)];
    _contentLabel.text = dic[@"coordinate"][@"name"];
    [_contentLabel sizeToFit];
    
    CGFloat height = 50;
    if (10+kFrameH(_contentLabel) < 50) {
        height = 50;
    }else {
        height = 10+kFrameH(_contentLabel);
    }
    
    _bgView.frame = CGRectMake(kFrameX(_bgView), kFrameY(_bgView), kFrameW(_bgView), height);
    
    self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), height+10);
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
