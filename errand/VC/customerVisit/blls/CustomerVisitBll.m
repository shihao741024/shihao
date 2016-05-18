//
//  CustomerVisitBll.m
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CustomerVisitBll.h"

@implementation CustomerVisitBll


-(void)getAllCustomerVisitData:(void (^)(int totalElements, NSArray *arr))successArr  pageIndex:(int)pageIndex visitDate:(NSString*)visitDate category:(NSNumber*)category  viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *urlStr = @"/api/v1/sale/visitplans/own";
//    NSDictionary *param = @{@"visitDate":visitDate,@"category":category,@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    NSDictionary *param = @{@"visitDate":visitDate};
    NSLog(@"%@", param);
    
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        
        for (NSDictionary *dic in array) {
            CustomerVisitModel *model = [[CustomerVisitModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
//        successArr(totalElements, dataArray);
        successArr((int)array.count, dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}

- (void)getCustomerVisitDetailData:(void (^)(VisitDetailModel *model))result visitID:(NSNumber*)visitID viewCtrl:(id)viewCtrl{
    NSString *urlStr = [NSString stringWithFormat:@"/api/v1/sale/visitplans/%@",visitID];
    [self get:urlStr param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *str = [responseObject mj_JSONString];
    NSLog(@"%@",str);
        VisitDetailModel *model = [[VisitDetailModel alloc]initWithDic:responseObject];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];

}

//
- (void)getAllVisitManagerData:(void(^)(NSArray *arr))sucessManager startDate:(NSString*)startDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *urlStr = @"/api/v1/sale/visitplans/own";
    NSDictionary *param = @{@"startDate":startDate,@"endDate":endDate};
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        sucessManager(dataArray);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
            [viewCtrl hideHud];
    }];

//    for(int i=0;i<PAGESIZE;i++){
//    VisitManagerModel *model=[VisitManagerModel new];
//    model.staffStr =@"13626262662(我)";
//    model.countStr=@"共18条";
//    [dataArray addObject:model];
//    }
//    double delayInSeconds =0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        sucessManager([dataArray copy]);
//    });
}


//新建用户拜访
-(void)addCustomerVisitData:(void (^)(CustomerVisitModel *model))result  Hospital:(NSNumber*)Hospital doctor:(NSNumber*)doctor production:(NSNumber*)production visitDate:(NSString*)visitDate  content:(NSString*)content category:(NSNumber*)category viewCtrl:(id)viewCtrl
{
    NSString *strUrl=@"/api/v1/sale/visitplans/create";
    NSDictionary *param=@{@"doctor":@{@"id":doctor},@"hospital":@{@"id":Hospital},@"production":@{@"id":production},@"visitDate":visitDate,@"content":content,@"category":category};
    NSLog(@"%@",param);
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        CustomerVisitModel *model = [[CustomerVisitModel alloc]initWithDic:responseObject[@"data"]];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)addSigninData:(void (^)(NSDictionary *result))result category:(int)category visitID:(NSNumber*)visitID longitude:(NSString*)longitude latitude:(NSString*)latitude name:(NSString*)name Message:(NSString *)Message viewCtrl:(id)viewCtrl{
    NSString *urlStr;
    // 0 到达签到 1 离开签到
    if (category == 0) {
        urlStr = [NSString stringWithFormat:@"/api/v1/sale/visitplans/arrive/%@",visitID];
    }else{
        urlStr = [NSString stringWithFormat:@"/api/v1/sale/visitplans/leave/%@",visitID];
    }
    NSDictionary *param = @{@"coordinate":@{@"longitude":longitude,@"latitude":latitude,@"name":name},@"message":Message};
    
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        result(responseObject[@"data"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
          NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

@end
