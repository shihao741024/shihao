//
//  SalesStaticsBll.m
//  errand
//
//  Created by gravel on 15/12/21.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SalesStatisticsBll.h"
#import "StatisticsCountModel.h"
@implementation SalesStatisticsBll

-(void)getAllsalesStatisticsData:(void (^)(NSArray *arr))successArr  pageIndex:(int)pageIndex  category:(int)category hospitalID:(NSNumber*)hospitalID productionID:(NSNumber*)productionID beginDate:(NSString *)beginDate endDate:(NSString *)endDate doctorId:(NSNumber *)doctorId viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *urlStr = @"/api/v1/sale/counts/own";
    NSDictionary *param;
    if ([hospitalID intValue] == -100) {
         param = @{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"category":[NSNumber numberWithInt:category]};
    }else{
        if (hospitalID == nil) {
            param = @{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"category":[NSNumber numberWithInt:category],@"production":@{@"id":productionID}};
        }else {
            param = @{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"category":[NSNumber numberWithInt:category],@"production":@{@"id":productionID},@"hospital":@{@"id":hospitalID}};
        }
        
    }
    NSMutableDictionary *parametert = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [parametert setObject:beginDate forKey:@"beginDate"];
    [parametert setObject:endDate forKey:@"endDate"];
    if (doctorId != nil) {
        if (![doctorId isKindOfClass:[NSNull class]]) {
            [parametert setObject:@{@"id": doctorId} forKey:@"doctor"];
        }
        
    }
    
//    NSLog(@"汇总para%@", parametert);
    [self post:urlStr param:parametert success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            SalesStatisticsModel *model = [[SalesStatisticsModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}

-(void)getAllsalesStatisticsData:(void (^)(NSArray *arr))successArr  pageIndex:(int)pageIndex category:(int)category dic:(NSDictionary *)dic viewCtrl:(id)viewCtrl
{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *urlStr = @"/api/v1/sale/counts/own";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [param setObject:[NSNumber numberWithInt:pageIndex] forKey:@"page"];
    [param setObject:[NSNumber numberWithInt:10] forKey:@"size"];
    [param setObject:[NSNumber numberWithInt:category] forKey:@"category"];    
    
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            SalesStatisticsModel *model = [[SalesStatisticsModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

//获得数据汇总里的点击数据
-(void)getSalesStatisticsCountData:(void (^)(NSArray *arr))successArr  pageIndex:(int)pageIndex  category:(int)category viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *urlStr = @"/api/v1/sale/counts/own";
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"category":[NSNumber numberWithInt:category]};
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            SalesStatisticsModel *model = [[SalesStatisticsModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}

-(void)addsalesStatisticsData:(void (^)(SalesStatisticsModel *model))result   ContactModel:(ContactModel*)contactModel doctorsModel:(DoctorsModel*)doctorsModel productionModel:(ProductionModel*)productionModel count:(NSString*)count pss:(NSString*)pss category:(NSNumber*)category upDate:(NSString*)upDate price:(NSString *)price viewCtrl:(id)viewCtrl
{

    NSString *strUrl=@"/api/v1/sale/counts/create";
    NSDictionary *param;
    if ([category intValue] == 0) {
//        到医院 有配送商
    param=@{@"hospital":@{@"id":contactModel.hospitalID,@"name":contactModel.hospitalName,@"address":@{@"provincial":contactModel.provincial,@"city":contactModel.city}},@"production":@{@"id":productionModel.productID,@"name":productionModel.name,@"specification":productionModel.specification},@"count":[NSNumber numberWithInt:[count intValue]],@"category":category,@"uploadDate":upDate,@"pss":pss};
    }else if ([category intValue] == 1){
        //到医生 无配送商
        param=@{@"hospital":@{@"id":contactModel.hospitalID,@"name":contactModel.hospitalName,@"address":@{@"provincial":contactModel.provincial,@"city":contactModel.city}},@"production":@{@"id":productionModel.productID,@"name":productionModel.name,@"specification":productionModel.specification},@"doctor":@{@"id":doctorsModel.doctorID,@"name":doctorsModel.name,@"office":doctorsModel.office},@"count":[NSNumber numberWithInt:[count intValue]],@"category":category,@"uploadDate":upDate};
    }else{
        //到医生 有配送商
        param=@{@"hospital":@{@"id":contactModel.hospitalID,@"name":contactModel.hospitalName,@"address":@{@"provincial":contactModel.provincial,@"city":contactModel.city}},@"production":@{@"id":productionModel.productID,@"name":productionModel.name,@"specification":productionModel.specification},@"doctor":@{@"id":doctorsModel.doctorID,@"name":doctorsModel.name,@"office":doctorsModel.office},@"count":[NSNumber numberWithInt:[count intValue]],@"category":category,@"uploadDate":upDate,@"pss":pss};
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:param];
    if (![price isEqualToString:@""]) {
        
        [parameter setObject:price forKey:@"price"];
    }
    
    [self post:strUrl param:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
         SalesStatisticsModel *model = [[SalesStatisticsModel alloc]initWithDic:responseObject[@"data"]];
         result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//         NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}

- (void)deletesalesStatisticsData:(void (^)(int result))result salesStatisticsID:(NSNumber*)salesStatisticsID viewCtrl:(id)viewCtrl{
     NSString *strUrl=[NSString stringWithFormat:@"/api/v1/sale/counts/delete/%@",salesStatisticsID];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        result(1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}


- (void)editsalesStatisticsData:(void (^)(SalesStatisticsModel *model))result salesStatisticsID:(NSNumber*)salesStatisticsID hospitalID:(NSNumber*)hospitalID hospitalName:(NSString*)hospitalName provincial:(NSString*)provincial city:(NSString*)city doctorID:(NSNumber*)doctorID doctorName:(NSString*)doctorName office:(NSString*)office productID:(NSNumber*)productID specification:(NSString *)specification productName:(NSString*)productName count:(NSString*)count pss:(NSString*)pss category:(NSNumber*)category upDate:(NSString*)upDate price:(NSString *)price packageUnit:(NSString *)packageUnit viewCtrl:(id)viewCtrl{
    NSString *strUrl=@"/api/v1/sale/counts/modify";
    NSDictionary *param;
    if ([category intValue] == 0) {
        //      到医院 有配送商
        param=@{@"id":salesStatisticsID,@"hospital":@{@"id":hospitalID,@"name":hospitalName,@"address":@{@"provincial":provincial,@"city":city}},@"production":@{@"id":productID,@"name":productName,@"specification":specification},@"count":[NSNumber numberWithInt:[count intValue]],@"category":category,@"uploadDate":upDate,@"pss":pss};
    }else if ([category intValue] == 1){
        //到医生 无配送商
    param=@{@"id":salesStatisticsID,@"hospital":@{@"id":hospitalID,@"name":hospitalName,@"address":@{@"provincial":provincial,@"city":city}},@"production":@{@"id":productID,@"name":productName,@"specification":specification},@"doctor":@{@"id":doctorID,@"name":doctorName,@"office":office},@"count":[NSNumber numberWithInt:[count intValue]],@"category":category,@"uploadDate":upDate};
    }else{
        //到医生 有配送商
    param=@{@"id":salesStatisticsID,@"hospital":@{@"id":hospitalID,@"name":hospitalName,@"address":@{@"provincial":provincial,@"city":city}},@"production":@{@"id":productID,@"name":productName,@"specification":specification},@"doctor":@{@"id":doctorID,@"name":doctorName,@"office":office},@"count":[NSNumber numberWithInt:[count intValue]],@"category":category,@"uploadDate":upDate,@"pss":pss};
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:param];
    if (![price isEqualToString:@""]) {
        [parameter setObject:price forKey:@"price"];
    }
    if (packageUnit) {
        NSMutableDictionary *production = [NSMutableDictionary dictionaryWithDictionary:parameter[@"production"]];
        if (production) {
            [production setObject:packageUnit forKey:@"packageUnit"];
            [parameter setObject:production forKey:@"production"];
        }
    }
   
    [self post:strUrl param:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        SalesStatisticsModel *model = [[SalesStatisticsModel alloc]initWithDic:responseObject[@"data"]];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];

}

//请求销售汇总数据
- (void)getSalesCountData:(void (^)(NSArray *arr))successArr category:(int)category beginDate:(NSString*)beginDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *urlStr = @"/api/v1/sale/counts/count";
    NSDictionary *param = @{@"category":[NSNumber numberWithInt:category],@"beginDate":beginDate,@"endDate":endDate};
    
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        for (NSArray *arr in responseObject) {
            StatisticsCountModel *model = [[StatisticsCountModel alloc]initWithArr:arr];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
@end
