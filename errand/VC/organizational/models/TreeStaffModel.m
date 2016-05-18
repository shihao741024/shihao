//
//  TreeStaffModel.m
//  errand
//
//  Created by gravel on 16/1/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "TreeStaffModel.h"

@implementation TreeStaffModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _name = dic[@"name"];
    }
    return self;
}

@end
