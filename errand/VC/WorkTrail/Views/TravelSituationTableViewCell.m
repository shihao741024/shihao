//
//  TravelSituationTableViewCell.m
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "TravelSituationTableViewCell.h"

@implementation TravelSituationTableViewCell
{
    UILabel *_timeLabel;
    UIImageView *_timeImgView;
    
//    UIImageView *_statusImgView;
//    UIImageView *_linkImgView;
    
    UIImageView *_contentImgView;
    UILabel *_durationLabel;
    UILabel *_msgLabel;
    UIView *_lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
//        self.clipsToBounds = YES;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _timeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 55, 30)];
    _timeImgView.image = [[UIImage imageNamed:@"trail_time_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake((80-26)/2.0, 9, (80-26)/2.0, 26/2.0)];
    [self.contentView addSubview:_timeImgView];
    
    _timeLabel = [_timeImgView createGeneralLabel:15 frame:CGRectMake(0, 0, 50, 30) textColor:COMMON_FONT_BLACK_COLOR];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    _topLinkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25+50+10+11, 0, 9, 25)];
    [self.contentView addSubview:_topLinkImgView];
    
    _linkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25+50+10+11, 15, 9, 30)];
    _linkImgView.image = [UIImage imageNamed:@"tracker_summary_run_down"];
    [self.contentView addSubview:_linkImgView];
    
    _statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25+50+10, 0, 30, 30)];
    _statusImgView.image = [UIImage imageNamed:@"tracker_summary_icon_stop"];
    [self.contentView addSubview:_statusImgView];
    
    _contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25+50+10+30+10, 0, kWidth-(25+50+10+30+10)-25, 30)];
    _contentImgView.image = [[UIImage imageNamed:@"trail_false_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake((80-26)/2.0, 26/2.0, (80-26)/2.0, 80/2.0-20/2.0)];
    [self.contentView addSubview:_contentImgView];
    
    _durationLabel = [_contentImgView createGeneralLabel:14 frame:CGRectMake(15, 6.5, kFrameW(_contentImgView)-20, 17) textColor:COMMON_FONT_BLACK_COLOR];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 6.5+17+5, kFrameW(_contentImgView)-20, 0.5)];
    _lineView.backgroundColor = kLineColor;
    [_contentImgView addSubview:_lineView];
    
    _msgLabel = [_contentImgView createGeneralLabel:14 frame:CGRectMake(15, kFrameY(_lineView)+5, kFrameW(_contentImgView)-20, 17) textColor:COMMON_FONT_BLACK_COLOR];
    _msgLabel.numberOfLines = 0;
    
    
}
//2016-04-04 11:11:11
- (void)fillData:(NSDictionary *)dic beforeDic:(NSDictionary *)beforeDic
{
    NSTimeInterval interval = [dic[@"startDate"] doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    _timeLabel.text = [[Function stringFromDate:date] substringWithRange:NSMakeRange(11, 5)];
    
    NSInteger duration = [dic[@"minute"] integerValue];
    NSString *durationStr;
    if (duration >= 60) {
        NSInteger hour = duration/60;
        NSInteger minute = duration%60;
        if (minute == 0) {
            durationStr = [NSString stringWithFormat:@"%ld小时", hour];
        }else {
            durationStr = [NSString stringWithFormat:@"%ld小时%ld分钟", hour, minute];
        }
        
    }else {
        durationStr = [NSString stringWithFormat:@"%@分钟", dic[@"minute"]];
    }
    
    if ([dic[@"action"] isEqualToString:@"停"]) {
        _statusImgView.image = [UIImage imageNamed:@"tracker_summary_icon_stop"];
        _linkImgView.image = [UIImage imageNamed:@"tracker_summary_run_down"];
        _durationLabel.text = [NSString stringWithFormat:@"停留时间：%@", durationStr];
        [self hideMsgLabel:NO dic:dic];
        
    }else if ([dic[@"action"] isEqualToString:@"行"]) {
        _statusImgView.image = [UIImage imageNamed:@"tracker_summary_icon_walk"];
        _linkImgView.image = [UIImage imageNamed:@"tracker_run"];
        _durationLabel.text = [NSString stringWithFormat:@"移动时间：%@", durationStr];
        [self hideMsgLabel:YES dic:dic];
        
    }else if ([dic[@"action"] isEqualToString:@"异常"]) {
        _statusImgView.image = [UIImage imageNamed:@"tracker_summary_icon_error"];
        _linkImgView.image = [UIImage imageNamed:@"tracker_summary_false"];
        _durationLabel.text = [NSString stringWithFormat:@"异常时间：%@", durationStr];
        [self hideMsgLabel:NO dic:dic];
        
    }
    
    if (beforeDic == nil) {
        _topLinkImgView.hidden = YES;
    }else {
        _topLinkImgView.hidden = NO;
        
        if ([beforeDic[@"action"] isEqualToString:@"停"]) {
            _topLinkImgView.image = [UIImage imageNamed:@"tracker_summary_run_down"];
            
        }else if ([beforeDic[@"action"] isEqualToString:@"行"]) {
            _topLinkImgView.image = [UIImage imageNamed:@"tracker_run"];
            
        }else if ([beforeDic[@"action"] isEqualToString:@"异常"]) {
            _topLinkImgView.image = [UIImage imageNamed:@"tracker_summary_false"];
            
        }
    }
}

- (void)hideLinkImgView:(BOOL)hide
{
    _linkImgView.hidden = hide;
}

- (void)hideMsgLabel:(BOOL)hide dic:(NSDictionary *)dic
{
    _lineView.hidden = hide;
    _msgLabel.hidden = hide;
    
    if (hide) {
        _contentImgView.frame = CGRectMake(kFrameX(_contentImgView), kFrameY(_contentImgView), kFrameW(_contentImgView), 30);
        _contentImgView.image = [[UIImage imageNamed:@"trail_ture_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake((80-26)/2.0, 26/2.0, (80-26)/2.0, 80/2.0-20/2.0)];
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), 30+10);

    }else {
        if ([dic[@"action"] isEqualToString:@"异常"]) {
            _contentImgView.image = [[UIImage imageNamed:@"trail_false_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake((80-26)/2.0, 26/2.0, (80-26)/2.0, 80/2.0-20/2.0)];
            _msgLabel.text = [NSString stringWithFormat:@"无法获取位置，可能是员工关机或手机阻止了%@获取位置", kAppName];
            
        }else if ([dic[@"action"] isEqualToString:@"停"]) {
            _contentImgView.image = [[UIImage imageNamed:@"trail_ture_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake((80-26)/2.0, 26/2.0, (80-26)/2.0, 80/2.0-20/2.0)];
            _msgLabel.text = dic[@"location"];
            
        }
        CGSize size = [Function sizeOfStr:_msgLabel.text andFont:GDBFont(14) andMaxSize:CGSizeMake(kFrameW(_msgLabel), CGFLOAT_MAX)];
        _msgLabel.frame = CGRectMake(kFrameX(_msgLabel), kFrameY(_msgLabel), kFrameW(_msgLabel), size.height);
        _contentImgView.frame = CGRectMake(kFrameX(_contentImgView), kFrameY(_contentImgView), kFrameW(_contentImgView), kFrameY(_msgLabel)+kFrameH(_msgLabel)+6.5);
        
        self.frame = CGRectMake(kFrameX(self), kFrameH(self), kFrameW(self), kFrameY(_contentImgView)+kFrameH(_contentImgView)+10);
    }
    _linkImgView.frame = CGRectMake(kFrameX(_linkImgView), 15, 9, kFrameH(self)-15);
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
