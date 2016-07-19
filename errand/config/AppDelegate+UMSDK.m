//
//  AppDelegate+UMSDK.m
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AppDelegate+UMSDK.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DeclareDetailViewController.h"
#import "TaskDetailViewController.h"
#import "MissionDetailViewController.h"
#import "CustomerVisitDetailViewController.h"
#import "ReportDetailVC.h"
#import "DoctorDetailShowViewController.h"
#import "WebViewController.h"

@implementation AppDelegate (UMSDK)

- (void)startUMAnalytics
{
    
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:UMAnalyticsKey];
    [MobClick setLogEnabled:YES];
    [MobClick setCrashReportEnabled:YES];
    [MobClick setBackgroundTaskEnabled:NO];
    
    if (GDBUserID) {
        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@", GDBUserID]];
    }else {
        [MobClick profileSignOff];
    }
    
}

- (void)openUMPushServiceWithOptions:(NSDictionary *)launchOptions
{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:UMPushKey launchOptions:launchOptions];
    [UMessage setAutoAlert:NO];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(iOSVersion >= 8.0)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString: @""] stringByReplacingOccurrencesOfString:@" " withString: @""];
    NSLog(@"deviceTokenStr==%@",deviceTokenStr);
    [Function userDefaultsSetObj:deviceTokenStr forKey:@"deviceTokenStr"];
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification = %@", userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"fetchCompletionHandler = %@", userInfo);
    self.pushUserInfo = userInfo;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alert show];
        alert.tag = UMPushAlertTag;
        NSLog(@"UIApplicationStateActive");
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        if (GDBUserID) {
            [self handleNotificationMsg:userInfo];
        }
        
        NSLog(@"UIApplicationStateInactive");
    }else {
    
        
    }
//    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//        NSLog(@"UIApplicationStateBackground");
//    }
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
    }
}

- (void)handleNotificationMsg:(NSDictionary *)userInfo
{
    
    if ([userInfo[@"type"] isEqualToString:@"saleCost"]) {//费用申报
        DeclareDetailViewController *viewCtrl = [[DeclareDetailViewController alloc] init];
        viewCtrl.declareID = userInfo[@"id"];
        viewCtrl.type = 2;
        
        [self messagePushPresentViewCtrl:viewCtrl];
        
        [viewCtrl setChangeDeclareStatusBlock:^(NSIndexPath *indexPath, NSNumber *number, NSString *str) {
            
        }];
        [viewCtrl setEditFinishRefreshCB:^{
            
        }];
    }
    if ([userInfo[@"type"] isEqualToString:@"saleTask"]) {//任务交办
        TaskDetailViewController *viewCtrl = [[TaskDetailViewController alloc] init];
        viewCtrl.taskID = userInfo[@"id"];
        viewCtrl.type = 2;
        
        [self messagePushPresentViewCtrl:viewCtrl];
        
        [viewCtrl setChangeStatusBlock:^(NSIndexPath *indexPath, NSString *str) {
            
        }];
    }
    if ([userInfo[@"type"] isEqualToString:@"trip"]) {//出差详情
        MissionDetailViewController *viewCtrl = [[MissionDetailViewController alloc] init];
        viewCtrl.missionID = userInfo[@"id"];
        viewCtrl.type = 2;
        
        [self messagePushPresentViewCtrl:viewCtrl];
        
        [viewCtrl setChangeMissionStatusBlock:^(NSIndexPath *indexPath, int num, MissionModel *model) {
            
        }];
        [viewCtrl setDeleteMissionDataBlock:^(NSIndexPath *indexPath) {
            
        }];
    }
    if ([userInfo[@"type"] isEqualToString:@"saleVisitPlan"]) {//拜访详情
        CustomerVisitDetailViewController *viewCtrl = [[CustomerVisitDetailViewController alloc] init];
        viewCtrl.visitID = userInfo[@"id"];
        
        [self messagePushPresentViewCtrl:viewCtrl];
        
        [viewCtrl setChangeVisitStatusBlock:^(NSIndexPath *indexPath, NSString *str) {
            
        }];
        
        [viewCtrl setRefreshBeforeDataCB:^{
            
        }];
    }
    if ([userInfo[@"type"] isEqualToString:@"report"]){//微博日报
        
        ReportDetailVC *viewCtrl = [[ReportDetailVC alloc]init];
        viewCtrl.reportID = userInfo[@"id"];
        [self messagePushPresentViewCtrl:viewCtrl];
        
    }
    if ([userInfo[@"type"] isEqualToString:@"doctor"]) {//医生详情
        DoctorDetailShowViewController *viewCtrl = [[DoctorDetailShowViewController alloc]init];
        viewCtrl.doctorID = userInfo[@"id"];
        [self messagePushPresentViewCtrl:viewCtrl];
    }
    if ([userInfo[@"type"] isEqualToString:@"link"]) {//link
        WebViewController *viewCtrl = [[WebViewController alloc]init];
        viewCtrl.url = userInfo[@"id"];
        [self messagePushPresentViewCtrl:viewCtrl];
    }
    
}

- (void)messagePushPresentViewCtrl:(UIViewController *)viewCtrl
{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
    if (self.tabBarController.presentedViewController) {
        [self.tabBarController dismissViewControllerAnimated:NO completion:^{
            
            [self.tabBarController presentViewController:navi animated:YES completion:^{
                
            }];
        }];
    }else {
        [self.tabBarController presentViewController:navi animated:YES completion:^{
            
        }];
    }
    
}

@end
