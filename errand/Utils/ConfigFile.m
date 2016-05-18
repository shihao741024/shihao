//
//  ConfigFile.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ConfigFile.h"

@implementation ConfigFile

+ (NSArray *)genderArray
{
    return @[@"男", @"女"];
}

+ (NSArray *)positionArray
{
    return @[@"代表", @"主管", @"经理", @"总监", @"总经理"];
}
//             position == 0 ? "代表" : position == 1 ? "主管" : position == 2 ? "经理" : position == 3 ? "总监" : "总经理";

@end
