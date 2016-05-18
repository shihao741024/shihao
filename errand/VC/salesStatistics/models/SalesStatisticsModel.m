
//
//  SalesStatisticsModel.m
//  errand
//
//  Created by gravel on 15/12/21.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SalesStatisticsModel.h"

@implementation SalesStatisticsModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        if (dic[@"uploadDate"] !=[NSNull null]){
             _dateString = dic[@"uploadDate"];
        }else{
            _dateString =@"无数据";
        }
        _packageUnit = dic[@"production"][@"packageUnit"];
        //success null
        _pillName = [NSString stringWithFormat:@"%@(%@)",dic[@"production"][@"name"],dic[@"production"][@"specification"]] ;
        
        _productName = dic[@"production"][@"name"];
        _specification = dic[@"production"][@"specification"];
        
        _amountString = [NSString stringWithFormat:@"%@",dic[@"count"]];
        
        //success null
        _hospitalName = dic[@"hospital"][@"name"];
        
        
        if ([Function isBlankStrOrNull:dic[@"pss"]]) {
            _buyerString = @"配送商：无";
        }else{
            _buyerString = dic[@"pss"];
        }
        
        if (![Function isNullOrNil:dic[@"price"]]) {
            _price = [NSString stringWithFormat:@"%.2f", [dic[@"price"] floatValue]];
        }
        
        
        _salesStatisticsID = dic[@"id"];
        
        _productionID = dic[@"production"][@"id"];
        
        _hospitalID = dic[@"hospital"][@"id"];
        if ( dic[@"hospital"][@"address"]!= [NSNull null]) {
            _provincial =  dic[@"hospital"][@"address"][@"provincial"];
            _city = dic[@"hospital"][@"address"][@"city"];
        }else{
            _provincial =  @"";
            _city = @"";
        }
        
        
        if (dic[@"doctor"] !=[NSNull null]) {
            _doctorID =  dic[@"doctor"][@"id"];
            _name = dic[@"doctor"][@"name"];
            _office = dic[@"doctor"][@"office"];
        }
//        _doctorID = dic[@"doctor"][@"id"];
        
    }
    return self;
}
@end
