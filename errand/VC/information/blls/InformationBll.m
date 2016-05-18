//
//  InformationBll.m
//  errand
//
//  Created by wjjxx on 16/3/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "InformationBll.h"
#import "InformationModel.h"
@implementation InformationBll


-(void)getInformationData:(void (^)( NSArray *arr))successArr  pageIndex:(int)pageIndex category:(NSNumber*)category viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *urlStr = @"/api/v1/notice";
    //报警1   OPEN2   正常消息0
    NSDictionary *param = @{@"category":category,@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    [self post:urlStr param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        for (NSDictionary *dic in responseObject[@"content"]) {
            InformationModel *model = [[InformationModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

-(void)deleteInformationData:(void (^)( int result))result ids:(NSArray*)ids viewCtrl:(id)viewCtrl{
    NSString *urlStr = @"/api/v1/notice/delete";
   
    [self post:urlStr param:ids success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
//        
        result(1);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
@end
