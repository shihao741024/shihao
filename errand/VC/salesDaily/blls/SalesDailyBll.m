//
//  SalesDailyBll.m
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SalesDailyBll.h"
#import "QiniuSDK.h"
#import "StaffModel.h"
#import "Node.h"
#import "AtModel.h"
#import "CommentMeModel.h"
#import "ReportCountModel.h"
@implementation SalesDailyBll

/**
 *  获取统计列表
 *
 *  @param successArr 回调数组
 *  @param pageIndex  页索引
 */
- (void)getAllStatisticsData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex category:(NSNumber*)category  viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    strUrl = @"/api/v1/report";
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};//,@"category":category
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
- (void)getHallSearchData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex category:(NSNumber*)category content:(NSString*)content beingDate:(NSString *)beingDate  endDate:(NSString *)endDate  oids:(NSArray *)oids ids:(NSArray*)ids viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    strUrl = @"/api/v1/report";
    NSDictionary *param;
    if ([category isEqual:@-1]) {
        if (oids.count == 0 && ids.count == 0 ) {
             param =@{@"page":[NSNumber numberWithInt:pageIndex],@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10};
        }else if (oids.count == 0){
             param =@{@"page":[NSNumber numberWithInt:pageIndex],@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"ids":ids};
        }else if (ids.count == 0){
             param =@{@"page":[NSNumber numberWithInt:pageIndex],@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"oids":oids};
        }
        else{
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"oids":oids,@"ids":ids};
        }

    }else{
        if (oids.count == 0 && ids.count == 0 ) {
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"category":category,@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10};
        }else if (oids.count == 0){
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"category":category,@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"ids":ids};
        }else if (ids.count == 0){
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"category":category,@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"oids":oids};
        }
        else{
            param =@{@"page":[NSNumber numberWithInt:pageIndex],@"category":category,@"content":content,@"beginDate":beingDate,@"endDate":endDate,@"size":@10,@"oids":oids,@"ids":ids};
        }

    }
    
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *str = [responseObject mj_JSONString];
//                NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];

    
}
- (void)getAtmeData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    strUrl = @"/api/v1/report/atme";
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};//,@"category":category
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *str = [responseObject mj_JSONString];
        //        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getCommentmeData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex type:(int)type viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    if (type == 0) {
       strUrl = @"/api/v1/report/comment_me";
    }else{
        strUrl = @"/api/v1/report/comment";
    }
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};//,@"category":category
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            CommentMeModel *model = [[CommentMeModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getReportDetailData:(void (^)(SalesDailyModel *model))result reportID:(NSNumber *)reportID viewCtrl:(id)viewCtrl{
     NSString *strUrl=[NSString stringWithFormat:@"/api/v1/report/%@",reportID];
    
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
       SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:responseObject];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
//先上传图片，成功后发表动态
- (void)getQiniuTokenWithImgArray:(NSArray*)ImgArray  successArrBlock:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    //上传图片到七牛 //key  //先从服务器获取token值 //上传成功后，上传到自己的服务器

    for (NSData *ImgData in ImgArray) {
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
        
        [Function configRequestHeader:manager];
        
            [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                //先从服务器获取token值
                NSString *token = [responseObject mj_JSONString];
                
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                [upManager putData:ImgData key:key token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@",@"http://photo2.hcroad.com/",key];
                              [dataArray addObject:imgUrlStr];
                              if (dataArray.count == ImgArray.count) {
                                  //把动态上传
                                  successArr(dataArray);
                              }
                          } option:nil];
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                NSLog(@"%@",error.description);
                [viewCtrl hideHud];
                
            }];
     
    }

}

//删除日报
- (void)deleteReport:(void (^)(int  result))result reportID:(NSNumber*)reportID viewCtrl:(id)viewCtrl{
    NSString *addstrUrl = [NSString stringWithFormat:@"/api/v1/report/delete/%@",reportID];
    
    [self get:addstrUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        result(1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)addsalesDailyData:(void (^)(SalesDailyModel *model))result content:(NSString*)content selectStaffArray:(NSArray *)selectStaffArry selectDepartmentArray:(NSArray *)selectDepartmentArray category:(NSNumber*)category sendingPlace:(NSString *)sendingPlace open:(NSNumber*)open pics:(NSArray*)pics viewCtrl:(id)viewCtrl organization:(NSString *)organization organID:(NSNumber *)organID{
    
    NSString *addstrUrl = @"/api/v1/report/create";
   
    NSString *deviceName = [UIDevice currentDevice].model;
    
    //仅自己和领导可见
    if ([open isEqual:@0]) {
        //获取领导的id
         __block NSString *contentStr = content;
        NSString *strUrl = @"/api/v1/sales/leader";
        [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSString *str = [responseObject mj_JSONString];
            //        NSLog(@"%@",str);
            for (NSDictionary *dic in responseObject) {
                AtModel *atModel = [[AtModel alloc]initWithDic:dic];
                NSRange range = [contentStr rangeOfString:atModel.name];
                if (range.location == NSNotFound) {
                    contentStr = [NSString stringWithFormat:@"%@ @%@",contentStr,atModel.name];
                }
            }
//            for (StaffModel *staffModel in selectStaffArry) {
//                contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"@%@",staffModel.staffName],staffModel.ID];
//            }
//            for (Node *node in selectDepartmentArray) {
//                contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"#%@",node.name],[NSNumber numberWithInt:node.nodeId]];
//            }
            
            
            for (NSDictionary *dic in responseObject) {
                AtModel *atModel = [[AtModel alloc]initWithDic:dic];
                NSRange range = [contentStr rangeOfString:atModel.name];
                if (range.location == NSNotFound) {
                    contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"@%@",atModel.name],atModel.ID];
                }
            }
            for (StaffModel *staffModel in selectStaffArry) {
                contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"@%@",staffModel.staffName],staffModel.ID];
            }
            for (Node *node in selectDepartmentArray) {
                contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"#%@",node.name],[NSNumber numberWithInt:node.nodeId]];
            }
            
            //成功后再发表日报
            NSDictionary *param=@{@"content":contentStr,@"category":category,@"deviceName":deviceName,@"sendingPlace":sendingPlace,@"open":@0,@"pics":pics};
            [self post:addstrUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        NSString *str = [responseObject mj_JSONString];
//                        NSLog(@"%@",str);
                //que
                SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:responseObject[@"data"]];
                result(model);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
                NSLog(@"%@",error.description);
                [viewCtrl hideHud];
            }];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
            NSLog(@"%@",error.description);
            [viewCtrl hideHud];
        }];
        
    }else if ([open isEqual:@1]){
//        所在部门和领导可见
        __block NSString *contentStr = content;
        NSString *strUrl = @"/api/v1/sales/leader";
        [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            for (NSDictionary *dic in responseObject) {
                AtModel *atModel = [[AtModel alloc]initWithDic:dic];
                NSRange range = [contentStr rangeOfString:atModel.name];
                if (range.location == NSNotFound) {
                    contentStr = [NSString stringWithFormat:@"%@ @%@",contentStr,atModel.name];
                }
            }
            
            for (NSDictionary *dic in responseObject) {
                AtModel *atModel = [[AtModel alloc]initWithDic:dic];
                NSRange range = [contentStr rangeOfString:atModel.name];
                if (range.location == NSNotFound) {
                    contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"@%@",atModel.name],atModel.ID];
                }
            }
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            for (StaffModel *staffModel in selectStaffArry) {
                contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"@%@",staffModel.staffName],staffModel.ID];
            }
            for (Node *node in selectDepartmentArray) {
                contentStr = [NSString stringWithFormat:@"%@ {%@:%@}",contentStr,[NSString stringWithFormat:@"#%@",node.name],[NSNumber numberWithInt:node.nodeId]];
            }
            contentStr = [NSString stringWithFormat:@"%@ #%@ {%@:%@}",contentStr,[user objectForKey:@"organizationName"],[NSString stringWithFormat:@"#%@",[user objectForKey:@"organizationName"]],[user objectForKey:@"organizationID"]];
            
            if (organization) {
                NSRange orgRange = [contentStr rangeOfString:organization];
                if (orgRange.location == NSNotFound) {
                    
                }
            }
            //成功后再发表日报
            NSDictionary *param=@{@"content":contentStr,@"category":category,@"deviceName":deviceName,@"sendingPlace":sendingPlace,@"open":@0,@"pics":pics};
            [self post:addstrUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //        NSString *str = [responseObject mj_JSONString];
                //        NSLog(@"%@",str);
                SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:responseObject[@"data"]];
                result(model);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
                NSLog(@"%@",error.description);
                [viewCtrl hideHud];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
            NSLog(@"%@",error.description);
            [viewCtrl hideHud];
        }];
        
        
    }else{
        for (StaffModel *staffModel in selectStaffArry) {
            content = [NSString stringWithFormat:@"%@ {%@:%@}",content,[NSString stringWithFormat:@"@%@",staffModel.staffName],staffModel.ID];
        }
        for (Node *node in selectDepartmentArray) {
            content = [NSString stringWithFormat:@"%@ {%@:%@}",content,[NSString stringWithFormat:@"#%@",node.name],[NSNumber numberWithInt:node.nodeId]];
        }
      //成功后再发表日报
        NSDictionary *param=@{@"content":content,@"category":category,@"deviceName":deviceName,@"sendingPlace":sendingPlace,@"open":@1,@"pics":pics};
        [self post:addstrUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSString *str = [responseObject mj_JSONString];
            //        NSLog(@"%@",str);
            //que
            SalesDailyModel *model = [[SalesDailyModel alloc]initWithDic:responseObject[@"data"]];
            result(model);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
            NSLog(@"%@",error.description);
            [viewCtrl hideHud];
        }];

    }
}


- (void)createCommentData:(void (^)(CommentModel *model))result sid:(NSNumber*)sid sname:(NSString*)sname tid:(NSNumber*)tid tname:(NSString*)tname reportID:(NSNumber *)reportID  content:(NSString *)content selectStaffArray:(NSArray *)selectStaffArry selectDepartmentArray:(NSArray *)selectDepartmentArray viewCtrl:(id)viewCtrl{
    //获取用户头像
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *avatar = [user objectForKey:@"avatar"];
    
    
    for (StaffModel *staffModel in selectStaffArry) {
        content = [NSString stringWithFormat:@"%@ {%@:%@}",content,[NSString stringWithFormat:@"@%@",staffModel.staffName],staffModel.ID];
    }
    for (Node *node in selectDepartmentArray) {
        content = [NSString stringWithFormat:@"%@ {%@:%@}",content,[NSString stringWithFormat:@"#%@",node.name],[NSNumber numberWithInt:node.nodeId]];
    }

    NSString *strUrl = @"/api/v1/report/comment/create";
    NSDictionary *param;
    if ([tname isEqualToString:@""]) {
         param = @{@"sid":sid,@"sname":sname,@"report":@{@"id":reportID},@"content":content};
    }else{
         param = @{@"sid":sid,@"sname":sname,@"tid":tid,@"tname":tname,@"report":@{@"id":reportID},@"content":content};
    }
//    NSLog(@"%@",param);
   
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *str = [responseObject mj_JSONString];
//                NSLog(@"%@",str);
        CommentModel *commentModel = [[CommentModel alloc]initWithDic:responseObject[@"data"]];
        result(commentModel);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getReportCountData:(void (^)(NSArray *arr))successArr beingDate:(NSString *)beingDate  oids:(NSArray *)oids ids:(NSArray*)ids viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
   NSString *urlStr = @"/api/v1/report/count";
    NSDictionary *param ;
//    if (oids == nil) {
//         param = @{@"beginDate":beingDate};
//    }else{
//        if (oids.count == 0 && ids.count == 0 ) {
//             param = @{@"beginDate":beingDate};
//        }else if (oids.count == 0){
//             param = @{@"beginDate":beingDate,@"ids":ids};
//        }else if (ids.count == 0){
//             param = @{@"beginDate":beingDate,@"oids":oids};
//        }
//        else{
//             param = @{@"beginDate":beingDate,@"oids":oids,@"ids":ids};
//        }
//        
//    }
    if (ids == nil) {
        param = @{@"beginDate":beingDate};
    }else {
        if (ids.count == 0) {
            param = @{@"beginDate":beingDate};
        }else {
            param = @{@"beginDate":beingDate,@"ids":ids};
        }
    }
    
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        
        // 做数据转换时中间数据源
        NSMutableArray *sourcesArray = [NSMutableArray array];

        for (NSDictionary *dic in responseObject) {
            ReportCountModel *model = [[ReportCountModel alloc]initWithDic:dic];
            [sourcesArray addObject:model];
        }
        while (sourcesArray.count) {
            NSMutableArray *itemArray = [NSMutableArray array];
            
            // 判断标志，能通过flagModel 的 flagTimeStr找到相同id可归为一类，放入同一个数组itemArray
            ReportCountModel *flagModel = sourcesArray[0];
   
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (int i = 0; i < sourcesArray.count; i++) {
                ReportCountModel *model = sourcesArray[i];
                
                if ([model.countID isEqual:flagModel.countID]) {
                    [itemArray addObject:model];
                    [indexSet addIndex:i];
                }
            }
            [sourcesArray removeObjectsAtIndexes:indexSet];
            [dataArray addObject:itemArray];
        }

        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}


- (void)getMyMemberData:(void (^)(NSArray *arr))successArr  viewCtrl:(id)viewCtrl null:(void(^)())null{
    NSString *urlStr = @"/api/v1/sale/myMember";
    [self get:urlStr param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        NSArray *rootArray = [NSArray arrayWithArray:responseObject];
        if ([rootArray count] == 0) {
            null();
            return ;
        }
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        NSMutableArray *sourceArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            StaffModel *model = [[StaffModel alloc]initWithDic:dic];
            [sourceArray addObject:model];
        }
        //按A到Z排序
        int i = 0;
        for ( ; i < 26; i ++) {
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int k = 0 ; k < sourceArray.count; k ++) {
                StaffModel *model = sourceArray[k];
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
            StaffModel * model = sourceArray[j];
            for (int m = 0; m < 26; m ++ ) {
                if ([model.firstCharactor isEqualToString:[NSString stringWithFormat:@"%c",65 + m]]) {
                    [tempArray removeObject:model];
                    break ;
                }
            }
        }
        //把首字母都换成#
        if (tempArray.count > 0 ) {
            for (StaffModel *model in tempArray) {
                model.firstCharactor = @"#";
            }
            [dataArray addObject:tempArray];
        }
        successArr([dataArray copy]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)getMyTreeData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl{
    NSString *urlStr = @"/api/v1/org/myTree";
    [self get:urlStr param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        // 根节点model
        Node *model = [[Node alloc] init];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[model nodesArrayWithTreeDic:responseObject]];
        
        //让下一级自动展开
        for (Node *node in dataArray) {
            if ( node.depth == 1) {
                node.expand = YES;
            }
        }
        
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
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
