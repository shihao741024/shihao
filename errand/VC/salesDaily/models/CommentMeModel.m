//
//  CommentMeModel.m
//  errand
//
//  Created by gravel on 16/3/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CommentMeModel.h"

@implementation CommentMeModel
////头像
//@property (nonatomic, copy)NSString *headImgStr;
////发表评论的人
//@property (nonatomic, copy)NSString *sname;
////发表评论的id
//@property (nonatomic, strong)NSNumber *sid;
////创建的时间
//@property (nonatomic, strong)NSNumber *createDate;
////评论的内容
//@property (nonatomic, copy)NSString *content;
////发表的种类 0 日报 1 周报 2 月报 3 分享
//@property (nonatomic, strong)NSNumber *category;
////日报的id
//@property (nonatomic, strong)NSNumber *ID;
////发表日报的人
//@property (nonatomic, copy)NSString *baseName;
////发表日报的id
//@property (nonatomic, strong)NSNumber *baseID;
////日报的内容
//@property (nonatomic, copy)NSString *baseContent;

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {

        _headImgStr = dic[@"avatar"];
        _sname = dic[@"sname"];
        _sid = dic[@"sid"];
        _createDate = dic[@"createDate"];
        //展示的内容需要切割
        NSArray *arr = [dic[@"content"] componentsSeparatedByString:@" {"];
        _content = arr[0];

        _category = dic[@"report"][@"category"];
        _ID = dic[@"report"][@"id"];
        _baseName = dic[@"report"][@"belongTo"][@"name"];
        _baseID = dic[@"report"][@"id"];
        //展示的内容需要切割
        NSArray *arr1 = [dic[@"report"][@"content"] componentsSeparatedByString:@" {"];
        _baseContent = arr1[0];
    }
    return self;
}
@end
