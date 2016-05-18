//
//  AttendanceBll.m
//  errand
//
//  Created by gravel on 15/12/28.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AttendanceBll.h"

@implementation AttendanceBll

-(void)addAttendanceData:(void (^)(MyRecordModel *model))result  longitude:(NSString*)longitude latitude:(NSString*)latitude name:(NSString*)name  viewCtrl:(id)viewCtrl{
    NSString *strUrl=@"/api/v1/sale/kq/create";
    NSDictionary *param=@{@"coordinate":@{@"longitude":longitude,@"latitude":latitude,@"name":name}};
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        
        MyRecordModel *model = [[MyRecordModel alloc]initWithDic:responseObject[@"data"]];
        result(model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}


-(void)getTodayRecordData:(void (^)( NSArray  *array , int totalElements))result  type:(int)type pageIndex:(int)pageIndex startDate:(NSString *)startDate  endDate:(NSString*)endDate viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];

    NSDictionary *param=@{@"startDate":startDate,@"endDate":endDate,@"page":[NSNumber numberWithInt:pageIndex],@"size":@3};
//    NSLog(@"%@",param);
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/kq/own";
    }else{
        strUrl=@"/api/v1/sale/kq/xs";
    }
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        int totalElements = [responseObject[@"totalElements"] intValue];
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);

//        NSArray *array = responseObject[@"content"];
        NSArray *array = responseObject;
        for (NSDictionary *dic in array) {
            MyRecordModel *model = [[MyRecordModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
//        result(dataArray,totalElements);
        result(dataArray,0);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

//我的考勤和下属考勤页
-(void)getRecordData:(void (^)( NSArray  *array))result  type:(int)type pageIndex:(int)pageIndex startDate:(NSString *)startDate endDate:(NSString *)endDate viewCtrl:(id)viewCtrl{
    
    // 数据源

   NSMutableArray * dataArray = [NSMutableArray array];

//    NSDictionary *param=@{@"startDate":@"",@"endDate":@"",@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    NSDictionary *param=@{@"startDate": startDate, @"endDate": endDate};
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/kq/own";
    }else{
        strUrl=@"/api/v1/sale/kq/xs";
    }
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"我的考勤和下属考勤页%@", responseObject);
        

        // 做数据转换时中间数据源
        NSMutableArray *sourcesArray = [NSMutableArray array];
        
        NSArray *array = responseObject;
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        if (type == 0) {
            for (NSDictionary *dic in array) {
                MyRecordModel *model = [[MyRecordModel alloc]initWithDic:dic];
                [sourcesArray addObject:model];
            }
            while (sourcesArray.count) {
                NSMutableArray *itemArray = [NSMutableArray array];
                
                // 判断标志，能通过flagModel 的 flagTimeStr找到当天的日期YY，在sourcesArray中，和YY日期相同的可归为一类，放入同一个数组itemArray
                MyRecordModel *flagModel = sourcesArray[0];
                
                
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                for (int i = 0; i < sourcesArray.count; i++) {
                    MyRecordModel *model = sourcesArray[i];
                    
                    if ([model.flagTimeStr isEqualToString:flagModel.flagTimeStr]) {
                        [itemArray addObject:model];
                        [indexSet addIndex:i];
                    }
                    
                }
                [sourcesArray removeObjectsAtIndexes:indexSet];
                [dataArray addObject:itemArray];
            }
            
            
        }else{
            for (NSDictionary *dic in array) {
               StaffRecordModel  *model = [[StaffRecordModel alloc]initWithDic:dic];
                [sourcesArray addObject:model];
            }
            while (sourcesArray.count) {
                NSMutableArray *itemArray = [NSMutableArray array];
                
                // 判断标志，能通过flagModel 的 flagTimeStr找到当天的日期YY，在sourcesArray中，和YY日期相同的可归为一类，放入同一个数组itemArray
                StaffRecordModel *flagModel = sourcesArray[0];
                
                
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                for (int i = 0; i < sourcesArray.count; i++) {
                    StaffRecordModel *model = sourcesArray[i];
                    
                    if ([model.flagTimeStr isEqualToString:flagModel.flagTimeStr]) {
                        [itemArray addObject:model];
                        [indexSet addIndex:i];
                    }
                    
                }
                [sourcesArray removeObjectsAtIndexes:indexSet];
                [dataArray addObject:itemArray];
            }

        }
       
        result(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

-(void)getRealSearchRecordData:(void (^)( NSArray  *array))result  type:(int)type pageIndex:(int)pageIndex startDate:(NSString *)startDate  endDate:(NSString*)endDate  staffStr:(NSString*)staffStr viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
//    NSDictionary *param=@{@"startDate":startDate,@"endDate":endDate,@"saleTelephone":staffStr,@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    NSDictionary *param=@{@"startDate":startDate,@"endDate":endDate};
    
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/kq/own";
    }else{
        strUrl=@"/api/v1/sale/kq/xs";
    }
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 做数据转换时中间数据源
        NSMutableArray *sourcesArray = [NSMutableArray array];
        
        NSArray *array = responseObject;
        if (array.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        
        for (NSDictionary *dic in array) {
            if (type == 0) {
                MyRecordModel *model = [[MyRecordModel alloc]initWithDic:dic];
                [sourcesArray addObject:model];
                
               
            }else{
                StaffRecordModel *model = [[StaffRecordModel alloc]initWithDic:dic];
                [sourcesArray addObject:model];

            }
           
        }
        while (sourcesArray.count) {
            if (type == 0) {
                NSMutableArray *itemArray = [NSMutableArray array];
                
                // 判断标志，能通过flagModel 的 flagTimeStr找到当天的日期YY，在sourcesArray中，和YY日期相同的可归为一类，放入同一个数组itemArray
                
                MyRecordModel *flagModel = sourcesArray[0];
                
                //            MyRecordModel *modelTest = [[_dataArray lastObject] lastObject];
                
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                for (int i = 0; i < sourcesArray.count; i++) {
                    MyRecordModel *model = sourcesArray[i];
                    
                    if ([model.flagTimeStr isEqualToString:flagModel.flagTimeStr]) {
                        [itemArray addObject:model];
                        [indexSet addIndex:i];
                    }
                    
                }
                [sourcesArray removeObjectsAtIndexes:indexSet];
                [dataArray addObject:itemArray];
            }else{
                NSMutableArray *itemArray = [NSMutableArray array];
                
                // 判断标志，能通过flagModel 的 flagTimeStr找到当天的日期YY，在sourcesArray中，和YY日期相同的可归为一类，放入同一个数组itemArray
                
                StaffRecordModel *flagModel = sourcesArray[0];
                
                //            MyRecordModel *modelTest = [[_dataArray lastObject] lastObject];
                
                NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                for (int i = 0; i < sourcesArray.count; i++) {
                    StaffRecordModel *model = sourcesArray[i];
                    
                    if ([model.flagTimeStr isEqualToString:flagModel.flagTimeStr]) {
                        [itemArray addObject:model];
                        [indexSet addIndex:i];
                    }
                    
                }
                [sourcesArray removeObjectsAtIndexes:indexSet];
                [dataArray addObject:itemArray];
            }
        }
        result(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getStaffInfo:(void (^)( NSArray  *array))result pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *strUrl = @"/api/v1/sales/xs";
     NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            StaffInfoModel *model = [[StaffInfoModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        result(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
         NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
}
@end
