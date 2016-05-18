//
//  AppDelegate+UMSDK.h
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UMSDK)

//开启友盟统计
- (void)startUMAnalytics;
//开启推送
- (void)openUMPushServiceWithOptions:(NSDictionary *)launchOptions;

- (void)handleNotificationMsg:(NSDictionary *)userInfo;

@end
