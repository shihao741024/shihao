//
//  AppDelegate.h
//  errand
//
//  Created by gravel on 15/12/8.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignTrackClass.h"
#import <CoreLocation/CoreLocation.h>
#import "LocalPushFunction.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "PathPointModel.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import "RDVTabBarController.h"
#import "ExtendtionAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AMapSearchDelegate, AMapLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *viewController;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (strong, nonatomic) AMapSearchAPI *search;
@property (strong, nonatomic) RDVTabBarController *tabBarController;
@property (strong, nonatomic) NSDictionary *pushUserInfo;
@property (assign, nonatomic) NSInteger allowRotation;
//重启定位服务
- (void)reStartRunLocationProcess;

- (void)enter;
- (void)login;
@end

