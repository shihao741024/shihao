

//
//  CommentModel.m
//  errand
//
//  Created by gravel on 15/12/26.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CommentModel.h"

////每条评论的id
//@property (nonatomic, strong)NSString *ID;
////发评论的人
//@property (nonatomic, strong)NSString *sname;
////被评论的人
//@property (nonatomic,strong)NSString *tname;
////评论的内容
//@property (nonatomic, strong)NSString *content;

@implementation CommentModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _ID = dic[@"id"];
        _sname = dic[@"sname"];
        _sid = dic[@"sid"];
        if (dic[@"tname"] == [NSNull null]) {
            _tname = @"";
            _tid = @-1;
        }else{
            _tname = dic[@"tname"];
            _tid = dic[@"tid"];
        }
        NSArray *arr = [dic[@"content"] componentsSeparatedByString:@" {"];
        _content = arr[0];
    }
    return self;
}

@end
