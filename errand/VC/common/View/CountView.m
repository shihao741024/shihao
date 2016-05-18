//
//  CountView.m
//  errand
//
//  Created by gravel on 16/2/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CountView.h"

@implementation CountView{
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    UILabel * _amountLabel;
    int _type;
    NSString *_sunday;
    NSString *_monday;
}

- (instancetype)initWithFrame:(CGRect)frame type:(int)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self createView];
    }
    return self;
}

- (void)createView{
    _leftBtn = [[AmotButton alloc]init];
    [_leftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [[AmotButton alloc]init];
    [_rightBtn setImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
    [self addSubview:_rightBtn];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _amountLabel = [[UILabel alloc]init];
    [_amountLabel setFont:[UIFont systemFontOfSize:17]];
    _amountLabel.textColor = [UIColor grayColor];
    _amountLabel.textColor = COMMON_BLUE_COLOR;
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_amountLabel];

   
     UIView *superView = self;
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-30);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(superView);
    }];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(30);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(superView);
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBtn.mas_right).offset(0);
        make.right.equalTo(_rightBtn.mas_left).offset(0);
        make.centerY.equalTo(self);
    }];
    
     NSDate *today = [NSDate date];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    if (_type == 0) {
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        _amountLabel.text = [dateFormatter stringFromDate:today];
    }else if (_type == 1){
        
       [self calculteDateOfMondayAndSundayInAWeekWithDate:today];    }
    
}

- (void)leftBtnClick{
    
    if (_type == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        //获取到标签上的时间
        NSDate *amountLabelDate = [dateFormatter dateFromString:_amountLabel.text];
        //获取当前的日历
         NSCalendar *calendar = [NSCalendar currentCalendar];
        
         NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:amountLabelDate];
        //设置成当月的第一天
         components.day = 2;
        //取得当月第一天的日期
         NSDate *firstDate = [calendar dateFromComponents:components];
        
        //获取前一个月的任意一天
         NSTimeInterval second = [firstDate timeIntervalSince1970];
         NSDate *frontDate = [NSDate dateWithTimeIntervalSince1970:second - 86400*5];
        
        //使前一个月的年月 显示在标签上
         _amountLabel.text = [dateFormatter stringFromDate:frontDate];
        if ([self.delegate respondsToSelector:@selector(buttonClickWithMonth:)]) {
            [self.delegate buttonClickWithMonth:_amountLabel.text];
        }
        
    }else if (_type == 1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        NSDate *date = [dateFormatter dateFromString:_monday];
        NSTimeInterval second = [date timeIntervalSince1970];
        [self calculteDateOfMondayAndSundayInAWeekWithDate:[NSDate dateWithTimeIntervalSince1970:second - 86400]];
        
        if ([self.delegate respondsToSelector:@selector(buttonClickWithMonth:)]) {
            [self.delegate buttonClickWithMonth:_monday];
        }
    }
    
    
}
- (void)rightBtnClick{
    
    if (_type == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        //获取到标签上的时间
        NSDate *amountLabelDate = [dateFormatter dateFromString:_amountLabel.text];
        //获取当前的日历
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:amountLabelDate];
        //设置成当月的最后一天
         NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:amountLabelDate];
         components.day = days.length;
        //取得当月最后一天的日期
        NSDate *firstDate = [calendar dateFromComponents:components];
        
        //获取后一个月的任意一天
        NSTimeInterval second = [firstDate timeIntervalSince1970];
        NSDate *frontDate = [NSDate dateWithTimeIntervalSince1970:second + 86400*5];
        
        //使前一个月的年月 显示在标签上
        _amountLabel.text = [dateFormatter stringFromDate:frontDate];
        
        if ([self.delegate respondsToSelector:@selector(buttonClickWithMonth:)]) {
            [self.delegate buttonClickWithMonth:_amountLabel.text];
        }

    }else if (_type == 1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [dateFormatter dateFromString:_sunday];
        NSTimeInterval second = [date timeIntervalSince1970];
        [self calculteDateOfMondayAndSundayInAWeekWithDate:[NSDate dateWithTimeIntervalSince1970:second + 86400]];
        
        if ([self.delegate respondsToSelector:@selector(buttonClickWithMonth:)]) {
            [self.delegate buttonClickWithMonth:_monday];
        }
    }
   
}


#pragma mark - 计算 date 日期所在周内的 周一 和 周日 的日期
/**
 *  计算 date 日期所在周内的 周一 和 周日 的日期
 *
 *  @param date <#date description#>
 */
- (void)calculteDateOfMondayAndSundayInAWeekWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:date];
    
    NSTimeInterval second = [date timeIntervalSince1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 根据今天是星期几来计算这个星期的星期一的日期   注：西方的星期天为东方的星期一，因此要做一下判断
    if (components.weekday == 1) {
        
        _sunday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];
        _monday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second - 6 * 86400]];
        //        second = second - 6 * 86400;
    } else {
        
        _sunday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second + (8 - components.weekday) * 86400]];
        _monday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second - (components.weekday - 2) * 86400]];
        //        second = second - (components.weekday - 2) * 86400;
    }
    
    
    //    _monday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];
    //    _sunday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second + 6 * 86400]];
    
    _amountLabel.text = [NSString stringWithFormat:@"%@~%@",_monday,_sunday];//[_monday substringFromIndex:5], [_sunday substringFromIndex:5]
    //    NSLog(@"monday   %@", _monday);
    //    NSLog(@"sunday   %@", _sunday);
    
}

@end
