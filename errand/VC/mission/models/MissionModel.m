//
//  MissionModel.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionModel.h"

@implementation MissionModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _from = dic[@"start"];
        _to = dic[@"dest"];
        _remark = dic[@"content"];
        _endDate = dic[@"endDate"];
        _startDate = dic[@"startDate"];
        _status =  [dic[@"status"] intValue];
        _travelType = [dic[@"travelMode"] intValue];
        _missionID = dic[@"id"];
        
        if (![Function isNullOrNil:dic[@"organization"]]) {
            _organizationID = dic[@"organization"][@"id"];
        }
    }
    return self;
}

@end
