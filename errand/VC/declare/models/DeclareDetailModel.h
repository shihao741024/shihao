//
//  DeclareDetailModel.h
//  errand
//
//  Created by gravel on 16/1/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeclareDetailModel : NSObject
@property(nonatomic, strong)NSNumber *currentStatus;
@property(nonatomic, copy)NSString *declareName;
@property(nonatomic, copy)NSString *moneyString;
@property(nonatomic, copy)NSString *createDate;
@property(nonatomic, copy)NSString *wayString;
@property(nonatomic, copy)NSString *remarkString;
@property(nonatomic, copy)NSString *doctorName;
@property(nonatomic, copy)NSString *productionName;
@property(nonatomic, copy)NSString *specification;
@property(nonatomic, copy)NSString *telephone;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *hospitalName;
//备注
@property(nonatomic, copy)NSString *remark;
//发布的人id
@property(nonatomic,strong)NSNumber *belongtoID;
//审批流程的数组
@property(nonatomic, strong)NSMutableArray *auditInfos;
- (instancetype)initWithDic:(NSDictionary *)dic;


@property(nonatomic, strong)NSDictionary *hospitalDic;
@property(nonatomic, strong)NSDictionary *doctorDic;
@property(nonatomic, strong)NSDictionary *productionDic;
@property(nonatomic, strong)NSNumber *declareID;

@end
