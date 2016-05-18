//
//  StaffModel.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "StaffModel.h"

@implementation StaffModel
//@property(nonatomic,copy)NSString *companyName;
//@property(nonatomic,copy)NSString *staffName;
//@property(nonatomic,copy)NSString *state;
//@property(nonatomic,copy)NSString *phoneNumber;
//@property(nonatomic,copy)NSString *imageName;
//@property(nonatomic,copy)NSString *departmentName;
//@property(nonatomic,copy)NSString *positionName;
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
       //数据不明确
        _companyName = @"医路行";
        _positionName = [NSString stringWithFormat:@"%@",dic[@"organization"][@"quantity"]];
        _state = @"在职";
        _avatar = dic[@"avatar"];
        
        _staffName = dic[@"name"];
        _phoneNumber = dic[@"telephone"];
        _departmentName = dic[@"organization"][@"name"];
        _ID = dic[@"id"];
        _firstCharactor = [self firstCharactor:_staffName];
        _mSelect = NO;
        _weixin = dic[@"weixin"];
        _email = dic[@"email"];
        _originalDic = dic;
    }
    return self;
}

//获取第一个字母
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (NSDictionary *)getModelDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_staffName forKey:@"name"];
    [dic setObject:_phoneNumber forKey:@"telephone"];
    [dic setObject:_ID forKey:@"id"];
    return dic;
}

@end
