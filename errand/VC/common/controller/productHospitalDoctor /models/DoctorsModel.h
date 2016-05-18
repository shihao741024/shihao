//
//  DoctorsModel.h
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorsModel : NSObject<NSCoding>


@property(nonatomic, strong)NSNumber *doctorID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *office;
@property(nonatomic,copy)NSString *firstCharactor;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
