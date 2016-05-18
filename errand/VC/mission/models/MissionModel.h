//
//  MissionModel.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MissionModel : NSObject
@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *to;
@property(nonatomic,copy)NSString *startDate;
@property(nonatomic,copy)NSString *endDate;
@property(nonatomic,copy)NSString *addDate;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,assign)int status;
@property(nonatomic,assign)int travelType;
@property(nonatomic,strong)NSNumber *missionID;


- (instancetype)initWithDic:(NSDictionary *)dic;


@property(nonatomic,strong)NSNumber *organizationID;

@end
