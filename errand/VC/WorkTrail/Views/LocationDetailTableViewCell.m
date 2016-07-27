//
//  LocationDetailTableViewCell.m
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "LocationDetailTableViewCell.h"

@implementation LocationDetailTableViewCell
{
    UILabel *_timeLabel;
    UILabel *_addressLabel;
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
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
    _timeLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = GDBFont(15);
    [self.contentView addSubview:_timeLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, kWidth-60-10, 0)];
    _addressLabel.numberOfLines = 0;
    _addressLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _addressLabel.font = GDBFont(14);
    [self.contentView addSubview:_addressLabel];
    
}

- (void)fillData:(NSDictionary *)dic
{
    
    
    _timeLabel.text = dic[@"createDate"];
    
    NSString *address = dic[@"coordinate"][@"name"];
    CGSize size = [Function sizeOfStr:address andFont:GDBFont(14) andMaxSize:CGSizeMake(kFrameW(_addressLabel), CGFLOAT_MAX)];
    _addressLabel.text = address;
    
    if (size.height < 44) {
        _timeLabel.frame = CGRectMake(0, 0, 60, 44);
        _addressLabel.frame = CGRectMake(60, 0, kFrameW(_addressLabel), 44);
        self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), 44);
    }else {
        _timeLabel.frame = CGRectMake(0, 0, 60, size.height);
        _addressLabel.frame = CGRectMake(60, 0, kFrameW(_addressLabel), size.height);
        self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), size.height);
    }
    
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
