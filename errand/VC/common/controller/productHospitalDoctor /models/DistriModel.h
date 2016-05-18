//
//  DistriModel.h
//  errand
//
//  Created by gravel on 16/2/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistriModel : NSObject

@property(nonatomic, strong)NSNumber *distriID;
@property(nonatomic, copy)NSString *vendor;

- (instancetype)initWithDic:(NSDictionary *)dic;



@end
