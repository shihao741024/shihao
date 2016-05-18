//
//  VisitDetailModel.m
//  errand
//
//  Created by gravel on 16/1/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitDetailModel.h"

@implementation VisitDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _stateString = [NSString stringWithFormat:@"%@", dic[@"status"]];
        _remarkString = dic[@"content"];
        //拜访时间
        _endDate = dic[@"visitDate"];
        //创建时间
        _startDate = dic[@"createDate"];
        
        _doctorName = dic[@"doctor"][@"name"];
        
        
        _hospitalName = dic[@"hospital"][@"name"];
        
        _sumString = dic[@"summary"];
        
        _category = dic[@"category"];
        
        _arriveDate = dic[@"arriveDate"];
        
        _leaveDate = dic[@"leaveDate"];
        _belongToID = dic[@"belongTo"][@"id"];
        _ID = dic[@"id"];
        
        if (![Function isNullOrNil:dic[@"production"]]) {
            _productName = dic[@"production"][@"name"];
            _specification = dic[@"production"][@"specification"];
        }
    }
    
    return self;
}

@end
