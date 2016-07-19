//
//  TaskDetailModel.m
//  errand
//
//  Created by gravel on 16/1/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "TaskDetailModel.h"

@implementation TaskDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _createDate = dic[@"createDate"];
        _taskName = dic[@"title"];
        _phoneNumber = dic[@"belongTo"][@"telephone"];
        _receiverName = dic[@"belongTo"][@"name"];
        _belongId = dic[@"belongTo"][@"id"];
        _stauts =[NSString stringWithFormat:@"%@",dic[@"status"]];
        _contentStr = dic[@"content"];
        _planCompleteDate = dic[@"planCompleteDate"];
        _priority = [NSString stringWithFormat:@"%@",dic[@"priority"]];
        
        if (dic[@"feedback"] == [NSNull null]) {
            _feedback = @"";
        }else{
            _feedback = dic[@"feedback"];

        }
                
        _toName = dic[@"to"][@"name"];
}
    return self;
}

@end
