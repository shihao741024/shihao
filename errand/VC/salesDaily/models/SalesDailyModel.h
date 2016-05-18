//
//  SalesDaily.h
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesDailyModel : NSObject<NSCoding>
//头像
@property (nonatomic, copy)NSString *headImgStr;
//用户名
@property (nonatomic, copy)NSString *userName;
//用户名id
@property (nonatomic, copy)NSNumber *userID;
//用户号码
@property (nonatomic, copy)NSString *telephone;
//发表的种类 0 日报 1 周报 2 月报 3 分享
@property (nonatomic, strong)NSNumber *category;
//id
@property (nonatomic, strong)NSNumber *ID;
//发表的内容
@property (nonatomic, copy)NSString *content;
//发表的时间
@property (nonatomic, strong)NSNumber *publishedDate;
//发送的地点
@property (nonatomic, copy)NSString *sendingPlace;
//权限
//@property (nonatomic)BOOL open;
//设备号
@property (nonatomic, copy)NSString *deviceName;
//图片
@property (nonatomic,strong)NSArray *picArray;
//评论的条数
@property (nonatomic, strong)NSString *acountStr;
//他人评论
@property (nonatomic, strong)NSMutableArray *commentsArray;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
