//
//  AttendanceModel.m
//  errand
//
//  Created by gravel on 15/12/28.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MyRecordModel.h"

@implementation MyRecordModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        
        _addressStr = dic[@"coordinate"][@"name"];
        
//        long dt=[dic[@"createDate"] doubleValue]/1000;
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dt];
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"HH:mm"];
//        NSString *currentDateStr1 = [dateFormatter1 stringFromDate:confromTimesp];
//        _timeStr = currentDateStr1;
        
        _timeStr =  [dic[@"createDate"] substringWithRange:NSMakeRange(11, 5)];
       
        
        //  增加用于判断时间的时间戳
//        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//        [dateFormatter2 setDateFormat:@"YYYYMMdd"];
//        NSString *currentDateStr2 = [dateFormatter2 stringFromDate:confromTimesp];
        _flagTimeStr = [dic[@"createDate"] substringToIndex:10];

       
    }
    return self;
}

@end
