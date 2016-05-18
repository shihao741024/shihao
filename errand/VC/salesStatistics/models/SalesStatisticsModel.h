//
//  SalesStatisticsModel.h
//  errand
//
//  Created by gravel on 15/12/21.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesStatisticsModel : NSObject

@property(nonatomic, copy)NSString *dateString;
@property(nonatomic, copy)NSString *pillName;
@property(nonatomic, copy)NSString *amountString;
@property(nonatomic, copy)NSString *hospitalName;
@property(nonatomic, copy)NSString *buyerString;
@property(nonatomic, strong)NSNumber *salesStatisticsID;
@property(nonatomic, strong)NSNumber *productionID;
@property(nonatomic, strong)NSNumber *hospitalID;
@property(nonatomic, strong)NSNumber *doctorID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *office;
@property(nonatomic, copy)NSString *productName;
@property(nonatomic, copy)NSString *specification;
@property(nonatomic,copy)NSString *provincial;
@property(nonatomic,copy)NSString *city;

@property(nonatomic,copy)NSString *packageUnit;
@property(nonatomic,copy)NSString *price;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
