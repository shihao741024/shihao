//
//  OriginalPointModel.m
//  errand
//
//  Created by pro on 16/4/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "OriginalPointModel.h"

@implementation OriginalPointModel

- (instancetype)initWithLocation:(CLLocation *)location latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    self = [super init];
    if (self) {
        
        _belongid = GDBUserID;
        _date = [[Function stringFromDate:location.timestamp] substringToIndex:10];
        
        _latitude = [NSString stringWithFormat:@"%f", latitude];
        _longitude = [NSString stringWithFormat:@"%f", longitude];
        _time = [[Function stringFromDate:location.timestamp] substringFromIndex:11];
        
    }
    return self;
}

+ (NSMutableArray *)getModelArrayWithDicArray:(NSMutableArray *)dicArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
//        OriginalPointModel *model = [[OriginalPointModel alloc] initWithDic:dic];
//        [arr addObject:model];
    }
    return arr;
}

//数据解析
+ (NSMutableArray *)parsingWithJsonData:(NSArray *)dataArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in dataArray) {
        OriginalPointModel *model = [[OriginalPointModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [arr addObject:model];
    }
    return arr;
}

//KVC,在setvalue forkey使用的时候,如果key值不存在,会调用这个方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"=====%@",key);
}



@end
