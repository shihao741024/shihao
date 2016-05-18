//
//  CustomerVisitModel.m
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CustomerVisitModel.h"

@implementation CustomerVisitModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _stateString = [NSString stringWithFormat:@"%@", dic[@"status"]];
        
        if (dic[@"content"] == [NSNull null]) {
            _remarkString = @"无数据";
        }else {
            _remarkString = dic[@"content"];
        }
        
        //拜访时间
        _endDate = dic[@"visitDate"];
        //创建时间
        _startDate = dic[@"createDate"];
        if (dic[@"doctor"][@"name"]!=NULL) {
              _doctorName = dic[@"doctor"][@"name"];
        }else{
            _doctorName = @"无数据";
        }
        if (dic[@"hospital"][@"name"]!=NULL) {
            _hospitalName = dic[@"hospital"][@"name"];
        }else{
            _hospitalName = @"无数据";
        }
        _category = dic[@"category"];
        _visitID = dic[@"id"];
        
    }
   
    return self;
}

@end
