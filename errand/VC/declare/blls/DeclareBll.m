//
//  declareBll.m
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DeclareBll.h"
#import "ProductionModel.h"
#import "ContactModel.h"
@implementation DeclareBll

- (void)getAllDeclareData:(void (^)(NSArray *arr))successArr type:(int)type pageIndex:(int)pageIndex  viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    if (type == 0) {
        strUrl = @"/api/v1/sale/cost/own";
    }else{
        strUrl = @"/api/v1/sale/cost/operate";
    }
     NSDictionary *param=@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10};
    [self post:strUrl param:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        NSString *str = [responseObject mj_JSONString];
//                        NSLog(@"%@",str);
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            DeclareModel *model = [[DeclareModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        
        NSLog(@"%@",error.userInfo);
        [viewCtrl hideHud];
    }];
}

- (void)getSearchDeclareData:(void (^)(NSArray *arr))successArr type:(int)type pageIndex:(int)pageIndex name:(NSString*)name Hospital:(NSNumber*)Hospital doctor:(NSNumber*)doctor production:(NSNumber*)production description:(NSString*)description goal:(NSString*)goal remark:(NSString *)remark status:(NSNumber*)status viewCtrl:(id)viewCtrl{
    
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSString *strUrl;
    if (type == 0) {
        strUrl = @"/api/v1/sale/cost/own";
    }else{
        strUrl = @"/api/v1/sale/cost/operate";
    }
   NSMutableDictionary *param= [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSNumber numberWithInt:pageIndex],@"size":@10,@"name":name,@"description":description,@"goal":goal,@"remark":remark}];
    if (![Hospital isEqual:ImpossibleNSNumber]) {
        [param setObject:@{@"id":Hospital} forKey:@"hospital"];
    }
    if (![production isEqual:ImpossibleNSNumber]) {
        [param setObject:@{@"id":production} forKey:@"production"];
    }
    if (![doctor isEqual:ImpossibleNSNumber]) {
        [param setObject:@{@"id":doctor} forKey:@"doctor"];
    }
    if (![status isEqual:ImpossibleNSNumber]) {
        [param setObject:status forKey:@"status"];
    }
    
    [self post:strUrl param:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject mj_JSONString];
        NSLog(@"%@",str);
//        DeclareModel *model = [[DeclareModel alloc]initWithDic:responseObject[@"data"]];
        int totalPages = [responseObject[@"totalPages"] intValue];
        if (pageIndex > totalPages) {
            [Dialog simpleToast:NoMoreData];
        }
        NSArray *array = responseObject[@"content"];
        for (NSDictionary *dic in array) {
            DeclareModel *model = [[DeclareModel alloc]initWithDic:dic];
            [dataArray addObject:model];
        }
        successArr(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
       [viewCtrl hideHud];
    }];

}

-(void)addDeclareData:(void (^)(DeclareModel *model))result  Name:(NSString*)Name Hospital:(NSNumber*)Hospital doctor:(NSNumber*)doctor production:(NSNumber*)production description:(NSString*)description  cost:(NSString*)cost goal:(NSString*)goal remark:(NSString *)remark viewCtrl:(id)viewCtrl declareID:(NSNumber *)declareID
{
    NSString *strUrl;
    
    NSDictionary *staticDic = @{@"name":Name,
                                @"description":description,
                                @"cost":cost,
                                @"goal":goal,
                                @"remark":remark};
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:staticDic];
    
    if (![doctor  isEqual: ImpossibleNSNumber]) {
        [param setObject:@{@"id":doctor} forKey:@"doctor"];
    }
    if (![Hospital  isEqual: ImpossibleNSNumber]) {
        [param setObject:@{@"id":Hospital} forKey:@"hospital"];
    }
    if (![production  isEqual: ImpossibleNSNumber]) {
        [param setObject:@{@"id":production} forKey:@"production"];
    }
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:param];
    if (declareID) {
        strUrl =  @"/api/v1/sale/cost/modify";
        [muDic setObject:declareID forKey:@"id"];
    }else {
        strUrl =@"/api/v1/sale/cost/create";
    }
    
       [self post:strUrl param:muDic  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *str = [responseObject mj_JSONString];
//                NSLog(@"%@",str);
        DeclareModel *model = [[DeclareModel alloc]initWithDic:responseObject[@"data"]];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error,BOOL hasCon) {
//        NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",string);
        [viewCtrl hideHud];
    }];
}

- (void)getDeclareDetailData:(void (^)(DeclareDetailModel *model))result declareID:(NSNumber*)declareID viewCtrl:(id)viewCtrl{
    NSString *urlStr = [NSString stringWithFormat:@"/api/v1/sale/cost/%@",declareID];
    
    [self get:urlStr param:nil headerParam:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *str = [responseObject mj_JSONString];
                NSLog(@"%@",str);
        DeclareDetailModel *model = [[DeclareDetailModel alloc]initWithDic:responseObject];
        result(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
        [viewCtrl hideHud];
    }];
}

//99终审 90审核并上报 0 待审核 -1审核不通过
- (void)dealDeclareData:(void(^)(int result))result  DeclareID:(NSNumber*)DeclareID dealType:(int)dealType message:(NSString*)message cost:(NSString *)cost viewCtrl:(id)viewCtrl{
    NSString *strUrl = [[NSString alloc]init];
    
    if (dealType == 0) {
        //退回
        strUrl = @"/api/v1/sale/cost/back/";
    }else if (dealType == 1){
        //审核通过并上报
        strUrl = @"/api/v1/sale/cost/success/";
    }else if (dealType == 2){
        //审核通过
        strUrl = @"/api/v1/sale/cost/complete/";
    }
    strUrl = [NSString stringWithFormat:@"%@%@",strUrl,DeclareID];
    NSLog(@"%@",strUrl);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"message":message}];
    if (cost) {
        [para setObject:cost forKey:@"cost"];
    }
    
    NSLog(@"%@",para);
        [self post:strUrl param:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *str = [responseObject mj_JSONString];
            NSLog(@"%@",str);
            result(1);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, BOOL hasCon) {
            [viewCtrl hideHud];
            [Function popMsgRequestError:error];
            NSLog(@"%@",error.description);
        }];
   
    
}

@end
