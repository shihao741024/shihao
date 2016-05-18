//
//  AppDelegate+PathPointLocation.h
//  errand
//
//  Created by pro on 16/4/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface MyReGeocodeSearchRequest : AMapReGeocodeSearchRequest

@property (nonatomic, strong) PathPointModel *model;

@end


@interface AppDelegate (PathPointLocation)

- (void)setGaodeMapKey;

//get路径初始数据
- (void)runSignTrackAction;

- (void)runLocationProcess;

//登录成功通知中心执行方法
- (void)loginSuccessNotificationAction:(NSNotification *)notification;
//退出登录通知中心执行方法
- (void)loginOutNotificationAction:(NSNotification *)notification;

//关闭程序时本地推送
- (void)localPushActionWithClose;
//取消关闭程序时本地推送
- (void)cancelLocalPushActionWithClose;
//每天早上，打开app的通知
- (void)launchAppMorningLocalPush;

@end
