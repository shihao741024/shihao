//
//  WorkTrailFunction.m
//  errand
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "WorkTrailFunction.h"
#import "SignTrackClass.h"
#import "pinyin.h"

@implementation WorkTrailFunction

+ (BOOL)lastLocationInHalfHour:(NSNumber *)createDate
{
    //30分钟之前的时间
    NSDate *lastDate = [SignTrackClass getLocationDateStart:NO];
    NSDate *create = [NSDate dateWithTimeIntervalSince1970:[createDate doubleValue]/1000];
    
    //当前时间超过打点最后时间
    if ([[NSDate date] compare:lastDate] == NSOrderedDescending) {
        
        NSDate *beforeDate = [NSDate dateWithTimeInterval:-30*60 sinceDate:lastDate];
        if ([beforeDate compare:create] == NSOrderedAscending) {
            return YES;
        }else {
            return NO;
        }
    }else {
        NSDate *beforeDate = [NSDate dateWithTimeInterval:-30*60 sinceDate:[NSDate date]];
        if ([beforeDate compare:create] == NSOrderedAscending) {
            return YES;
        }else {
            return NO;
        }
    }
}

+ (void)sortCharactorWithSourceArray:(NSMutableArray *)sourceArray returnArray:(NSMutableArray *)returnArray keyStr:(NSString *)keyStr
{
    //按字母顺序分组
    
    for (int i=0; i<26; i++) {
        NSMutableArray *itemArray = [NSMutableArray array];
        
        for (int j=0; j<sourceArray.count; j++) {
            NSDictionary *dic = sourceArray[j];
            char firstCharactor = pinyinFirstLetter([dic[keyStr] characterAtIndex:0]);
            if (firstCharactor == 97 + i) {
                [itemArray addObject:dic];
            }
        }
        [returnArray addObject:itemArray];
        
    }
    
    NSMutableArray *extraArray = [NSMutableArray arrayWithArray:sourceArray];
    for (int i=0; i<sourceArray.count; i++) {
        NSDictionary *dic = sourceArray[i];
        
        for (int j=0; j<26; j++) {
            char firstCharactor = pinyinFirstLetter([dic[keyStr] characterAtIndex:0]);
            if (firstCharactor == 97 + j) {
                [extraArray removeObject:dic];
                break;
            }
        }
    }
    
    if (extraArray.count != 0) {
        [returnArray addObject:extraArray];
    }
}

+ (CLLocationDegrees)getLatWithDic:(NSDictionary *)dic
{
    return [dic[@"coordinate"][@"latitude"] doubleValue];
}

+ (CLLocationDegrees)getLonWithDic:(NSDictionary *)dic
{
    return [dic[@"coordinate"][@"longitude"] doubleValue];
}

+ (CLLocationDegrees)getSummaryLatWithDic:(NSDictionary *)dic
{
    NSArray *gps = [dic[@"gps"] componentsSeparatedByString:@","];
    return [gps[1] doubleValue];
}

+ (CLLocationDegrees)getSummaryLonWithDic:(NSDictionary *)dic
{
    NSArray *gps = [dic[@"gps"] componentsSeparatedByString:@","];
    return [gps[0] doubleValue];
}

+ (NSString *)getAnnotationTitle:(NSString *)dateStr
{
    double timestamp = [dateStr doubleValue] /1000.0;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    //        NSString *title = [NSString stringWithFormat:@"最近一次更新时间%@", [formatter stringFromDate:createDate]];
    NSString *title = [formatter stringFromDate:startDate];
    return title;
}

@end
