//
//  LocalPushFunction.m
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "LocalPushFunction.h"

@implementation LocalPushFunction

+ (void)launchAppWithregisterLocalNotification
{
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
    }
}

//根据秒设置date
// NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
// 设置本地通知 alertTime:时间，秒
+ (UILocalNotification *)initLocalNotification:(NSDate *)fireDate alertBody:(NSString *)alertBody key:(NSString *)key message:(NSString *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    if (fireDate) {
        notification.fireDate = fireDate;
    }
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 通知内容
    notification.alertBody =  alertBody;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (key) {
        [userInfo setObject:key forKey:@"key"];
    }
    if (message) {
        [userInfo setObject:message forKey:@"message"];
    }
    notification.userInfo = userInfo;

    return notification;
    
}

//iOS8 之前 NSDayCalendarUnit ，之后NSCalendarUnitDay
+ (void)scheduleLocalNotification:(UILocalNotification *)notification repeatInterval:(NSCalendarUnit)repeatInterval
{
    // 通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = repeatInterval;
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)presentLocalNotificationNow:(UILocalNotification *)notification repeatInterval:(NSCalendarUnit)repeatInterval
{
    notification.repeatInterval = repeatInterval;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

+ (void)cancelLocalNotificationWithValue:(NSString *)value;
{
    for (UILocalNotification *localNot in [UIApplication sharedApplication].scheduledLocalNotifications) {
        if (localNot.userInfo) {
            NSString *infoValue = localNot.userInfo[@"key"];
            if (infoValue) {
                if ([infoValue isEqualToString:value]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:localNot];
                }
            }
        }
    }
}

@end
