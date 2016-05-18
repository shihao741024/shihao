//
//  CommonBll.m
//  errand
//
//  Created by gravel on 16/2/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CommonBll.h"
#import "ProductionModel.h"
#import "DistriModel.h"
#import "ContactModel.h"
#import "DoctorsModel.h"
@implementation CommonBll

- (void)getProductionsData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strUrl=[NSString stringWithFormat:@"/api/v1/select/%@",[user objectForKey:@"userID"]];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        for (NSDictionary *dic in responseObject) {
            NSLog(@"%@", responseObject);
            ProductionModel *model = [[ProductionModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
        if (dataArray.count == 0) {
            [Dialog simpleToast:@"没有数据"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
    }];
}

//查看配送商
- (void)getDistributionData:(void (^)(NSArray *arr))successArr Province:(NSString*)province City:(NSString*)city viewCtrl:(id)viewCtrl{
     NSMutableArray *dataArray = [NSMutableArray array];
    NSString *strUrl=@"/api/v1/distribution";
    NSDictionary *param =@{@"province":province,@"city":city};
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        for (NSDictionary *dic in responseObject) {
            DistriModel *model = [[DistriModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];

}

//自动补全配送商
- (void)getdistriData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *strUrl=@"/api/v1/distri";
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        for (NSDictionary *dic in responseObject) {
           DistriModel  *model = [[DistriModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}

//竞品
- (void)getCompetitionProductionData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *strUrl=@"/api/v1/productions/competition";
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *str = [responseObject mj_JSONString];
                NSLog(@"%@",str);
        for (NSDictionary *dic in responseObject) {
            ProductionModel  *model = [[ProductionModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];

}

- (void)getCompetitionHospitalData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *strUrl= [NSString stringWithFormat:@"/api/v1/select/%@/competition",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
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
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}
- (void)getCompetitionDoctorsData:(void (^)(NSArray *arr))successArr  hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *strUrl= [NSString stringWithFormat:@"/api/v1/select/%@/competition/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],hospitalID];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *str = [responseObject mj_JSONString];
        //        NSLog(@"%@",str);
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
            NSLog(@"%@",error.description);
        [viewCtrl hideHud];
        }];
    
}

@end
