
//
//  ProductionModel.m
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ProductionModel.h"

@implementation ProductionModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if (![Function isNullOrNil:dic]) {
            _vendor = dic[@"vendor"];
            _name = dic[@"name"];
            _specification =dic[@"specification"];
            _productID = dic[@"id"];
            
            _detail = [NSString stringWithFormat:@"%@ %@ %@", dic[@"bigCatey"], dic[@"midCatey"], dic[@"smCatey"]];
            
            _packageUnit = dic[@"packageUnit"];
        }
        
    }
    return self;
}

#pragma mark - 实现NSCoding协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.vendor forKey:@"vendor"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.specification forKey:@"specification"];
    [aCoder encodeObject:self.productID forKey:@"productID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.vendor = [aDecoder decodeObjectForKey:@"vendor"];
          self.name = [aDecoder decodeObjectForKey:@"name"];
          self.specification = [aDecoder decodeObjectForKey:@"specification"];
          self.productID = [aDecoder decodeObjectForKey:@"productID"];
    }
    return self;
}

@end
