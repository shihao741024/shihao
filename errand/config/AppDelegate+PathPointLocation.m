//
//  AppDelegate+PathPointLocation.m
//  errand
//
//  Created by pro on 16/4/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AppDelegate+PathPointLocation.h"
#import "OriginalPointModel.h"
#import "OriginalPointDBManager.h"
#import "PathPointDataManager.h"


@implementation MyReGeocodeSearchRequest

@end

@implementation AppDelegate (PathPointLocation)

- (void)setGaodeMapKey
{
    //导航服务
    [AMapNaviServices sharedServices].apiKey =@"115f6fdafd40ce448aefb94fdd6ab040";
    //地图服务
    [MAMapServices sharedServices].apiKey = @"115f6fdafd40ce448aefb94fdd6ab040";
    //搜索服务
    [AMapSearchServices sharedServices].apiKey = @"115f6fdafd40ce448aefb94fdd6ab040";
    //定位服务
    [AMapLocationServices sharedServices].apiKey = @"115f6fdafd40ce448aefb94fdd6ab040";
}

- (void)runSignTrackAction
{
    //判断是否登录
    if ([Function userDefaultsObjForKey:@"userName"]) {
        [SignTrackClass judgeSignInfoExist];
    }
    
}

//登录成功的通知
- (void)loginSuccessNotificationAction:(NSNotification *)notification
{
    [Function userDefaultsRemoveObjForKey:LocationTableExist];
    if ([Function userDefaultsObjForKey:@"userName"]) {
        [SignTrackClass judgeSignInfoExist];
    }
    [Function deleteUserDefaultsFlag];
}

- (void)loginOutNotificationAction:(NSNotification *)notification
{
    [self.locationManager stopUpdatingLocation];
}

//开始定位
- (void)runLocationProcess
{
    if (GDBUserID) {
        self.locationManager = nil;
        self.locationManager.delegate = nil;
        
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        [self.locationManager startUpdatingLocation];
//        NSLog(@"runLocationProcess");
    }
    
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"didUpdateLocation%@", location);
    
    OriginalPointModel *model = [[OriginalPointModel alloc] initWithLocation:location latitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [[OriginalPointDBManager shareManager] insertModel:model];
    
    
    [self stopLocationWhenTimeoutWithDate:location.timestamp location:location];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
//    kCLErrorDenied
    if (error.code == 1) {
        [Function alertUserDeniedLocation:error delegate:self];
    }
}

//判断是否在规定时间，不在则停止定位
- (void)stopLocationWhenTimeoutWithDate:(NSDate *)date location:(CLLocation *)location
{
    
    NSMutableArray *modelArray = [[PathPointDataManager shareManager] fetchAllModels];
    
    if (modelArray.count != 0) {
//        PathPointModel *lastModel = [modelArray lastObject];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//        NSDate *lastDate = [dateFormatter dateFromString:lastModel.planDate];
        
        NSDate *startDate = [Function userDefaultsObjForKey:@"LocationStartDate"];
        startDate = [[NSDate alloc] initWithTimeInterval:-60*60 sinceDate:startDate];
        NSDate *endDate = [Function userDefaultsObjForKey:@"LocationEndDate"];
        
        if ([[NSDate date] compare:startDate] == NSOrderedAscending ||
            [[NSDate date] compare:endDate] == NSOrderedDescending) {
            [self.locationManager stopUpdatingLocation];
            NSLog(@"不在规定时间内，停止定位");
        }else {
            [self sortLocationIndex:location];
        }
    }else {
        [self.locationManager stopUpdatingLocation];
        NSLog(@"无本地列表，停止定位");
    }
}

//排序并判断应该更新哪条数据
- (void)sortLocationIndex:(CLLocation *)location
{
    NSDate *locationDate = location.timestamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *locationDateStr = [dateFormatter stringFromDate:locationDate];
    
    locationDate = [dateFormatter dateFromString:locationDateStr];
    
    NSMutableArray *planDateStrArray = [[PathPointDataManager shareManager] fetchAllModelsPlanDate];
    NSMutableArray *planDateArray = [NSMutableArray array];
    for (NSString *dateStr in planDateStrArray) {
        [planDateArray addObject:[dateFormatter dateFromString:dateStr]];
    }
    
    //不存在，sort排序
    if ([planDateArray indexOfObject:locationDate] == NSNotFound) {
        [planDateArray addObject:locationDate];
        [planDateArray sortUsingSelector:@selector(compare:)];
        
        NSInteger index = [planDateArray indexOfObject:locationDate];
        if (index == 0) {
            [self updateDBLocationData:location index:index];
        }else if (index == planDateArray.count - 1) {
            [self updateDBLocationData:location index:index-1];
        }else {
            NSTimeInterval interval = [[Function userDefaultsObjForKey:@"LocationTimeInterval"] doubleValue];
            NSDate *middleDate = [[NSDate alloc] initWithTimeInterval:interval/2.0 sinceDate:planDateArray[index-1]];
            //增序,更新前一个位置
            if ([locationDate compare:middleDate] == NSOrderedAscending) {
                [self updateDBLocationData:location index:index-1];
            }else { //相等或者降序， 更新后一个位置
                [self updateDBLocationData:location index:index];
            }
        }
    }else {//存在，直接替换
        NSInteger existIndex = [planDateArray indexOfObject:locationDate];
        [self updateDBLocationData:location index:existIndex];
    }
    
}

//所得经纬度插入本地数据库更新
- (void)updateDBLocationData:(CLLocation *)location index:(NSInteger)index
{
    NSMutableArray *modelArray = [[PathPointDataManager shareManager] fetchAllModels];
    
    if (modelArray.count != 0) {
        
        PathPointModel *model = modelArray[index];
        if (model.latitude == nil) {
            model.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
            model.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
            [[PathPointDataManager shareManager] updatePathPoint:model];
            
            if (GDBUserID) {
                [self pathPointReGoecodeSearch:location model:model];
                [self searchFailedAndReCommit];
            }
        }
    }
    
}

- (void)pathPointReGoecodeSearch:(CLLocation *)location model:(PathPointModel *)model
{
    NSLog(@"//发起逆地理编码");
    
    self.search = nil;
    self.search.delegate = nil;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    MyReGeocodeSearchRequest *regeoRequest = [[MyReGeocodeSearchRequest alloc] init];
    regeoRequest.requireExtension = YES;
    regeoRequest.model = model;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //发起逆地理编码
    [self.search AMapReGoecodeSearch:regeoRequest];
    
}
// 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(MyReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        if (request.model.name == nil) {
            NSString *resultAddress = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
            request.model.name = resultAddress;
            [[PathPointDataManager shareManager] updatePathPoint:request.model];
            
            [self uploadToServerWithModel:request.model];
            
            NSLog(@"%@", resultAddress);
        }else {
            [self uploadToServerWithModel:request.model];
        }
    }
    
}
//将打点数据上传服务器
- (void)uploadToServerWithModel:(PathPointModel *)model
{
    //之前没有上传或没有成功
    if ([model.upload isEqualToNumber:@0]) {
        NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/path/create"];
        
        NSDictionary *dic = @{@"id": model.ID,
                              @"coordinate": @{@"latitude": model.latitude,
                                               @"longitude": model.longitude,
                                               @"name": model.name}};
        
        [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
            model.upload = [NSNumber numberWithInt:1];
            [[PathPointDataManager shareManager] updatePathPoint:model];
        } errorCB:^(NSError *error) {
            
        }];
    }
    
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"AMapSearchRequesterror = %@", error);
}

//寻找之前逆地理编码失败的或者上传服务器失败的数据，重新上传
- (void)searchFailedAndReCommit
{
    NSMutableArray *modelArray = [[PathPointDataManager shareManager] fetchAllModels];
    for (PathPointModel *model in modelArray) {
        if (model.latitude != nil) {
            if (model.name == nil) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:[model.latitude doubleValue] longitude:[model.longitude doubleValue]];
                [self pathPointReGoecodeSearch:location model:model];
            }else {
                if ([model.upload isEqualToNumber:@0]) {
                    [self uploadToServerWithModel:model];
                }
            }
        }
    }
}


- (void)localPushActionWithClose
{
    NSDate *startDate = [Function userDefaultsObjForKey:@"LocationStartDate"];
    startDate = [[NSDate alloc] initWithTimeInterval:-60*60 sinceDate:startDate];
    NSDate *endDate = [Function userDefaultsObjForKey:@"LocationEndDate"];
    
    if ([[NSDate date] compare:startDate] == NSOrderedAscending ||
        [[NSDate date] compare:endDate] == NSOrderedDescending) {
        NSLog(@"不在规定时间内，不进行关闭程序推送");
    }else {
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        UILocalNotification *not = [LocalPushFunction initLocalNotification:fireDate alertBody:@"为了保证定位服务正常运行，请打开程序并保持在后台运行！" key:@"applicationWillTerminate" message:@"请按以上提示操作"];
        [LocalPushFunction scheduleLocalNotification:not repeatInterval:0];
    }
    
}

// 本地通知回调函数，当应用程序在前台时调用,或者后台切换到前台调用，启动时不调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示"
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
//    [alert show];
    
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 在不需要再推送时，可以取消推送
    //    [LocalPushFunction cancelLocalNotificationWithKey:notMess];
}

- (void)cancelLocalPushActionWithClose
{
    [LocalPushFunction cancelLocalNotificationWithValue:@"applicationWillTerminate"];
}

- (void)launchAppMorningLocalPush
{
    NSDate *startDate = [SignTrackClass getLocationDateStart:YES];
    startDate = [Function getPriousDateFromDate:startDate withDay:1];
    NSDate *fireDate = [NSDate dateWithTimeInterval:-20*60 sinceDate:startDate];
    NSLog(@"launchAppMorningLocalPush --%@", [Function stringFromDate:fireDate]);
    UILocalNotification *not = [LocalPushFunction initLocalNotification:fireDate alertBody:@"为了保证定位服务正常运行，请打开程序并保持在后台运行！" key:@"applicationWillTerminate" message:@"请按以上提示操作"];
    [LocalPushFunction scheduleLocalNotification:not repeatInterval:NSCalendarUnitDay];
}

@end
