//
//  CheckWorkFunction.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CheckWorkFunction.h"

@implementation CheckWorkFunction

//打卡记录开始时间或者结束时间
+ (NSString *)stringFromDate:(NSDate *)date isStart:(BOOL)isStart
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    
//    NSString *destDateString;
    if (isStart) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
//        destDateString = [dateFormatter stringFromDate:date];
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd 23:59:59"];
//        destDateString = [dateFormatter stringFromDate:[Function getPriousDateFromDate:date withDay:1]];
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

@end
