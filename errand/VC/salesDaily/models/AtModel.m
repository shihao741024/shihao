//
//  AtModel.m
//  errand
//
//  Created by gravel on 16/3/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AtModel.h"

@implementation AtModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _ID = dic[@"id"];
        _name = dic[@"name"];
    }
    return self;
}

@end
