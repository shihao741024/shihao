//
//  CustomerVisitModel.h
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerVisitModel : NSObject


@property(nonatomic, copy)NSString *stateString;
@property(nonatomic, copy)NSString *hospitalName;
@property(nonatomic, copy)NSString *doctorName;
@property(nonatomic, copy)NSString *startDate;
@property(nonatomic, copy)NSString *endDate;
@property(nonatomic, copy)NSString *remarkString;
@property(nonatomic, copy)NSString *phoneNumber;
@property(nonatomic, copy)NSString *sumString;
@property(nonatomic, strong)NSNumber *category;
@property(nonatomic, strong)NSNumber *visitID;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
