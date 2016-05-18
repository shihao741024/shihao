//
//  MissionDetailModel.h
//  errand
//
//  Created by gravel on 16/1/10.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MissionDetailModel : NSObject

@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *to;
@property(nonatomic,copy)NSString *startDate;
@property(nonatomic,copy)NSString *endDate;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,assign)int status;
@property(nonatomic,assign)int travelType;
@property(nonatomic,copy)NSString *proposerPhone;
//发布的人
@property(nonatomic,copy)NSString *proposerName;
//发布的人id
@property(nonatomic,strong)NSNumber *belongtoID;

@property(nonatomic,strong)NSNumber *missionID;

@property(nonatomic,copy)NSString *applyTime;

@property(nonatomic,strong)NSMutableArray *auditInfos;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
