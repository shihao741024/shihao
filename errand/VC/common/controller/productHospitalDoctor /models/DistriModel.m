//
//  DistriModel.m
//  errand
//
//  Created by gravel on 16/2/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DistriModel.h"

@implementation DistriModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
       _distriID = dic[@"id"];
        _vendor = dic[@"vendor"];
    }
    return self;
}


@end
