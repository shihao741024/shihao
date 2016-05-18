
//
//  DeclareDetailModel.m
//  errand
//
//  Created by gravel on 16/1/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DeclareDetailModel.h"
#import "AuditInfosModel.h"
@implementation DeclareDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _currentStatus = dic[@"status"];
        _moneyString = [NSString stringWithFormat:@"%@",dic[@"cost"]];
        _wayString = dic[@"description"];
        _remarkString = dic[@"goal"];
        _declareName = dic[@"name"];
        _createDate = dic[@"createDate"];
         if (dic[@"doctor"] != [NSNull null]) {
               _doctorName = dic[@"doctor"][@"name"];
             
         }else{
             if (![Function isNullOrNil:dic[@"hospital"]]) {
                 _doctorName = dic[@"hospital"][@"name"];
             }
             
         }
        
        if (![Function isNullOrNil:dic[@"hospital"]]) {
            _hospitalName = dic[@"hospital"][@"name"];
        }
        
        
        if (![Function isNullOrNil:dic[@"production"]]) {
            _productionName = dic[@"production"][@"name"];
            _specification = dic[@"production"][@"specification"];
        }
        
        _telephone = dic[@"belongTo"][@"telephone"];
        _username = dic[@"belongTo"][@"name"];
        if (dic[@"remark"] == [NSNull null]) {
            _remark = @"";
        }else{
            _remark = dic[@"remark"];
        }
        
        _belongtoID = dic[@"belongTo"][@"id"];
        
        _auditInfos = [NSMutableArray array];
        for (NSDictionary *infosDic in dic[@"costInfos"]) {
            AuditInfosModel *model = [[AuditInfosModel alloc]initWithDic:infosDic];
            [_auditInfos addObject:model];
        }
        
        
        if (![Function isNullOrNil:dic[@"doctor"]]) {
            _hospitalDic = dic[@"doctor"][@"hospital"];
            _doctorDic = dic[@"doctor"];
        }else {
            _hospitalDic = dic[@"hospital"];
        }
        
        _productionDic = dic[@"production"];
        _declareID = dic[@"id"];
        
    }
    return self;
}

@end
