//
//  AtModel.h
//  errand
//
//  Created by gravel on 16/3/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtModel : NSObject

@property (nonatomic, strong)NSNumber *ID;

@property (nonatomic, copy)NSString *name;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
