//
//  TaskBll.m
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskBll.h"

@implementation TaskBll

/**
 *  获取我的任务交办列表
 *
 *  @param successArr 回调数组
 *  @param type       类型  0我提交的  1我处理的
 *  @param pageIndex  页索引
 *  @param pageSize   页容量
 */

-(void)getAllTaskData:(void (^)(NSArray *arr))successArr type:(int)type  pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};//[NSNumber numberWithInt:pageIndex]
    NSLog(@"%@",param);
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/task/assign";
    }else{
        strUrl=@"/api/v1/sale/task/to2";
    }
    
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str1= [responseObject mj_JSONString];
//        NSLog(str1);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray  *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            TaskModel *model = [[TaskModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)searchTaskDataWithTitle:(NSString *)title{
    
}
-(void)addTaskData:(void (^)(NSArray<TaskModel *> *modelArray))result  to:(NSNumber*)to name:(NSString *)name telephone:telephone priority:(int)priority content:(NSString*)content title:(NSString*)title planCompleteDate:(NSString*)planCompleteDate viewCtrl:(id)viewCtrl tos:(NSArray *)tos
{
    NSString *strUrl=@"/api/v1/sale/task/create";
//    NSDictionary *param=@{@"to":@{@"id":to,@"name":name,@"telephone":telephone},@"priority":[NSNumber numberWithInt:priority],@"content":content,@"title":title,@"planCompleteDate":planCompleteDate};
    NSDictionary *param=@{@"tos":tos,@"priority":[NSNumber numberWithInt:priority],@"content":content,@"title":title,@"planCompleteDate":planCompleteDate};
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        NSArray *dataArray = responseObject[@"data"];
        NSMutableArray *moArray = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            TaskModel *model = [[TaskModel alloc]initWithDic:dic];
            [moArray addObject:model];
        }
        result(moArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

-(void)getDetailTaskData:(void (^)(TaskDetailModel *model))result  taskID:(NSNumber*)taskID viewCtrl:(id)viewCtrl
{
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",@"/api/v1/sale/task/",taskID];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        TaskDetailModel *model = [[TaskDetailModel alloc]initWithDic:responseObject];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

// 接收是0 拒绝是1 撤销是2 完成是3
- (void)dealTaskData:(void(^)(int result))result  taskID:(NSNumber*)taskID dealType:(int)dealType feedback:(NSString *)feedback viewCtrl:(id)viewCtrl{
    
    NSString *subUrl = [[NSString alloc]init];
    if (dealType == 0) {
        subUrl = @"/api/v1/sale/task/accept/";
    }else if (dealType == 1){
         subUrl = @"/api/v1/sale/task/reject/";
    }else if (dealType == 2){
         subUrl = @"/api/v1/sale/task/cancel/";
    }else if (dealType == 3){
         subUrl = @"/api/v1/sale/task/complete/";
    }else{
        subUrl = @"/api/v1/sale/task/remind/";
    }
     NSString *strUrl=[NSString stringWithFormat:@"%@%@",subUrl,taskID];
    if (feedback) {
        NSDictionary *param = @{@"feedback":feedback};
        [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *str = [responseObject mj_JSONString];
//            NSLog(@"%@",str);
            result(1);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
            NSLog(@"%@",error.description);
            [viewCtrl hideHud];
        }];
    }else{
        [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *str = [responseObject mj_JSONString];
//            NSLog(@"%@",str);
            result(1);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
            NSLog(@"%@",error.description);
            [viewCtrl hideHud];
        }];
    }
    
    
 
}
- (void)getTaskSearchData:(void (^)(NSArray *arr))successArr  type:(int)type  pageIndex:(int)pageIndex title:(NSString *)title content:(NSString *)content category:(NSNumber*)category  beingDate:(NSString *)beingDate  endDate:(NSString *)endDate  to:(NSNumber*)to viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/task/assign";
    }else{
        strUrl=@"/api/v1/sale/task/to2";
    }
    
    NSDictionary *param;
    if ([category isEqual:ImpossibleNSNumber]) {
        if ([to isEqual:ImpossibleNSNumber]) {
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"title":title, @"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10};

        }else{
            if (type == 0) {
                param =@{@"page":[NSNumber numberWithInt:pageIndex],@"title":title, @"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"to":@{@"id":to}};
            }else{
                param =@{@"page":[NSNumber numberWithInt:pageIndex],@"title":title, @"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"belongTo":@{@"id":to}};
            }
//            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"title":title, @"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"belongTo":@{@"id":to}};

        }
        
    }else{
        if ([to isEqual:ImpossibleNSNumber]) {
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"title":title, @"content":content,@"status":category,@"beginDate":beingDate,@"endDate":endDate,@"size":@10};
            
        }else{
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"title":title, @"content":content,@"status":category,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"to":@{@"id":to}};
            
        }
    }
    NSLog(@"getTaskSearchData--%@",param);
    
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //                NSString *str = [responseObject mj_JSONString];
        //                NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            TaskModel *model = [[TaskModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
    
    
}
@end
