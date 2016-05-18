//
//  MissionBll.m
//  errand
//
//  Created by gravel on 15/12/11.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionBll.h"


@implementation MissionBll

/**
 *  获取我的出差管理列表
 *
 *  @param successArr 回调数组
 *  @param type       类型  0我提交的  1我处理的
 *  @param pageIndex  页索引
 */
-(void)getAllMissionData:(void (^)(NSArray *arr))successArr type:(int)type  pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl{
     NSMutableArray *dataArray = [NSMutableArray array];
    NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/trip/own";
    }else{
        strUrl=@"/api/v1/sale/trip/operate";
    }
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//              NSString *str = [responseObject mj_JSONString];
//              NSLog(@"%@",str);
        NSArray  *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            MissionModel *model = [[MissionModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        if (dataArray.count == 0 ) {
            [Dialog simpleToast:NoMoreData];
        }
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }]; 
}

- (void)getMissionCount:(void (^)(int result))result viewCtrl:(id)viewCtrl{
    
   NSString * strUrl=@"/api/v1/sale/trip/count";
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        result([responseObject[@"size"] intValue]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
- (void)getSearchMissionData:(void (^)(NSArray *arr))successArr type:(int)type pageIndex:(int)pageIndex start:(NSString*)start  dest:(NSString*)dest content:(NSString *)content  startDate:(NSString *)startDate  endDate:(NSString *)endDate  travelMode:(NSNumber*)travelMode status:(NSNumber*)status viewCtrl:(id)viewCtrl{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableDictionary *param= [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"start":start,@"dest":dest,@"content":content,@"startDate":startDate,@"endDate":endDate}];
    if (![travelMode isEqual:ImpossibleNSNumber]) {
        [param setObject:travelMode forKey:@"travelMode"];
    }
    if (![status isEqual:ImpossibleNSNumber]) {
        [param  setObject:status forKey:@"status"];
    }
    
    NSString *strUrl;
    if (type == 0) {
        strUrl=@"/api/v1/sale/trip/own";
    }else{
        strUrl=@"/api/v1/sale/trip/operate";
    }
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //              NSString *str = [responseObject mj_JSONString];
        //              NSLog(@"%@",str);
        NSArray  *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            MissionModel *model = [[MissionModel alloc] initWithDic:dic];
            [dataArray addObject:model];
        }
        if (dataArray.count == 0 ) {
            [Dialog simpleToast:NoMoreData];
        }
        successArr(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }]; 

}
-(void)addMissionData:(void (^)(int  result, MissionModel *model))result  start:(NSString*)start dest:(NSString*)dest travelMode:(int)travelMode content:(NSString*)content startDate:(NSString*)startDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl
{
    NSString *strUrl=@"/api/v1/sale/trip/create";
    NSDictionary *param=@{@"start":start,@"dest":dest,@"travelMode":[NSNumber numberWithInt:travelMode],@"content":content,@"startDate":startDate,@"endDate":endDate};
    
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        NSDictionary *dic = responseObject[@"data"];
        MissionModel *model = [[MissionModel alloc]initWithDic:dic];
        result(1,model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

- (void)editMissionData:(void (^)(MissionModel *model))result missionID:(NSNumber*)missionID start:(NSString*)start dest:(NSString*)dest travelMode:(int)travelMode content:(NSString*)content startDate:(NSString*)startDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl{
    startDate = [startDate substringToIndex:10];
    endDate = [endDate substringToIndex:10];
     NSString *strUrl=@"/api/v1/sale/trip/modify";
    NSDictionary *param=@{@"id":missionID,@"start":start,@"dest":dest,@"travelMode":[NSNumber numberWithInt:travelMode],@"content":content,@"startDate":startDate,@"endDate":endDate};
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *str = [responseObject mj_JSONString];
        //        NSLog(@"%@",str);
        NSDictionary *dic = responseObject[@"data"];
        MissionModel *model = [[MissionModel alloc]initWithDic:dic];
        result(model);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
-(void)getDetailMissionData:(void (^)(MissionDetailModel  *model))result  missionID:(NSNumber*)missionID viewCtrl:(id)viewCtrl
{
   
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",@"/api/v1/sale/trip/",missionID];
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
        MissionDetailModel *model = [[MissionDetailModel alloc]initWithDic:responseObject];
        
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        
      NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}

//99终审 90审核并上报 0 待审核 -1审核不通过

- (void)dealMissionData:(void(^)(int result, id responseObj))result failure:(void(^)(int failure))failure MissionID:(NSNumber*)MissionID dealType:(int)dealType message:(NSString*)message viewCtrl:(id)viewCtrl{
    NSString *strUrl = [[NSString alloc]init];
   
    if (dealType == 0) {
         //退回
        strUrl = @"/api/v1/sale/trip/back/";
    }else if (dealType == 1){
         //审核通过并上报
        strUrl = @"/api/v1/sale/trip/success/";
    }else if (dealType == 2){
        //审核通过
        strUrl = @"/api/v1/sale/trip/complete/";
    }
    
    strUrl = [NSString stringWithFormat:@"%@%@",strUrl,MissionID];
    NSDictionary *para = @{@"message":message};
    
    [self post:strUrl param:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [responseObject mj_JSONString];
//        NSLog(@"%@",str);
        result(1, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        
         if ([error.description rangeOfString:@"internal server error (500)"].location != NSNotFound){
           
             failure(1);
        }
        [viewCtrl hideHud];
        NSLog(@"%@",error.description);
    }];
   
}

- (void)deleteMissionData:(void(^)(int result))result MissionID:(NSNumber*)MissionID viewCtrl:(id)viewCtrl{
   
     NSString *strUrl = [NSString stringWithFormat:@"/api/v1/sale/trip/delete/%@",MissionID];
    
    [self get:strUrl param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        result(1);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        NSLog(@"%@",error.description);
        [viewCtrl hideHud];
    }];
}
@end
