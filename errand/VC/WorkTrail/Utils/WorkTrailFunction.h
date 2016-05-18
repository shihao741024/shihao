//
//  WorkTrailFunction.h
//  errand
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WorkTrailFunction : NSObject

//是否是30分钟之前的时间
+ (BOOL)lastLocationInHalfHour:(NSNumber *)createDate;
//获取第一个字母
+ (NSString *)firstCharactor:(NSString *)aString;
//返回按首字母排序的二维数组
+ (void)sortCharactorWithSourceArray:(NSMutableArray *)array returnArray:(NSMutableArray *)returnArray keyStr:(NSString *)keyStr;

+ (CLLocationDegrees)getLatWithDic:(NSDictionary *)dic;
+ (CLLocationDegrees)getLonWithDic:(NSDictionary *)dic;

+ (CLLocationDegrees)getSummaryLatWithDic:(NSDictionary *)dic;
+ (CLLocationDegrees)getSummaryLonWithDic:(NSDictionary *)dic;

+ (NSString *)getAnnotationTitle:(NSString *)dateStr;

@end
