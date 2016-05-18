//
//  SignTrackClass.m
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SignTrackClass.h"
#import "AppDelegate.h"
#import "PathPointDataManager.h"
#import "PathPointModel.h"

@implementation SignTrackClass

+ (void)judgeSignInfoExist
{
    
    NSString *todayDateStr = [[Function stringFromDate:[NSDate date]] substringToIndex:10];
    PathPointDataManager *manager = [PathPointDataManager shareManager];
    
    //测试超过规定时间
//    NSString *todayDateStr = @"2016-04-17";
    
    if ([manager tableExistsWithName:todayDateStr]) {
        NSLog(@"今天的表已存在");
    }else {
        [manager createTableWithName:todayDateStr];
        [SignTrackClass getInitPathData:todayDateStr];
    }
    
}
//从服务器上初始化表，并将数据拉到本地
+ (void)getInitPathData:(NSString *)todayDateStr
{
    NSLog(@"getInitPathData");
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/path/init"];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        
        
        NSMutableArray *modelArray = [PathPointModel getModelArrayWithDicArray:responseObject];
        [[PathPointDataManager shareManager] beginTransaction];
        [[PathPointDataManager shareManager] insertModelWithArray:modelArray];
        [[PathPointDataManager shareManager] commit];
        
        [SignTrackClass saveLocationTimeInterval];
        [self saveLocationStartAndEndDate:modelArray];
        [Function userDefaultsSetObj:todayDateStr forKey:LocationTableExist];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate reStartRunLocationProcess];
        
    } errorCB:^(NSError *error) {
        
    }];
}
//保存定位要求的开始时间结束时间，表的第一个数据和最后一个数据的时间
+ (void)saveLocationStartAndEndDate:(NSMutableArray *)modelArray
{
    if (modelArray.count != 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *startDate = [dateFormatter dateFromString:[modelArray[0] planDate]];
        NSDate *endDate = [dateFormatter dateFromString:[[modelArray lastObject] planDate]];
        [Function userDefaultsSetObj:startDate forKey:@"LocationStartDate"];
        [Function userDefaultsSetObj:endDate forKey:@"LocationEndDate"];
    }
}

//YES为开始时间。NO为结束时间
+ (NSDate *)getLocationDateStart:(BOOL)isStart
{
    NSDate *date = [Function userDefaultsObjForKey:@"LocationStartDate"];
    if (date == nil) {
        NSString *currentStr = [Function stringFromDate:[NSDate date]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        NSString *defaultDateStr;
        if (isStart) {
            defaultDateStr = [[currentStr substringToIndex:10] stringByAppendingString:@" 08:00"];
            
        }else {
            defaultDateStr = [[currentStr substringToIndex:10] stringByAppendingString:@" 23:00"];
        }
        return [formatter dateFromString:defaultDateStr];
        
    }else {
        if (isStart) {
            return [Function userDefaultsObjForKey:@"LocationStartDate"];
        }else {
            return [Function userDefaultsObjForKey:@"LocationEndDate"];
        }
    }
}

//保存时间间隔
+ (void)saveLocationTimeInterval
{
    NSMutableArray *allPaths = [[PathPointDataManager shareManager] fetchAllModels];
    
    PathPointModel *firstModel;
    PathPointModel *secondModel;
    if (allPaths.count >= 2) {
        firstModel = [[PathPointDataManager shareManager] fetchAllModels][0];
        secondModel = [[PathPointDataManager shareManager] fetchAllModels][1];
    }
    
//    2016-04-12 08:10
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *firstDate = [dateFormatter dateFromString:firstModel.planDate];
    NSDate *secondDate = [dateFormatter dateFromString:secondModel.planDate];
    NSTimeInterval interval = [secondDate timeIntervalSinceDate:firstDate];
    NSLog(@"saveLocationTimeInterval = %f", interval);
    
    if (firstModel) {
        [Function userDefaultsSetObj:[NSNumber numberWithDouble:interval] forKey:@"LocationTimeInterval"];
    }else {
        [Function userDefaultsSetObj:[NSNumber numberWithDouble:300.0] forKey:@"LocationTimeInterval"];
    }
    
}

@end
