//
//  RequestUtil.h
//  errand
//
//  Created by gravel on 16/1/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUtil : NSObject

-(void)post:(NSString*)strUrl param:(NSDictionary*)param success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure;

-(void)post:(NSString*)strUrl param:(NSDictionary*)param headerParam:(NSDictionary *)headerParam success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure;

-(void)postHTTP:(NSString*)strUrl param:(NSDictionary*)param headerParam:(NSDictionary *)headerParam success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure;


-(void)loginHTTP:(NSString*)strUrl param:(NSDictionary*)param headerParam:(NSDictionary *)headerParam success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure;

- (void)get:(NSString *)strUrl param:(NSDictionary *)param headerParam:(NSDictionary *)hearderParam success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon))failure;

@end
