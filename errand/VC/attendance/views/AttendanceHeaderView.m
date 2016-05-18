//
//  AttendanceHeaderView.m
//  errand
//
//  Created by gravel on 15/12/30.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AttendanceHeaderView.h"

@implementation AttendanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *bgImgView = [[UIView alloc]init];
        bgImgView.layer.cornerRadius = 10;
        _bgImgView.backgroundColor = [UIColor whiteColor];
        _bgImgView = bgImgView;
        [self addSubview:_bgImgView];
        UIImageView *locationView = [[UIImageView alloc]init];
        _locationImgView = locationView;
        [_bgImgView addSubview:locationView];
        UILabel *locationLabel = [[UILabel alloc]init];
        locationLabel.textColor = COMMON_FONT_BLACK_COLOR;
        _locationLabel = locationLabel;
        _locationLabel.font = [UIFont systemFontOfSize:[MyAdapter aDapter:15]];
        [_bgImgView addSubview:_locationLabel];
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont systemFontOfSize:[MyAdapter aDapter:15]];
        timeLabel.textColor = COMMON_BLUE_COLOR;
        _headerTimeLabel = timeLabel;
        [_bgImgView addSubview:_headerTimeLabel];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.height.equalTo([MyAdapter aDapterView:60]);
            make.width.equalTo(SCREEN_WIDTH - 20 );
            make.left.equalTo(self.mas_left).offset(10);
        }];
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bgImgView);
            make.left.equalTo(_bgImgView.mas_left).offset(10);
            make.height.equalTo(20);
            make.width.equalTo(20);
        }];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bgImgView);
            make.right.equalTo(_headerTimeLabel.mas_left).offset(-10);
            make.height.equalTo([MyAdapter aDapterView:60]);
            make.left.equalTo(_locationImgView.mas_right).offset(10);
        }];
        [_headerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bgImgView);
            make.right.equalTo(_bgImgView.mas_right).offset(-10);
            make.height.equalTo(20);
            make.width.equalTo(50);
        }];
  }
    return self;
}
- (void)setMyRecordModelToView:(MyRecordModel*)model{

    _locationLabel.text = model.addressStr;
    _locationLabel.numberOfLines = 0;
    _locationLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _locationLabel.adjustsFontSizeToFitWidth = YES;
    _headerTimeLabel.text = model.timeStr;
    _bgImgView.backgroundColor = [UIColor whiteColor];
    [_locationImgView setImage:[UIImage imageNamed:@"locationAtt"]];

}
@end
