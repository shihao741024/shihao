//
//  InformationModel.m
//  errand
//
//  Created by wjjxx on 16/3/22.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _content = dic[@"content"];
        _createDate = [self getDateStrFromNumber:dic[@"createDate"]];
        _InformationID = dic[@"id"];
        _data = dic[@"data"];
        _isEdit = NO;
    }
    return self;
}

- (NSString *)getDateStrFromNumber:(NSNumber*)createDate{
    long time = [createDate doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
@end
