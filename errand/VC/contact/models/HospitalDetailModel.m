//
//  HospitalModel.m
//  errand
//
//  Created by gravel on 16/1/16.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "HospitalDetailModel.h"

@implementation HospitalDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _hospitalName = dic[@"name"];
        _addressString = [NSString stringWithFormat:@"%@%@%@%@",dic[@"address"][@"provincial"],dic[@"address"][@"city"],dic[@"address"][@"address"],dic[@"address"][@"county"]];
        
        _gradeString = dic[@"level"];
       
    }
    return self;
}

@end
