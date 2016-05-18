//
//  SalesDaily.m
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SalesDailyModel.h"
#import "CommentModel.h"


@implementation SalesDailyModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _headImgStr = dic[@"belongTo"][@"avatar"];
        _userName = dic[@"belongTo"][@"name"];
        _userID = dic[@"belongTo"][@"id"];
        _telephone = dic[@"belongTo"][@"telephone"];
        _category = dic[@"category"];
        _ID = dic[@"id"];
        //展示的内容需要切割
        if ([_category isEqual:@1]) {
            NSArray *arr = [dic[@"content"] componentsSeparatedByString:@" {"];
            NSString *mainContent = arr[0];
            NSArray *arr1 = [mainContent componentsSeparatedByString:@"#ylx#"];
            if (arr1.count > 1) {
                 _content = [NSString stringWithFormat:@"本周计划总结\n%@\n下周计划总结\n%@",arr1[0],arr1[1]];
            }else{
               _content = arr[0];
            }
           
        }else if ([_category isEqual:@2]){
            NSArray *arr = [dic[@"content"] componentsSeparatedByString:@" {"];
            NSString *mainContent = arr[0];
            NSArray *arr1 = [mainContent componentsSeparatedByString:@"#ylx#"];
            if (arr1.count > 1) {
                 _content = [NSString stringWithFormat:@"本月计划总结\n%@\n下月计划总结\n%@",arr1[0],arr1[1]];
            }else{
                _content = arr[0];
            }
        }else{
            NSArray *arr = [dic[@"content"] componentsSeparatedByString:@" {"];
            _content = arr[0];
        }
        
        if ([dic[@"publishedDate"] isKindOfClass:[NSNumber class]]) {
            _publishedDate = dic[@"publishedDate"];
        }else{
            //发表成功时返回的日期是 字符串
            NSString *publishStr = dic[@"publishedDate"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            NSDate *publishDate = [formatter dateFromString:publishStr];
            
            double time = [publishDate timeIntervalSince1970] * 1000;
            _publishedDate = [NSNumber numberWithDouble:time];
        }
        
        _sendingPlace = dic[@"sendingPlace"];
//        _open = (BOOL)dic[@"open"];
        _deviceName = dic[@"deviceName"];
        _picArray = dic[@"pics"];
        
        _commentsArray = [NSMutableArray array];
        for (NSDictionary *dict in dic[@"comments"]) {
            CommentModel *model = [[CommentModel alloc]initWithDic:dict];
            [_commentsArray addObject:model];
        }
        
        _acountStr = [NSString stringWithFormat:@"%lu",(unsigned long)_commentsArray.count];
        
    }
    return self;
}

////头像
//@property (nonatomic, strong)NSString *headImgStr;
////用户名
//@property (nonatomic, strong)NSString *userName;
////用户号码
//@property (nonatomic, strong)NSString *telephone;
////发表的种类 0 日报 1 周报 2 月报 3 分享
//@property (nonatomic, strong)NSNumber *category;
////id
//@property (nonatomic, strong)NSNumber *ID;
////发表的内容
//@property (nonatomic, strong)NSString *content;
////发表的时间
//@property (nonatomic, strong)NSString *publishedDate;
////发送的地点
//@property (nonatomic, strong)NSString *sendingPlace;

////设备号
//@property (nonatomic, copy)NSString *deviceName;
////图片
//@property (nonatomic,strong)NSArray *picArray;
////评论的条数
//@property (nonatomic, strong)NSString *acountStr;
////他人评论
//@property (nonatomic, strong)NSMutableArray *commentsArray;
#pragma mark - 实现NSCoding协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //    [aCoder encodeObject:self.vendor forKey:@"vendor"];
    [aCoder encodeObject:self.headImgStr forKey:@"headImgStr"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [aCoder encodeObject:self.sendingPlace forKey:@"sendingPlace"];
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:self.picArray forKey:@"picArray"];
    [aCoder encodeObject:self.acountStr forKey:@"acountStr"];
    [aCoder encodeObject:self.commentsArray forKey:@"commentsArray"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.headImgStr = [aDecoder decodeObjectForKey:@"headImgStr"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
        self.category = [aDecoder decodeObjectForKey:@"category"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.publishedDate = [aDecoder decodeObjectForKey:@"publishedDate"];
        self.sendingPlace = [aDecoder decodeObjectForKey:@"sendingPlace"];
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.picArray = [aDecoder decodeObjectForKey:@"picArray"];
        self.acountStr = [aDecoder decodeObjectForKey:@"acountStr"];
        self.commentsArray = [aDecoder decodeObjectForKey:@"commentsArray"];
    }
    return self;
}

@end
