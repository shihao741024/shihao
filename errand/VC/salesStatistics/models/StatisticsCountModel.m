//
//  StatisticsModel.m
//  errand
//
//  Created by gravel on 16/2/27.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "StatisticsCountModel.h"

@implementation StatisticsCountModel

- (instancetype)initWithArr:(NSArray*)Arr{
    if (self = [super init]) {
        _count = Arr[0];
        _pillName = Arr[1][@"name"];
        _pillID = Arr[1][@"id"];
        _hospitalName = Arr[2][@"name"];
        _hospitalID = Arr[2][@"id"];
        
        _doctorName = Arr[2][@"name"];
        _secondHosName = Arr[2][@"hospital"][@"name"];
        _doctorId = Arr[2][@"id"];
        _secondHosId = Arr[2][@"hospital"][@"id"];
        
        _specification = Arr[1][@"specification"];
    }
    return self;
}
@end
