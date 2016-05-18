//
//  StaffInfoModel.h
//  errand
//
//  Created by gravel on 16/1/16.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffInfoModel : NSObject

@property (nonatomic, strong)NSNumber *staffInfoID;
@property (nonatomic, strong)NSString *staffInfoName;
@property (nonatomic, strong)NSString *staffInfoTele;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
