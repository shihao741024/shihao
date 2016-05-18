//
//  MissionDetailModel.m
//  errand
//
//  Created by gravel on 16/1/10.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MissionDetailModel.h"
#import "AuditInfosModel.h"
@implementation MissionDetailModel
//@property(nonatomic,copy)NSString *proposerPhone;
//@property(nonatomic,copy)NSString *proposerName;
//@property(nonatomic,copy)NSString *applyTime;
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _from = dic[@"start"];
        _to = dic[@"dest"];
        _remark = dic[@"content"];
        _endDate = dic[@"endDate"];
        _startDate = dic[@"startDate"];
        _status =  [dic[@"status"] intValue];
        _travelType = [dic[@"travelMode"] intValue];
        _proposerPhone = dic[@"belongTo"][@"telephone"];
        _proposerName = dic[@"belongTo"][@"name"];
        _belongtoID = dic[@"belongTo"][@"id"];
        _applyTime = dic[@"createDate"];
         _missionID = dic[@"id"];
        _auditInfos = [NSMutableArray array];
        for (NSDictionary *infosDic in dic[@"auditInfos"]) {
            AuditInfosModel *model = [[AuditInfosModel alloc]initWithDic:infosDic];
            [_auditInfos addObject:model];
        }
    }
    return self;
}

@end
