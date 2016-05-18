//
//  PathPointModel.m
//  errand
//
//  Created by pro on 16/4/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "PathPointModel.h"

@implementation PathPointModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic[@"coordinate"] != [NSNull null]) {
            _name = dic[@"coordinate"][@"name"];
            _latitude = dic[@"coordinate"][@"latitude"];
            _longitude = dic[@"coordinate"][@"longitude"];
            
            _upload = @1;
        }else {
            _upload = @0;
        }
        _belongid = GDBUserID;
        _createDate = dic[@"createDate"];
        _ID = dic[@"id"];
        _planDate = dic[@"planDate"];
        _times = dic[@"times"];
        
    }
    return self;
}

+ (NSMutableArray *)getModelArrayWithDicArray:(NSMutableArray *)dicArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        PathPointModel *model = [[PathPointModel alloc] initWithDic:dic];
        [arr addObject:model];
    }
    return arr;
}

//数据解析
+ (NSMutableArray *)parsingWithJsonData:(NSArray *)dataArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in dataArray) {
        PathPointModel *model = [[PathPointModel alloc] init];
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
