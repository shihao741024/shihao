//
//  ReportCountModel.m
//  errand
//
//  Created by wjjxx on 16/3/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ReportCountModel.h"

@implementation ReportCountModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _count = dic[@"count"];
        _day = dic[@"day"];
        _countID = dic[@"id"];
        _name = dic[@"name"];
        
    }
    return self;
}
@end
