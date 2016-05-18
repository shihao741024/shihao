//
//  ContactModel.m
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if (![Function isNullOrNil:dic]) {
            _hospitalName = dic[@"name"];
            //        _addressString = [NSString stringWithFormat:@"%@%@%@%@",dic[@"address"][@"provincial"],dic[@"address"][@"city"],dic[@"address"][@"address"],dic[@"address"][@"county"]];
            _addressString = dic[@"address"][@"address"];
            _hospitalID = dic[@"id"];
            _firstCharactor = [self firstCharactor:_hospitalName];
            _provincial = dic[@"address"][@"provincial"];
            _city = dic[@"address"][@"city"];
            
            _address = dic[@"address"][@"address"];
        }
        
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
    [aCoder encodeObject:self.hospitalName forKey:@"hospitalName"];
    [aCoder encodeObject:self.addressString forKey:@"addressString"];
    [aCoder encodeObject:self.hospitalID forKey:@"hospitalID"];
    [aCoder encodeObject:self.firstCharactor forKey:@"firstCharactor"];
    [aCoder encodeObject:self.provincial forKey:@"provincial"];
    [aCoder encodeObject:self.city forKey:@"city"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.hospitalName = [aDecoder decodeObjectForKey:@"hospitalName"];
        self.addressString = [aDecoder decodeObjectForKey:@"addressString"];
        self.hospitalID = [aDecoder decodeObjectForKey:@"hospitalID"];
        self.firstCharactor = [aDecoder decodeObjectForKey:@"firstCharactor"];
        self.provincial = [aDecoder decodeObjectForKey:@"provincial"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
    }
    return self;
}

@end
