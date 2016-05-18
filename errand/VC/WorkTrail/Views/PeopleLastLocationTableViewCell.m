//
//  PeopleLastLocationTableViewCell.m
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "PeopleLastLocationTableViewCell.h"
#import "WorkTrailFunction.h"

@implementation PeopleLastLocationTableViewCell
{
    UILabel *_nameLabel;
    UILabel *_departmentLabel;
    UIImageView *_iconPhoto;
    
    UILabel *_distanceLabel;
    UILabel *_statusLabel;
    UILabel *_lastLocation;
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
    
    _statusLabel = [self.contentView createGeneralLabel:15 frame:CGRectMake(kFrameX(_iconPhoto), kFrameY(_departmentLabel)+kFrameH(_departmentLabel)+10, kWidth-45, 18) textColor:COMMON_FONT_BLACK_COLOR];
    
    _lastLocation = [self.contentView createGeneralLabel:15 frame:CGRectMake(kFrameX(_iconPhoto), kFrameY(_statusLabel)+kFrameH(_statusLabel)+10, kWidth-45, 18) textColor:COMMON_FONT_BLACK_COLOR];
    _lastLocation.numberOfLines = 0;
    
}

- (void)fillData:(NSDictionary *)dic status:(NSInteger)status
{
    [self hideAllView:NO];
    [_iconPhoto sd_setImageWithURL:dic[@"avatar"] placeholderImage:[UIImage imageNamed:@"headerImg_default"]];
    
    _nameLabel.text = dic[@"userName"];
    _departmentLabel.text = dic[@"org"];
    float distance = [dic[@"distance"] floatValue];
    _distanceLabel.text = [NSString stringWithFormat:@"今日里程：%.1fkm", distance/1000.0];
    
    if (dic[@"createDate"] == [NSNull null]) {
        _statusLabel.text = @"异常：没有获取到最后一次位置";
        _statusLabel.textColor = [UIColor colorWithRed:0.80 green:0.47 blue:0.42 alpha:1.00];
        _lastLocation.hidden = YES;
        self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameY(_statusLabel)+kFrameH(_statusLabel)+10);
    }else {
        if ([WorkTrailFunction lastLocationInHalfHour:dic[@"createDate"]]) {
            _statusLabel.text = @"正常";
            _statusLabel.textColor = kGreenColor;
            _lastLocation.hidden = NO;
            if (dic[@"coordinate"] != [NSNull null]) {
                _lastLocation.text = [NSString stringWithFormat:@"最后位置：%@", dic[@"coordinate"][@"name"]];
                [_lastLocation sizeToFit];
                self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameY(_lastLocation)+kFrameH(_lastLocation)+10);
            }else {
                _lastLocation.hidden = YES;
                self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameY(_statusLabel)+kFrameH(_statusLabel)+10);
            }
            
        }else {
            
            double createTimeTamp = [dic[@"createDate"] doubleValue]/1000;
            NSTimeInterval timeInt = [NSDate date].timeIntervalSince1970;
            double interval = timeInt-createTimeTamp;//多少秒没上传位置
            NSLog(@"intervalinterval = %f", interval);
            NSInteger minute = [[NSNumber numberWithDouble:interval / 60] integerValue];
            
            if (minute >= 60) {
                
                NSInteger surplusMinute = minute % 60;
                NSInteger hour = minute / 60;
                if (surplusMinute == 0) {
                    _statusLabel.text = [NSString stringWithFormat:@"异常：超过%ld小时未上传位置", hour];
                }else {
                    _statusLabel.text = [NSString stringWithFormat:@"异常：超过%ld小时%ld分钟未上传位置", hour, surplusMinute];
                }
            }else {
                _statusLabel.text = [NSString stringWithFormat:@"异常：超过%ld分钟未上传位置", minute];
            }
            
            _statusLabel.textColor = [UIColor colorWithRed:0.80 green:0.47 blue:0.42 alpha:1.00];
            _lastLocation.hidden = YES;
            self.frame = CGRectMake(kFrameX(self), kFrameY(self), kFrameW(self), kFrameY(_statusLabel)+kFrameH(_statusLabel)+10);
        }
    }
}



- (void)hideAllView:(BOOL)hide
{
    _nameLabel.hidden = hide;
    _departmentLabel.hidden = hide;
    _distanceLabel.hidden = hide;
    
    _iconPhoto.hidden = hide;
    _statusLabel.hidden = hide;
    _lastLocation.hidden = hide;
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
