//
//  RequestUtil.m
//  errand
//
//  Created by gravel on 16/1/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "RequestUtil.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@implementation RequestUtil
//公共的请求头
-(void)post:(NSString*)strUrl param:(id)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     NSDictionary *headerParam=@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"Accept": @"application/json",@"Content-Type":@"application/json"};//,@"Accept": @"application/json",@"Content-Type":@"application/json"
    //添加头部参数
    if(headerParam){
        NSArray *keys=[headerParam allKeys];
        for(int i=0;i<[headerParam allKeys].count;i++){
            NSString *val=headerParam[[keys objectAtIndex:i]];
            NSString *key=[keys objectAtIndex:i];
            [manager.requestSerializer setValue:val forHTTPHeaderField:key];
        }
    }
    
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }
 
    [manager  POST:strUrl parameters:param success:success failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        BOOL hasC=false;
//        int errorCode=error.code;
//        if (errorCode == -1009) {
//            [Dialog simpleToast:@"网络连接失败"];
//            hasC=true;
//        } else if ([error.description rangeOfString:@"unauthorized (401)"].location != NSNotFound){
//            [AlertUtil alertBody:@"登录已失效,请重新登录" block:^(NSInteger index) {
//                AppDelegate  *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//                [del login];
//            }];
//
//        }else if ([error.description rangeOfString:@"请求超时"].location != NSNotFound){
//            [Dialog simpleToast:@"请求超时"];
//        }else if ([error.description rangeOfString:@"JSON text did not start with array or object and option to allow fragments not set"].location != NSNotFound){
//            [Dialog simpleToast:@"服务器错误"];
//        }else if ([error.description rangeOfString:@"未能连接到服务器"].location != NSNotFound){
//            [Dialog simpleToast:@"未能连接到服务器。"];
//        }else if ([error.description rangeOfString:@"网络连接已中断"].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接已中断"];
//            hasC=true;
//        }
        [Function maybeShowLoginCtrlWith:error];

        failure(operation,error,hasC);
        NSLog(@"%@",error.description);
    } ];
}

//特殊的请求头
-(void)post:(NSString*)strUrl param:(NSDictionary*)param  headerParam:(NSDictionary *)headerParam success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加头部参数
    if(headerParam){
        NSArray *keys=[headerParam allKeys];
        for(int i=0;i<[headerParam allKeys].count;i++){
            NSString *val=headerParam[[keys objectAtIndex:i]];
             NSString *key=[keys objectAtIndex:i];
            [manager.requestSerializer setValue:val forHTTPHeaderField:key];
        }
    }
    
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }

//    NSString *str=[NSString stringWithFormat:@"%@\n%@",strUrl,param];
    [manager  POST:strUrl parameters:param success:success failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        BOOL hasC=false;
//         int errorCode=error.code;
//        if (errorCode == -1009) {
//            [Dialog simpleToast:@"网络连接失败"];
//            hasC=true;
//        } else if ([error.description rangeOfString:@"unauthorized (401)"].location != NSNotFound){
//            [AlertUtil alertBody:@"登录已失效,请重新登录" block:^(NSInteger index) {
//                AppDelegate  *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//                [del login];
//            }];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"请求超时"].location != NSNotFound){
//            [Dialog simpleToast:@"请求超时"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"JSON text did not start with array or object and option to allow fragments not set"].location != NSNotFound){
//            [Dialog simpleToast:@"服务器错误"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"未能连接到服务器"].location != NSNotFound){
//            [Dialog simpleToast:@"未能连接到服务器。"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"网络连接已中断"].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接已中断"];
//            hasC=true;
//        }
        [Function maybeShowLoginCtrlWith:error];
        failure(operation,error,hasC);
    } ];
}
//退出登录
-(void)postHTTP:(NSString*)strUrl param:(NSDictionary*)param  headerParam:(NSDictionary *)headerParam success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //添加头部参数
    if(headerParam){
        NSArray *keys=[headerParam allKeys];
        for(int i=0;i<[headerParam allKeys].count;i++){
            NSString *val=headerParam[[keys objectAtIndex:i]];
            NSString *key=[keys objectAtIndex:i];
            [manager.requestSerializer setValue:val forHTTPHeaderField:key];
        }
    }
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }
    
    //    NSString *str=[NSString stringWithFormat:@"%@\n%@",strUrl,param];
    [manager  POST:strUrl parameters:param success:success failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        BOOL hasC=false;
//        int errorCode=error.code;
//        if (errorCode == -1009) {
//            [Dialog simpleToast:@"网络连接失败"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"The request timed out."].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接超时"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"JSON text did not start with array or object and option to allow fragments not set"].location != NSNotFound){
//            [Dialog simpleToast:@"服务器错误"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"未能连接到服务器"].location != NSNotFound){
//            [Dialog simpleToast:@"未能连接到服务器。"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"网络连接已中断"].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接已中断"];
//            hasC=true;
//        }
        NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [Dialog simpleToast:string];
        failure(operation,error,hasC);
    } ];
}

//登录时
-(void)loginHTTP:(NSString*)strUrl param:(NSDictionary*)param  headerParam:(NSDictionary *)headerParam success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加头部参数
    if(headerParam){
        NSArray *keys=[headerParam allKeys];
        for(int i=0;i<[headerParam allKeys].count;i++){
            NSString *val=headerParam[[keys objectAtIndex:i]];
            NSString *key=[keys objectAtIndex:i];
            [manager.requestSerializer setValue:val forHTTPHeaderField:key];
        }
    }
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }
    
    //    NSString *str=[NSString stringWithFormat:@"%@\n%@",strUrl,param];
    [manager  POST:strUrl parameters:param success:success failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        BOOL hasC=false;
//        int errorCode=error.code;
//        if (errorCode == -1009) {
//            [Dialog simpleToast:@"网络连接失败"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"The request timed out."].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接超时"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"请求超时"].location != NSNotFound){
//            [Dialog simpleToast:@"请求超时"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"JSON text did not start with array or object and option to allow fragments not set"].location != NSNotFound){
//            [Dialog simpleToast:@"服务器错误"];
//             hasC=true;
//        }else if ([error.description rangeOfString:@"未能连接到服务器"].location != NSNotFound){
//            [Dialog simpleToast:@"未能连接到服务器"];
//            hasC=true;
//        }else if ([error.description rangeOfString:@"网络连接已中断"].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接已中断"];
//            hasC=true;
//        }
        NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [Dialog simpleToast:string];
        failure(operation,error,hasC);
    } ];
}

//get
- (void)get:(NSString *)strUrl param:(NSDictionary *)param headerParam:(NSDictionary *)hearderParam success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *headerParam=@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"Content-Type":@"application/json"};
    //添加头部参数
    if(headerParam){
        NSArray *keys=[headerParam allKeys];
        for(int i=0;i<[headerParam allKeys].count;i++){
            NSString *val=headerParam[[keys objectAtIndex:i]];
            NSString *key=[keys objectAtIndex:i];
            [manager.requestSerializer setValue:val forHTTPHeaderField:key];
        }
    }
    
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }
    [manager GET:strUrl parameters:param success:success failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        BOOL hasC=false;
//        int errorCode=error.code;
//        if (errorCode == -1009) {
//            [Dialog simpleToast:@"网络连接失败"];
////            hasC=true;
//        } else if ([error.description rangeOfString:@"unauthorized (401)"].location != NSNotFound){
//            
////            AppDelegate  *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
////            [del login];
////            [Dialog simpleToast:@"登录已失效,请重新登录"];
//
//            [AlertUtil alertBody:@"登录已失效,请重新登录" block:^(NSInteger index) {
//                AppDelegate  *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//                [del login];
//            }];
//        }else if ([error.description rangeOfString:@"JSON text did not start with array or object and option to allow fragments not set"].location != NSNotFound){
//            [Dialog simpleToast:@"服务器错误"];
//        }
//        else if ([error.description rangeOfString:@"请求超时"].location != NSNotFound){
//            [Dialog simpleToast:@"请求超时"];
//        }else if ([error.description rangeOfString:@"未能连接到服务器"].location != NSNotFound){
//            [Dialog simpleToast:@"未能连接到服务器。"];
//        }else if ([error.description rangeOfString:@"网络连接已中断"].location != NSNotFound){
//            [Dialog simpleToast:@"网络连接已中断"];
//            hasC=true;
//        }
        [Function maybeShowLoginCtrlWith:error];

        failure(operation,error,hasC);
//        NSLog(@"%@",error.description);
    }];
    
}


@end
