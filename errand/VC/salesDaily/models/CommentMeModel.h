//
//  CommentMeModel.h
//  errand
//
//  Created by gravel on 16/3/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentMeModel : NSObject

/** 头像 */
@property (nonatomic, copy)NSString *headImgStr;
//发表评论的人
@property (nonatomic, copy)NSString *sname;
//发表评论的id
@property (nonatomic, strong)NSNumber *sid;
//创建的时间
@property (nonatomic, strong)NSNumber *createDate;
//评论的内容
@property (nonatomic, copy)NSString *content;
//发表的种类 0 日报 1 周报 2 月报 3 分享
@property (nonatomic, strong)NSNumber *category;
//日报的id
@property (nonatomic, strong)NSNumber *ID;
//发表日报的人
@property (nonatomic, copy)NSString *baseName;
//发表日报的id
@property (nonatomic, strong)NSNumber *baseID;
//日报的内容
@property (nonatomic, copy)NSString *baseContent;

//先不管
//被评论的人
@property (nonatomic, copy)NSString *tname;
//被评论的id
@property (nonatomic, strong)NSNumber *tid;

- (instancetype)initWithDic:(NSDictionary *)dic;


@end
