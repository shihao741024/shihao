//
//  AppDelegate.m
//  errand
//
//  Created by gravel on 15/12/8.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Launch.h"
#import "LoginViewController.h"
#import "AddRecordVC.h"
#import "RequestUtil.h"
#import "AppDelegate+PathPointLocation.h"
#import "AppDelegate+UMSDK.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
- (BOOL)shouldAutorotate{
    
    if (_allowRotation == 1) {
        return YES;
    }
    return NO;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions, %@", launchOptions);
//  [NSThread sleepForTimeInterval:1];
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor colorWithRed:0.322 green:0.710 blue:0.996 alpha:1.000];
    self.window = window;
    [Function fileManagerCreateWithPath:kMyCaches];
    
    NSLog(@"%@", NSHomeDirectory());
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [Function deleteUserDefaultsFlag];
    [self startUMAnalytics];
    [self openUMPushServiceWithOptions:launchOptions];
    [self setGaodeMapKey];
    //注册推送
    [LocalPushFunction launchAppWithregisterLocalNotification];
//    [self launchAppMorningLocalPush];
    [self checkUpdateInfo];
    [Function refreshLoginInfo];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotificationAction:) name:loginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutNotificationAction:) name:loginOutNotification object:nil];
   
    _viewController = [[LoginViewController alloc]init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"userName"]) {
        [self enter];
        
    }else{
        self.window.rootViewController = _viewController;
    }
   
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)enter{
    _tabBarController = [self createTabBar];
    
}
- (void)login{
   LoginViewController *viewController = [[LoginViewController alloc]init];
   self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

}

//开始定位
- (void)reStartRunLocationProcess
{
    [self runLocationProcess];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LocationErrorAlertTag) {
        [Function isShowSystemLocationSetupPage:buttonIndex];
    }
    if (alertView.tag == UMPushAlertTag) {
        if (buttonIndex == 1) {
            if (GDBUserID) {
                //收到推送时弹窗
                [self handleNotificationMsg:_pushUserInfo];
            }
        }
    }
    
    if (alertView.tag == 298618) {
        //有新版本的时候弹窗
        ExtendtionAlertView *alert = (ExtendtionAlertView *)alertView;
        
        if (buttonIndex == 1) {
//            NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
            [[UIApplication sharedApplication] openURL:alert.userInfo[@"url"]];
        }
        
        NSInteger flag = [alert.userInfo[@"flag"] integerValue];
        if (flag == 1) {
            exit(0);
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}

//app从其他状态变为处于前台时，必走的方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    //开始打点的准备工作和逻辑判断
    [self runSignTrackAction];
    //开始打点
    [self runLocationProcess];
    //取消本地推送
    [self cancelLocalPushActionWithClose];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    [self localPushActionWithClose];
    [NSThread sleepForTimeInterval:0.5];
    
    NSLog(@"applicationWillTerminate");
    
}

@end
