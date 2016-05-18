//
//  StaffInfoModel.m
//  errand
//
//  Created by gravel on 16/1/16.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "StaffInfoModel.h"

@implementation StaffInfoModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _staffInfoID = dic[@"id"];
        _staffInfoName = dic[@"name"];
        _staffInfoTele = dic[@"telephone"];
    }
    return self;
}

@end
