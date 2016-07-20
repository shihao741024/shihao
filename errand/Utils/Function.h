//
//  Function.h
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject

+ (NSDictionary *)getParametersDic:(NSDictionary *)infoDic;
//通用POST请求方法
+ (void)generalPostRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id responseObject))resultCB errorCB:(void(^)(NSError *error))errorCB;
//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date;
//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)dateString;

//获取n天后的NSDate
+ (NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)day;

+ (id)userDefaultsObjForKey:(NSString *)key;
+ (void)userDefaultsSetObj:(id)obj forKey:(NSString *)key;
+ (void)userDefaultsRemoveObjForKey:(NSString *)key;

//获取原始图片
+ (UIImage *)getOriginalImage:(NSString *)name;

//根据view获取所在viewCtrl
+ (UIViewController *)getViewControllerWithView:(UIView *)view;

// 2016-04-06 12:27:35 根据返回日期和星期 2016.04.06 周三
+ (NSString *)getDateAndWeek:(NSString *)time;
//判断字符串是否为空
+(NSString *)strIsNull:(NSString *)str;
//根据NSDate获取星期
+ (NSString *)getWeekWithDate:(NSDate *)date;
//弹出错误提示
+ (void)popMsgRequestError:(NSError *)error;
//获取错误msg字符串
+ (NSString *)getMsgWithError:(NSError *)error;

//请求返回值不是json时，调用方法
+ (void)responseNotJsonRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id result))resultCB errorCB:(void(^)(NSError *error))errorCB;

//通用GET请求方法
+ (void)generalGetRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id responseObject))resultCB errorCB:(void(^)(NSError *error))errorCB;

//配置请求头
+ (void)configRequestHeader:(AFHTTPRequestOperationManager *)manager;

//根据str计算size
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size;

//日期切换时显示的title
+ (NSString *)dateChangeTitle:(int)dayIndex dateStr:(NSString *)dateStr;

//判读是否空字符串或者null
+ (BOOL)isBlankStrOrNull:(id)str;
//判断登录信息过期，要重新登录
+ (void)maybeShowLoginCtrlWith:(NSError *)error;

//是否跳转系统设置定位页面
+ (void)isShowSystemLocationSetupPage:(NSInteger)buttonIndex;
//用户没有开启定位
+ (void)alertUserDeniedLocation:(NSError *)error delegate:(id)delegate;

//是否跳转系统设置通知页面
+ (void)isShowSystemNotificationSetupPage:(NSInteger)buttonIndex;
//用户没有开启通知
+ (void)alertUserDeniedNotificationDelegate:(id)delegate;


//刷新登录信息
+ (void)refreshLoginInfo;

//启动时清空标识
+ (void)deleteUserDefaultsFlag;
//创建目录
+ (void)fileManagerCreateWithPath:(NSString *)path;
//删除目录
+ (void)fileManagerDeleteWithPath:(NSString *)path;

+ (id)unarchiveObjectWithFile:(NSString *)path;

+ (void)archiveRootObjectWithPath:(NSString *)path data:(id)data;

+ (BOOL)isNullOrNil:(id)obj;

+ (BOOL)inBeforeMonthFirstDay:(NSString *)dateStr;

//邮箱
+ (BOOL)validateEmail:(NSString *)email;
//身份证
+ (BOOL)validateIDCard:(NSString *)email;

//登录token过期，删除username，发送登出通知
+ (void)deleteLoginUserName;

@end
