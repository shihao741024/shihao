//
//  SignTrackClass.h
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignTrackClass : NSObject

//判断今天数据是否已存在
+ (void)judgeSignInfoExist;
//初始化路径
+ (void)getInitPathData:(NSString *)todayDateStr;
//计算时间间隔并保存
+ (void)saveLocationTimeInterval;

//YES为开始定位时间。NO为结束定位时间
+ (NSDate *)getLocationDateStart:(BOOL)isStart;

@end
