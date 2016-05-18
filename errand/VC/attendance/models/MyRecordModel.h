//
//  AttendanceModel.h
//  errand
//
//  Created by gravel on 15/12/28.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRecordModel : NSObject

@property (nonatomic, strong)NSString *addressStr;
@property (nonatomic, strong)NSString *timeStr;
//@property (nonatomic, strong)NSString *detailTimeStr;
@property (nonatomic, strong) NSString *flagTimeStr;

- (instancetype)initWithDic:(NSDictionary *)dic;


//+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
//    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    
//    [calendar setTimeZone: timeZone];
//    
//    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
//    
//    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
//    
//    return [weekdays objectAtIndex:theComponents.weekday];
//    
//}
// IOS 根据日期，获取该日期所在周，月，年的开始日期，结束日期 的方法
//http://www.2cto.com/kf/201407/315706.html



/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
//- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
//{
//    NSDate *date8 = [self getCustomDateWithHour:8];
//    NSDate *date23 = [self getCustomDateWithHour:23];
//    
//    NSDate *currentDate = [NSDate date];
//    
//    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
//    {
//        NSLog(@"该时间在 %d:00-%d:00 之间！", fromHour, toHour);
//        return YES;
//    }
//    return NO;
//}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
//- (NSDate *)getCustomDateWithHour:(NSInteger)hour
//{
//    //获取当前时间
//    NSDate *currentDate = [NSDate date];
//    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
//    
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    
//    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
//    
//    //设置当天的某个点
//    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
//    [resultComps setYear:[currentComps year]];
//    [resultComps setMonth:[currentComps month]];
//    [resultComps setDay:[currentComps day]];
//    [resultComps setHour:hour];
//    
//    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    return [resultCalendar dateFromComponents:resultComps];
//}
@end
