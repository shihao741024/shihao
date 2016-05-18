//
//  LocalPushFunction.h
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPushFunction : NSObject

+ (void)launchAppWithregisterLocalNotification;

// 设置本地通知
+ (UILocalNotification *)initLocalNotification:(NSDate *)fireDate alertBody:(NSString *)alertBody key:(NSString *)key message:(NSString *)message;

+ (void)scheduleLocalNotification:(UILocalNotification *)notification repeatInterval:(NSCalendarUnit)repeatInterval;
+ (void)presentLocalNotificationNow:(UILocalNotification *)notification repeatInterval:(NSCalendarUnit)repeatInterval;

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithValue:(NSString *)value;


@end
