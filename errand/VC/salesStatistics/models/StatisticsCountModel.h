//
//  StatisticsModel.h
//  errand
//
//  Created by gravel on 16/2/27.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsCountModel : NSObject

//药品名称
@property(nonatomic, copy)NSString *pillName;
//医院名称
@property(nonatomic, copy)NSString *hospitalName;
//产品数量
@property(nonatomic, strong)NSNumber *count;
//药品id
@property(nonatomic, strong)NSNumber *pillID;
//医院id
@property(nonatomic, strong)NSNumber *hospitalID;

@property(nonatomic, copy)NSNumber *doctorId;
@property(nonatomic, copy)NSNumber *secondHosId;
@property(nonatomic, copy)NSString *doctorName;
@property(nonatomic, copy)NSString *secondHosName;
@property(nonatomic, copy)NSString *specification;


- (instancetype)initWithArr:(NSArray*)Arr;

@end
