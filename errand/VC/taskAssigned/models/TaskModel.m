//
//  TaskModel.m
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        if ([dic isKindOfClass:[NSArray class]]) {
            NSArray *reverseArray = [(NSArray *)dic reverseObjectEnumerator].allObjects;
            for (NSDictionary *oneDic in reverseArray) {
                [self configModelWithDic:oneDic];
            }
        }else {
            [self configModelWithDic:dic];
        }
        
    }
    return self;
}

- (void)configModelWithDic:(NSDictionary *)dic
{
    _createDate = dic[@"createDate"];
    _taskName = dic[@"title"];
    _phoneNumber = dic[@"to"][@"telephone"];
    _receiverName = dic[@"to"][@"name"];
    if (dic[@"status"]) {
        _stauts =[NSString stringWithFormat:@"%@",dic[@"status"]];
    }else{
        _stauts = @"0";
    }
    
    _contentStr = dic[@"content"];
    _planCompleteDate = dic[@"planCompleteDate"];
    if (dic[@"id"]) {
        _taskID = dic[@"id"];
    }else{
        _taskID = @10;
    }
    _remark = dic[@"content"];
    _priority = [NSString stringWithFormat:@"%@",dic[@"priority"]];
    
    _releaser = dic[@"belongTo"][@"name"];
}



@end
