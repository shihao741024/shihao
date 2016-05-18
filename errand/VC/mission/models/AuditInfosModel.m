//
//  AuditInfosModel.m
//  errand
//
//  Created by wjjxx on 16/3/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AuditInfosModel.h"

@implementation AuditInfosModel
//@property(nonatomic,copy)NSString *auditDate;
//@property(nonatomic,copy)NSString *message;
//@property(nonatomic,copy)NSString *name;
//@property(nonatomic,strong)NSNumber *status;

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        //等待哪个部门审核
        if (dic[@"auditDate"]== [NSNull null]) {
             _auditDate = @"";
            _name = dic[@"organization"][@"name"];
             _message = @"";
            _status = dic[@"status"];
            _auditID = ImpossibleNSNumber;

        }else{
            //审核完成
            _auditDate = dic[@"auditDate"];
            _message = dic[@"message"];
            _name = dic[@"auditSale"][@"name"];
            _status = dic[@"status"];
            _auditID = dic[@"auditSale"][@"id"];
        }
    }
    return self;
}
@end
