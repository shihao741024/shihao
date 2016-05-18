//
//  ProductionModel.h
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductionModel : NSObject<NSCoding>

@property(nonatomic, copy)NSString *vendor;
@property(nonatomic, strong)NSNumber *productID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *specification;

@property(nonatomic, copy)NSString *detail;
@property(nonatomic, copy)NSString *packageUnit;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
