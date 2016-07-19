//
//  DoctorModel.m
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DoctorModel.h"

@implementation DoctorModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _doctorID = dic[@"id"];
        _doctorName = dic[@"name"];
        _office = dic[@"office"];
        _hospitalName = dic[@"hospital"][@"name"];
        _positionString = dic[@"hospital"][@"level"];
        _phoneString = dic[@"telphone"];
    }
    return self;
}

#pragma mark - 实现NSCoding协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.doctorID forKey:@"doctorID"];
    [aCoder encodeObject:self.doctorName forKey:@"doctorName"];
    [aCoder encodeObject:self.office forKey:@"office"];
    [aCoder encodeObject:self.hospitalName forKey:@"hospitalName"];
    [aCoder encodeObject:self.positionString forKey:@"positionString"];
    [aCoder encodeObject:self.phoneString forKey:@"phoneString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.doctorID = [aDecoder decodeObjectForKey:@"doctorID"];
        self.doctorName = [aDecoder decodeObjectForKey:@"doctorName"];
        self.office = [aDecoder decodeObjectForKey:@"office"];
        self.hospitalName = [aDecoder decodeObjectForKey:@"hospitalName"];
        self.positionString = [aDecoder decodeObjectForKey:@"positionString"];
        self.phoneString = [aDecoder decodeObjectForKey:@"phoneString"];
    }
    return self;
}
@end
