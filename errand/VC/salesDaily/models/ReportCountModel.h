//
//  ReportCountModel.h
//  errand
//
//  Created by wjjxx on 16/3/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportCountModel : NSObject

/** 日报数量 */
@property (nonatomic ,strong)NSNumber *count;
/** 日期 */
@property (nonatomic , copy)NSString *day;
/** 发表人的id */
@property (nonatomic, strong)NSNumber *countID;
/** 发表人的名字 */
@property (nonatomic, copy)NSString *name;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
