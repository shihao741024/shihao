//
//  AttendanceTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/29.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AttendanceTableViewCell.h"

@implementation AttendanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (void)createCell{
    UIImageView *bgImgView = [[UIImageView alloc]init];
    bgImgView.layer.cornerRadius = 10;
    _bgImgView = bgImgView;
    [self addSubview:_bgImgView];
    UIImageView *locationView = [[UIImageView alloc]init];
    _locationImgView = locationView;
    [self addSubview:locationView];
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _locationLabel = locationLabel;
    _locationLabel.numberOfLines = 0;
    _locationLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _locationLabel.adjustsFontSizeToFitWidth = YES;
     _locationLabel.font = [UIFont systemFontOfSize:[MyAdapter aDapter:14]];
    [self addSubview:_locationLabel];
    UILabel *timeLabel = [[UILabel alloc]init];
     _timeLabel.font = [UIFont systemFontOfSize:[MyAdapter aDapter:14]];
    timeLabel.textColor = COMMON_BLUE_COLOR;
    _timeLabel = timeLabel;
    [self addSubview:_timeLabel];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(3);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.width.equalTo(SCREEN_WIDTH - 20 );
        make.left.equalTo(0);
    }];
    [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgImgView);
        make.left.equalTo(_bgImgView.mas_left).offset(10);
        make.height.equalTo(20);
        make.width.equalTo(20);
    }];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgImgView);
        make.right.equalTo(_timeLabel.mas_left).offset(-10);
        make.height.equalTo([MyAdapter aDapterView:60]);
        make.left.equalTo(_locationImgView.mas_right).offset(10);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgImgView);
        make.right.equalTo(_bgImgView.mas_right).offset(-10);
        make.height.equalTo(20);
        make.width.equalTo(50);
    }];
}

- (void)setAttendanceModel:(MyRecordModel *)model{
    _locationLabel.text = model.addressStr;
    _timeLabel.text = model.timeStr;
    _bgImgView.backgroundColor = [UIColor whiteColor];
     [_locationImgView setImage:[UIImage imageNamed:@"locationAtt"]];
}
- (void)setStaffRecordModel:(StaffRecordModel *)model{
    _locationLabel.text = [NSString stringWithFormat:@"%@(%@)", model.NameStr,model.addressStr];
    _timeLabel.text = model.timeStr;
    _bgImgView.backgroundColor = [UIColor whiteColor];
    [_locationImgView setImage:[UIImage imageNamed:@"locationAtt"]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
