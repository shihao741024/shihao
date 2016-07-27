//
//  Function.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "Function.h"
#import "AppDelegate.h"
#import "MMPopupView.h"

@implementation Function

+ (NSDictionary *)getParametersDic:(NSDictionary *)infoDic
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
    return muDic;
}

+ (void)generalPostRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id responseObject))resultCB errorCB:(void(^)(NSError *error))errorCB
{
    
    NSDictionary *dic = [Function getParametersDic:infoDic];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [Function configRequestHeader:manager];
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        resultCB(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        errorCB(error);
        [Function maybeShowLoginCtrlWith:error];
    }];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

+ (id)userDefaultsObjForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)userDefaultsSetObj:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)userDefaultsRemoveObjForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIImage *)getOriginalImage:(NSString *)name
{
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIViewController *)getViewControllerWithView:(UIView *)view
{
    UIResponder *target = view;
    while (target) {
        target = target.nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    NSLog(@"getViewControllerWithView--%@", target);
    return (UIViewController *)target;
}

+ (NSString *)getDateAndWeek:(NSString *)time
{
    NSDate *date = [Function dateFromString:time];
    NSString *dateStr = [time substringToIndex:10];
    NSString *week = [Function getWeekWithDate:date];
    return [NSString stringWithFormat:@"%@ %@", dateStr, week];
}

+ (NSString *)getWeekWithDate:(NSDate *)date
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEE"];
    NSString *weekString = [dateformatter stringFromDate:date];
    return weekString;
}

+ (void)popMsgRequestError:(NSError *)error
{
    NSString *errorStr = [Function getMsgWithError:error];
    if (![errorStr isEqualToString:@""]) {
        [Dialog simpleToast:errorStr];
    }
}

+ (NSString *)getMsgWithError:(NSError *)error
{
//    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//    NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"errorStr=%@", errorStr);
//    return errorStr;
    
    NSError *contentError = error.userInfo[@"NSUnderlyingError"];
    NSData *data = contentError.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"errorStr=%@", errorStr);
    return errorStr;
}

//登录信息，被挤掉，error data
+ (NSString *)getDicWithLoginError:(NSError *)error
{
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", errorStr);
    return errorStr;
}

//请求f返回值不是json时，调用方法
+ (void)responseNotJsonRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id result))resultCB errorCB:(void(^)(NSError *error))errorCB
{
    NSDictionary *dic = [Function getParametersDic:infoDic];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [Function configRequestHeader:manager];
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",result);
        resultCB(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        errorCB(error);
        [Function maybeShowLoginCtrlWith:error];
    }];
}

+ (void)configRequestHeader:(AFHTTPRequestOperationManager *)manager
{
    NSDictionary *headerParam=@{@"username": [Function userDefaultsObjForKey:@"userName"],
                                @"token": [Function userDefaultsObjForKey:@"token"],
                                @"Accept": @"application/json",
                                @"Content-Type":@"application/json"};
    if(headerParam){
        NSArray *keys=[headerParam allKeys];
        for(int i=0;i<[headerParam allKeys].count;i++){
            NSString *val=headerParam[[keys objectAtIndex:i]];
            NSString *key=[keys objectAtIndex:i];
            [manager.requestSerializer setValue:val forHTTPHeaderField:key];
        }
    }
}

+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size
{
    if ([Function isNullOrNil:str]) {
        return CGSizeZero;
    }
    NSMutableDictionary *mdic=[NSMutableDictionary dictionary];
    [mdic setObject:font forKey:NSFontAttributeName];
    CGSize s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:mdic context:nil].size;
    return s;
}

+ (NSString *)dateChangeTitle:(int)dayIndex dateStr:(NSString *)dateStr
{
    if (dayIndex == 0) {
        return @"今天";
    }else if (dayIndex == 1) {
        return @"明天";
    }else if (dayIndex == -1) {
        return @"昨天";
    }else if (dayIndex == 2) {
        return @"后天";
    }else if (dayIndex == -2) {
        return @"前天";
    }else {
        return [dateStr substringToIndex:10];
    }
}

+ (void)generalGetRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id responseObject))resultCB errorCB:(void(^)(NSError *error))errorCB
{
    
    NSDictionary *dic = [Function getParametersDic:infoDic];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [Function configRequestHeader:manager];
    
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
        resultCB(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [Function maybeShowLoginCtrlWith:error];
        NSLog(@"%@",error);
        errorCB(error);
        
    }];
}

+ (BOOL)isBlankStrOrNull:(id)str
{
    if (str == nil) {
        return YES;
    }
    
    if (str == [NSNull null]) {
        return YES;
    }
    
    if ([str isEqualToString:@""]) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)isNullOrNil:(id)obj
{
    if (obj == nil) {
        return YES;
    }
    
    if (obj == [NSNull null]) {
        return YES;
    }
    
    return NO;
}

+ (void)maybeShowLoginCtrlWith:(NSError *)error
{
    if ([error.description rangeOfString:@"unauthorized (401)"].location != NSNotFound){
        
        if (![Function userDefaultsObjForKey:@"unauthorizedAlert"]) {
            
            NSString *errorStr = [Function getMsgWithError:error];
            
            [Function userDefaultsSetObj:@"1" forKey:@"unauthorizedAlert"];
            
            [Function deleteLoginUserName];
            [AlertUtil alertBody:errorStr block:^(NSInteger index) {
                [Function userDefaultsRemoveObjForKey:@"unauthorizedAlert"];
                
                AppDelegate *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                [del login];
                
            }];
        }
        
    }else{
        [Function popMsgRequestError:error];
    }
}

+ (void)deleteLoginUserName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"userName"];
    [user synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:loginOutNotification object:self userInfo:nil];
}

+ (void)isShowSystemLocationSetupPage:(NSInteger)buttonIndex
{
    [Function userDefaultsRemoveObjForKey:LocationAlertedFlag];
    
    if (buttonIndex == 1) {
        
        if (iOSVersion >= 8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
        
//        NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url];
//        }
    }
}

+ (void)alertUserDeniedLocation:(NSError *)error delegate:(id)delegate
{
//    NSLog(@"didFailWithError = %@", error);
    //不存在，说明还没有alert，可以进行alert
    if (![Function userDefaultsObjForKey:LocationAlertedFlag]) {
        [Function userDefaultsSetObj:@"1" forKey:LocationAlertedFlag];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"您的定位服务尚未开启，请在设置中允许定位，否则无法为您作定位服务，是否立即开启" delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
        alert.tag = LocationErrorAlertTag;
        [alert show];
    }
}

/** 开通知 */
+ (void)isShowSystemNotificationSetupPage:(NSInteger)buttonIndex {
    [Function userDefaultsRemoveObjForKey:NotificationAlertedFlag];
    if (buttonIndex == 1) {
        
        if (iOSVersion >= 8.0) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            NSURL*url=[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

+ (void)alertUserDeniedNotificationDelegate:(id)delegate {
    if (![Function userDefaultsObjForKey:NotificationAlertedFlag]) {
        [Function userDefaultsSetObj:@"3" forKey:NotificationAlertedFlag];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"您的消息推送功能尚未开启，您将无法接收到消息服务，是否立即开启" delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
        alert.tag = NotificationAlertFlag;
        [alert show];
    }
}



+ (void)refreshLoginInfo
{
    if (GDBUserID) {
        NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sales/refresh"];
        [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:responseObject[@"name"] forKey:@"name"];
            [user setObject:responseObject[@"id"] forKey:@"userID"];
            [user setObject:responseObject[@"telephone"] forKey:@"userName"];
            [user setObject:responseObject[@"organization"][@"id"] forKey:@"organizationID"];
            [user setObject:responseObject[@"organization"][@"name"] forKey:@"organizationName"];
            [user setObject:responseObject[@"msgNum"] forKey:@"msgNum"];
            //要对有无头像做判断
            if (responseObject[@"avatar"] != [NSNull null]) {
                [user setObject:responseObject[@"avatar"] forKey:@"avatar"];
            }else{
                [user removeObjectForKey:@"avatar"];
            }
//             position == 0 ? "代表" : position == 1 ? "主管" : position == 2 ? "经理" : position == 3 ? "总监" : "总经理";
            [user setObject:responseObject[@"position"] forKey:@"position"];
            
            [user synchronize];
            
        } errorCB:^(NSError *error) {
            
        }];
    }
}

+ (void)deleteUserDefaultsFlag
{
    
    [Function userDefaultsRemoveObjForKey:@"unauthorizedAlert"];
    [Function userDefaultsRemoveObjForKey:LocationAlertedFlag];
    [Function userDefaultsRemoveObjForKey:NotificationAlertedFlag];
}

+ (id)unarchiveObjectWithFile:(NSString *)path
{
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return data;
}

+ (void)archiveRootObjectWithPath:(NSString *)path data:(id)data
{
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}

+ (void)fileManagerCreateWithPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

+ (void)fileManagerDeleteWithPath:(NSString *)path
{
    //删除目录和里面的文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//        NSLog(@"%d, %@", success, error);
        
        if (success) {
            //重新创建
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
            }
        }
    }
}

+ (BOOL)inBeforeMonthFirstDay:(NSString *)dateStr
{
//    NSDate *date = [Function dateFromString:dateStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = dateComponents.day -(dateComponents.day -1);
    dateComponents.month = dateComponents.month -1;
    NSDate *beforeDate = [greCalendar dateFromComponents:dateComponents];
//    NSLog(@"%@",  beforeDate);
    NSString *beforeDateStr = [Function stringFromDate:beforeDate];
    beforeDateStr = [beforeDateStr substringToIndex:10];
    
    if ([beforeDateStr compare:dateStr] == (NSOrderedAscending | NSOrderedSame)) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateIDCard:(NSString *)email
{
    NSString *emailRegex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
