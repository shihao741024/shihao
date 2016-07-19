//
//  ContactsBll.m
//  errand
//
//  Created by 医路同行Mac1 on 16/6/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ContactsBll.h"
#import "ContactModel.h"
#import "DoctorModel.h"
#import "DoctorsModel.h"

@implementation ContactsBll
//获取通讯录首页数据
- (void)getAllContactsData:(void (^)(NSArray *))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSString *strUrl=@"/api/v1/hospitals/list/v2";
    NSString *hospitalUrl = [BASEURL stringByAppendingString:strUrl];
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    [self post:hospitalUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray  *array = responseObject[@"content"];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in array) {
            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
    }];
}
//获取搜索医生的结果
- (void)getSearchDoctorsResult:(void (^)(NSArray *))successArr pageIndex:(int)pageIndex keywords:(NSString *)keywords kind:(NSString *)kind department:(NSString *)department viewCtrl:(id)viewCtrl {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSString *strUrl = @"/api/v1/doctors/list/v2";
    NSString *doctorsUrl = [BASEURL stringByAppendingString:strUrl];
//    NSDictionary *param = @{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"doctorName":keywords,@"office":department};
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"doctorName":keywords,@"office":department}];

    [self post:doctorsUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray  *array = responseObject[@"content"];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in array) {
            DoctorModel *model = [[DoctorModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
    }];
}

//获取搜索医院的结果
- (void)getSearchHospitalsResult:(void (^)(NSArray *))successArr pageIndex:(int)pageIndex keywords:(NSString *)keywords kind:(NSString *)kind hospitalrank:(NSString *)hospitalrank province:(NSString *)province city:(NSString *)city viewCtrl:(id)viewCtrl {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSString *strUrl = @"/api/v1/hospitals/list/v2";
    NSString *hospitalUrl = [BASEURL stringByAppendingString:strUrl];
//    NSDictionary *param = @{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"hospitalName":keywords,@"hospitalLevel":hospitalrank,@"province":province,@"city":city,@"isShow":@1};
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"hospitalName":keywords,@"hospitalLevel":hospitalrank,@"province":province,@"city":city}];
    [self post:hospitalUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray  *array = responseObject[@"content"];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in array) {
            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
    }];
}


/*========华丽的分割线========*/

//获取医院详情数据
- (void)getHospitalDetail:(void (^)(HospitalDetailModel *model))result hospitalID:(NSNumber*)hospitalID pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",@"/api/v1/hospitals/",hospitalID];
    
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HospitalDetailModel *model = [[HospitalDetailModel alloc]initWithDic:responseObject];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
//获取选择医院的数据
- (void)gethospitalsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *strUrl=@"/api/v1/hospitals/list/v2";

    NSString *hospitalUrl = [BASEURL stringByAppendingString:strUrl];
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"productionId":productID};
    [self post:hospitalUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray  *array = responseObject[@"content"];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in array) {
            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
        [Function maybeShowLoginCtrlWith:error];
    }];
    
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *strUrl=[NSString stringWithFormat:@"/api/v1/select/%@/%@",[user objectForKey:@"userID"],productID];
//    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
//    [self get:strUrl param:param headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray  *array = responseObject;
//        if (array.count == 0) {
//            [Dialog simpleToast:NoMoreData];
//        }
//        for (NSDictionary *dic in array) {
//            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
//            [dataArray addObject:model];
//        }
//        successArr(dataArray);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@", error);
//        [viewCtrl hideHud];
//        [Function maybeShowLoginCtrlWith:error];
//    }];
    
}
//获取选择医院的数据, type == 7
- (void)getTypeHospitalsData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *strUrl=@"/api/v1/hospitals/list/v2";
    NSString *hospitalUrl = [BASEURL stringByAppendingString:strUrl];
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    [self post:hospitalUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray  *array = responseObject[@"content"];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in array) {
            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
        [Function maybeShowLoginCtrlWith:error];
    }];
    
//    NSString *strUrl= @"/api/v1/hospitals/list";
//    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
//    [self get:strUrl param:param headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray  *array = responseObject;
//        if (array.count == 0) {
//            [Dialog simpleToast:NoMoreData];
//        }
//        for (NSDictionary *dic in array) {
//            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
//            [dataArray addObject:model];
//        }
//        successArr(dataArray);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
//        NSLog(@"%@", error);
//        [viewCtrl hideHud];
//        [Function maybeShowLoginCtrlWith:error];
//    }];

}


//竞品医院查询 type == 5
- (void)getCompetitionHospitalData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSString *strUrl= @"/api/v1/hospitals/list/v2";
    NSString *competeUrl = [BASEURL stringByAppendingString:strUrl];
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};//,@"productionType":@1
    [self post:competeUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray  *array = responseObject[@"content"];
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in array) {
            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}


@end
