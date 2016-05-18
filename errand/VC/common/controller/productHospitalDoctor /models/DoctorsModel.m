//
//  DoctorsModel.m
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorsModel.h"

@implementation DoctorsModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _doctorID = dic[@"id"];
        _name = dic[@"name"];
        _office = dic[@"office"];
        _firstCharactor = [self firstCharactor:_name];
    }
    return self;
}

//获取第一个字母
- (NSString *)firstCharactor:(NSString *)aString
{
    if (![Function isNullOrNil:aString]) {
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
    }else {
        return @"";
    }
    
}

#pragma mark - 实现NSCoding协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.doctorID forKey:@"doctorID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.office forKey:@"office"];
    [aCoder encodeObject:self.firstCharactor forKey:@"firstCharactor"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.doctorID = [aDecoder decodeObjectForKey:@"doctorID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.office = [aDecoder decodeObjectForKey:@"office"];
        self.firstCharactor = [aDecoder decodeObjectForKey:@"firstCharactor"];
    }
    return self;
}


@end
