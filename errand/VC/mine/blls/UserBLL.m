//
//  UserBLL.m
//  errand
//
//  Created by gravel on 16/1/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "UserBLL.h"
#import "Dialog.h"
#import "QiniuSDK.h"
@implementation UserBLL
-(void)login:(void (^)(int  result))result  username:(NSString*)username password:(NSString*)password viewCtrl:(id)viewCtrl{
    
    NSString *strUrl=@"/api/v0/login";
    NSMutableDictionary *param= [NSMutableDictionary dictionary];
    [param setObject:username forKey:@"username"];
    [param setObject:password forKey:@"password"];
    [param setObject:@"ios" forKey:@"device"];
    
    if ([Function userDefaultsObjForKey:@"deviceTokenStr"]) {
        [param setObject:[Function userDefaultsObjForKey:@"deviceTokenStr"] forKey:@"device_tokens"];
    }
    
    [self loginHTTP:strUrl param:param headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@",responseObject);
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:responseObject[@"token"] forKey:@"token"];
        [user setObject:responseObject[@"name"] forKey:@"name"];
        [user setObject:responseObject[@"id"] forKey:@"userID"];
        [user setObject:responseObject[@"position"] forKey:@"position"];
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
        [user synchronize];
        result(1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        if(!hasCon){
            [Function popMsgRequestError:error];
//            [Dialog simpleToast:@"登录名或密码错误"];
        }
        result(0);
    }]; 
}

-(void)logout:(void (^)(int))result username:(NSString *)username viewCtrl:(id)viewCtrl{
    NSString *strUrl=@"/api/v0/logout";
    NSDictionary *headerParam=@{@"username":username};
    [self loginHTTP:strUrl param:nil headerParam:headerParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        result(1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getQiniuTokenWithData:(NSData*)data result:(void (^)(int result))result viewCtrl:(id)viewCtrl{
   
    //上传图片到七牛 //获取唯一的key  //先从服务器获取token值 //上传成功后，上传到自己的服务器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd_";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *key = [NSString stringWithFormat:@"%@%@", dateStr, [self uuid]];
    
     NSString *strUrl=[NSString stringWithFormat:@"/api/v1/pic/token/%@",key];
    
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
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
   
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *token = [responseObject mj_JSONString];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:data key:key token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSString *strUrl=@"/api/v1/sales/avatar";
                      NSDictionary *para = @{@"avatar":[NSString stringWithFormat:@"%@%@",@"http://photo2.hcroad.com/",key]};
                      [self post:strUrl param:para  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"%@",responseObject);
                          [Dialog simpleToast:@"头像更新成功!"];
                         result(1);
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
                          [Dialog simpleToast:@"头像更新失败!"];
                          NSLog(@"%@",error.description);
                          [viewCtrl hideHud];
                      }];
                      
                  } option:nil];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [Function maybeShowLoginCtrlWith:error];
        [viewCtrl hideHud];
         NSLog(@"%@",error.description);
    }];
   
    
}
- (void)modifyPW:(void (^)(int result))result oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword viewCtrl:(id)viewCtrl{
    
    NSString *strUrl=@"/api/v1/sales/newPwd";
    NSDictionary *param = @{@"oldPassword":oldPassword,@"newPassword":newPassword};
    [self post:strUrl param:param success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        [Dialog simpleToast:@"密码修改成功!"];
        result(1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [Dialog simpleToast:@"密码修改失败!"];
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];

}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
@end
