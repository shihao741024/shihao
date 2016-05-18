//
//  VisitDetailModel.h
//  errand
//
//  Created by gravel on 16/1/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitDetailModel : NSObject
@property(nonatomic, copy)NSString *stateString;
@property(nonatomic, copy)NSString *hospitalName;
@property(nonatomic, copy)NSString *doctorName;
@property(nonatomic, copy)NSString *endDate;
@property(nonatomic, copy)NSString *startDate;
@property(nonatomic, copy)NSString *remarkString;
@property(nonatomic, copy)NSString *sumString;
@property(nonatomic, strong)NSNumber *category;
@property(nonatomic, strong)NSNumber *arriveDate;
@property(nonatomic, strong)NSNumber *leaveDate;
@property(nonatomic, strong)NSNumber *belongToID;

@property(nonatomic, strong)NSNumber *ID;

- (instancetype)initWithDic:(NSDictionary *)dic;

@property(nonatomic, copy)NSString *productName;
@property(nonatomic, copy)NSString *specification;

@end
