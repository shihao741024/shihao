//
//  HospitalModel.h
//  errand
//
//  Created by gravel on 16/1/16.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalDetailModel : NSObject

@property(nonatomic,copy)NSString *hospitalName;
@property(nonatomic,copy)NSString *addressString;

@property(nonatomic,copy)NSString *introduceString;
@property(nonatomic,copy)NSString *gradeString;
@property(nonatomic,copy)NSString *phoneString;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
