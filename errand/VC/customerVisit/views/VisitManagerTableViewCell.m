//
//  VisitManagerTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/31.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "VisitManagerTableViewCell.h"

@implementation VisitManagerTableViewCell

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
//    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
//    headImgView.backgroundColor = COMMON_FONT_GRAY_COLOR;
//    headImgView.layer.cornerRadius = 15;
//    _headImgView = headImgView;
//    [self addSubview:_headImgView];
    UILabel *staffLbl = [self createLabelWithFont:17 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    _staffLbl = staffLbl;
    [self addSubview:_staffLbl];
    UILabel *countLbl = [self createLabelWithFont:15 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentRight];
    _countLbl = countLbl;
    [self addSubview:_countLbl];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 0.3)];
    lineLabel.backgroundColor = COMMON_FONT_GRAY_COLOR;
    _lineLabel = lineLabel;
    [self addSubview:_lineLabel];
    
    [_staffLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(_lineLabel.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(_countLbl.mas_left).offset(-8);
    }];
    [_countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(_lineLabel.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(50);
    }];
    
    NSArray *weekArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    float spacing = (SCREEN_WIDTH - 7*30-15*2)/6;
    for (int i = 0 ; i < 7; i++) {
        UILabel *label = [self createLabelWithFont:15 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(15+(spacing+30)*i, 40, 30, 30);
        label.text = weekArray[i];
        label.tag = 10+i;
        [self addSubview:label];
        UILabel *numberLbl = [self createLabelWithFont:22 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
        numberLbl.frame = CGRectMake(15+(spacing+30)*i, 40+30, 30, 30);
        numberLbl.text = @"0";
        numberLbl.tag = 20+i;
       [self addSubview:numberLbl];
       [self sendSubviewToBack:numberLbl];
    }
      UILabel *currentLabel = [[UILabel alloc]init];
    _currentLabel = currentLabel;
    [self addSubview:_currentLabel];
    UILabel *bottomLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 10)];
    
    bottomLbl.backgroundColor = COMMON_BACK_COLOR;
    [self addSubview:bottomLbl];
}
- (void)setVisitManagerModel:(VisitManagerModel *)model{
    _staffLbl.text = model.staffStr;
    _countLbl.text = model.countStr;
    
    
//
//    label.textColor = COMMON_BLUE_COLOR;
//    
//  
//    _currentLabel.frame = CGRectMake(label.frame.origin.x -5, label.frame.origin.y-5, 40, 40);
//    _currentLabel.layer.cornerRadius = 20;
//    _currentLabel.layer.borderWidth = 0.5;
//    _currentLabel.layer.borderColor = COMMON_BLUE_COLOR.CGColor;
}
- (void)setReportCountArray:(NSArray *)countArray{
    ReportCountModel *model = countArray[0];
    _staffLbl.text = model.name;
    
    
    int totolCount = 0;
    for (ReportCountModel *reportModel in countArray) {
        totolCount = totolCount + [reportModel.count intValue];
    }
    _countLbl.text = [NSString stringWithFormat:@"共%d条",totolCount];
    
    for (int i = 0 ; i < 7; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:20+i];
        label.text = @"0";
    }
    
    for (ReportCountModel *countModel in countArray) {
     NSInteger order = [self orderDayFromDate:countModel.day];
        if (order == 1) {
         UILabel *label = (UILabel *)[self viewWithTag:26];
         label.text = [NSString stringWithFormat:@"%@",countModel.count];
        }else{
          UILabel *label = (UILabel *)[self viewWithTag:20 + order - 2];
          label.text = [NSString stringWithFormat:@"%@",countModel.count];
        }
        
    }
    
    //对当天的统计 做一下背景色
    NSInteger todayOrder = [self orderTodayDate];
    if (todayOrder == 1) {
        UILabel *label = (UILabel *)[self viewWithTag:26];
        label.textColor = COMMON_BLUE_COLOR;
        _currentLabel.frame = CGRectMake(label.frame.origin.x -5, label.frame.origin.y-5, 40, 40);
        _currentLabel.layer.cornerRadius = 20;
        _currentLabel.layer.borderWidth = 0.5;
        _currentLabel.layer.borderColor = COMMON_BLUE_COLOR.CGColor;
    }else{
        UILabel *label = (UILabel *)[self viewWithTag:20 + todayOrder - 2];
        label.textColor = COMMON_BLUE_COLOR;
        _currentLabel.frame = CGRectMake(label.frame.origin.x -5, label.frame.origin.y-5, 40, 40);
        _currentLabel.layer.cornerRadius = 20;
        _currentLabel.layer.borderWidth = 0.5;
        _currentLabel.layer.borderColor = COMMON_BLUE_COLOR.CGColor;
    }
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size
                   andTextColor:(UIColor *)color
               andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    return label;
}

//根据日期获取是一周的第几天  返回一是周日
- (NSInteger)orderDayFromDate:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yy-MM-dd"];
    
    NSDate *inputDate = [dateFormatter dateFromString:dateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday;
}

//根据日期获取是一周的第几天
- (NSInteger)orderTodayDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    return theComponents.weekday;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
