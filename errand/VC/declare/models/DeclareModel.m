//
//  DeclareModel.m
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DeclareModel.h"

@implementation DeclareModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _currentStatus = dic[@"status"];
        _moneyString = [NSString stringWithFormat:@"%@",dic[@"cost"]];
        _wayString = dic[@"description"];
        _remarkString = dic[@"goal"];
        _declareID =dic[@"id"];
        _declareName = dic[@"name"];
        _createDate = dic[@"createDate"];
        
        if (![Function isNullOrNil:dic[@"organization"]]) {
            _organizationID = dic[@"organization"][@"id"];
        }
        
        
    }
    return self;
}

@end
