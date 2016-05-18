//
//  DeclareModel.h
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeclareModel : NSObject

@property(nonatomic, strong)NSNumber *currentStatus;
@property(nonatomic, copy)NSString *declareName;
@property(nonatomic, copy)NSString *moneyString;
@property(nonatomic, copy)NSString *createDate;
@property(nonatomic, copy)NSString *wayString;
@property(nonatomic, copy)NSString *remarkString;
@property(nonatomic, strong)NSNumber *declareID;



- (instancetype)initWithDic:(NSDictionary *)dic;

@property(nonatomic, strong)NSNumber *organizationID;

@end
