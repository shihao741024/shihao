//
//  ContactModel.h
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *hospitalName;
@property(nonatomic,copy)NSString *addressString;
@property(nonatomic,strong)NSNumber *hospitalID;
@property(nonatomic,copy)NSString *firstCharactor;
@property(nonatomic,copy)NSString *provincial;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *address;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
