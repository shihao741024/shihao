//
//  ContactBll.m
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "ContactBll.h"
#import "ContactModel.h"
#import "DoctorModel.h"
#import "DoctorsModel.h"
@implementation ContactBll

//获取选择医生的数据
- (void)searchDoctorInHospital:(void (^)(NSArray *arr))successArr hospitalID:(NSNumber*)hospitalID  viewCtrl:(id)viewCtrl null:(void(^)())null{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl = [NSString stringWithFormat:@"/api/v1/hospitals/%@/doctors", hospitalID];
    
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //               NSString *str = [responseObject mj_JSONString];
        //               NSLog(@"%@",str);
        
        NSArray *array = [NSArray arrayWithArray:responseObject];
        if (array.count == 0) {
            null();
            return ;
        }
        
        NSMutableArray *sourceArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            DoctorsModel *model = [[DoctorsModel alloc]initWithDic:dic];
            [sourceArray addObject:model];
        }
        if (sourceArray.count == 0) {
            [Dialog simpleToast:@"没有数据"];
        }
        //按A到Z排序
        int i = 0;
        for ( ; i < 26; i ++) {
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int k = 0 ; k < sourceArray.count; k ++) {
                DoctorsModel *model = sourceArray[k];
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + i]]) {
                    [itemArray addObject:model];
                }
            }
            //           if (itemArray.count > 0) {
            [dataArray addObject:itemArray];
            //           }
            
        }
        //首字母不是26个字母的
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceArray];
        for (int j = 0 ; j < sourceArray.count; j++) {
            DoctorsModel * model = sourceArray[j];
            for (int m = 0; m < 26; m ++ ) {
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                    [tempArray removeObject:model];
                    break ;
                }
            }
        }
        //把首字母都换成#
        if (tempArray.count > 0 ) {
            for (DoctorsModel *model in tempArray) {
                model.firstCharactor = @"#";
            }
            [dataArray addObject:tempArray];
        }
        
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
    }];
}

//获取通讯录首页数据
- (void)getAllContactDataData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray = [NSMutableArray array];
//    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    NSString *strUrl=@"/api/v1/hospitals/list";
    NSString *hospitalUrl = [BASEURL stringByAppendingString:strUrl];
    [Function generalGetRequest:hospitalUrl infoDic:nil resultCB:^(id responseObject) {
//        int totalPages = [responseObject[@"totalPages"] intValue];
//        if (pageIndex > totalPages) {
//            [Dialog simpleToast:NoMoreData];
//        }
        NSMutableArray *sourceArray = [NSMutableArray array];
//        NSArray  *array = responseObject[@"content"];
        NSArray  *array = [NSArray arrayWithArray:responseObject];
        for (NSDictionary *dic in array) {
            ContactModel *model = [[ContactModel alloc] initWithDic:dic];
            [sourceArray addObject:model];
        }
        
        //按A到Z排序
        int i = 0;
        for ( ; i < 26; i ++) {
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int k = 0 ; k < sourceArray.count; k ++) {
                ContactModel *model = sourceArray[k];
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + i]]) {
                    [itemArray addObject:model];
                }
            }
            //            if (itemArray.count > 0) {
            [dataArray addObject:itemArray];
            //            }
            
        }
        //首字母不是26个字母的
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceArray];
        for (int j = 0 ; j < sourceArray.count; j++) {
            ContactModel * model = sourceArray[j];
            for (int m = 0; m < 26; m ++ ) {
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                    [tempArray removeObject:model];
                    break ;
                }
            }
        }
        //把首字母都换成#
        if (tempArray.count > 0 ) {
            for (ContactModel *model in tempArray) {
                model.firstCharactor = @"#";
            }
            [dataArray addObject:tempArray];
        }
        successArr([dataArray copy]);
    } errorCB:^(NSError *error) {
        [viewCtrl hideHud];
    }];
    
//    [self post:strUrl param:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
//        NSLog(@"%@",error.description);
//        
//    }];
    
}
//获取医院详情数据
- (void)getHospitalDetail:(void (^)(HospitalDetailModel *model))result hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl{
     NSString *strUrl=[NSString stringWithFormat:@"%@%@",@"/api/v1/hospitals/",hospitalID];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        HospitalDetailModel *model = [[HospitalDetailModel alloc]initWithDic:responseObject];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

//获取医院医生数据
- (void)getHospitalDoctor:(void (^)(NSArray *arr))successArr hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl{
    
    NSString *strUrl=[NSString stringWithFormat:@"/api/v1/hospitals/%@/doctors",hospitalID];
    NSDictionary *headerParam=@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"Accept": @"application/json",@"Content-Type":@"application/json"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSArray *keys=[headerParam allKeys];
    for(int i=0;i<[headerParam allKeys].count;i++){
        NSString *val=headerParam[[keys objectAtIndex:i]];
        NSString *key=[keys objectAtIndex:i];
        [manager.requestSerializer setValue:val forHTTPHeaderField:key];
    }
    if([strUrl rangeOfString:@"http"].location==NSNotFound){
        strUrl=[BASEURL stringByAppendingString:strUrl];
    }
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

//获取选择医院的数据
- (void)gethospitalsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl=[NSString stringWithFormat:@"/api/v1/select/%@/%@",[user objectForKey:@"userID"],productID];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        NSMutableArray *sourceArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            ContactModel *model = [[ContactModel alloc]initWithDic:dic];
            [sourceArray addObject:model];
        }
        if (sourceArray.count == 0) {
            [Dialog simpleToast:@"没有数据"];
        }

        //按A到Z排序
        int i = 0;
        for ( ; i < 26; i ++) {
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int k = 0 ; k < sourceArray.count; k ++) {
                ContactModel *model = sourceArray[k];
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + i]]) {
                    [itemArray addObject:model];
                }
            }
            //            if (itemArray.count > 0) {
            [dataArray addObject:itemArray];
            //            }
            
        }
        //首字母不是26个字母的
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceArray];
        for (int j = 0 ; j < sourceArray.count; j++) {
            ContactModel * model = sourceArray[j];
            for (int m = 0; m < 26; m ++ ) {
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                    [tempArray removeObject:model];
                    break ;
                }
            }
        }
        //把首字母都换成#
        if (tempArray.count > 0 ) {
            for (ContactModel *model in tempArray) {
                model.firstCharactor = @"#";
            }
            [dataArray addObject:tempArray];
        }
        
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@", error);
        [viewCtrl hideHud];
        [Function maybeShowLoginCtrlWith:error];
    }];

}

//获取选择医生的数据
- (void)getChoosedoctorsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID hospitalID:(NSNumber*)hospitalID  viewCtrl:(id)viewCtrl null:(void(^)())null{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl=[NSString stringWithFormat:@"/api/v1/select/%@/%@/%@",[user objectForKey:@"userID"],productID,hospitalID];
   [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               NSString *str = [responseObject mj_JSONString];
//               NSLog(@"%@",str);
       NSArray *array = [NSArray arrayWithArray:responseObject];
       if (array.count == 0) {
           null();
           return ;
       }
       
       NSMutableArray *sourceArray = [NSMutableArray array];
       for (NSDictionary *dic in responseObject) {
           DoctorsModel *model = [[DoctorsModel alloc]initWithDic:dic];
           [sourceArray addObject:model];
       }
       if (sourceArray.count == 0) {
           [Dialog simpleToast:@"没有数据"];
       }
       //按A到Z排序
       int i = 0;
       for ( ; i < 26; i ++) {
           NSMutableArray *itemArray = [NSMutableArray array];
           for (int k = 0 ; k < sourceArray.count; k ++) {
               DoctorsModel *model = sourceArray[k];
               if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + i]]) {
                   [itemArray addObject:model];
               }
           }
//           if (itemArray.count > 0) {
               [dataArray addObject:itemArray];
//           }
           
       }
       //首字母不是26个字母的
       NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceArray];
       for (int j = 0 ; j < sourceArray.count; j++) {
           DoctorsModel * model = sourceArray[j];
           for (int m = 0; m < 26; m ++ ) {
               if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                   [tempArray removeObject:model];
                   break ;
               }
           }
       }
       //把首字母都换成#
       if (tempArray.count > 0 ) {
           for (DoctorsModel *model in tempArray) {
               model.firstCharactor = @"#";
           }
           [dataArray addObject:tempArray];
       }
       
       successArr(dataArray);
   } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
       [viewCtrl hideHud];
   }];
}

//获取选择医院的数据, type == 7
- (void)getTypeHospitalsData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl= @"/api/v1/hospitals/list";
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *str = [responseObject mj_JSONString];
        //        NSLog(@"%@",str);
        NSMutableArray *sourceArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            ContactModel *model = [[ContactModel alloc]initWithDic:dic];
            [sourceArray addObject:model];
        }
        if (sourceArray.count == 0) {
            [Dialog simpleToast:@"没有数据"];
        }
        
        //按A到Z排序
        int i = 0;
        for ( ; i < 26; i ++) {
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int k = 0 ; k < sourceArray.count; k ++) {
                ContactModel *model = sourceArray[k];
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + i]]) {
                    [itemArray addObject:model];
                }
            }
            //            if (itemArray.count > 0) {
            [dataArray addObject:itemArray];
            //            }
            
        }
        //首字母不是26个字母的
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceArray];
        for (int j = 0 ; j < sourceArray.count; j++) {
            ContactModel * model = sourceArray[j];
            for (int m = 0; m < 26; m ++ ) {
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                    [tempArray removeObject:model];
                    break ;
                }
            }
        }
        //把首字母都换成#
        if (tempArray.count > 0 ) {
            for (ContactModel *model in tempArray) {
                model.firstCharactor = @"#";
            }
            [dataArray addObject:tempArray];
        }
        
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@", error);
        [viewCtrl hideHud];
        [Function maybeShowLoginCtrlWith:error];
    }];
    
}

@end
