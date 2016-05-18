//
//  StaffModel.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject

@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *staffName;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *phoneNumber;
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *departmentName;
@property(nonatomic,copy)NSString *positionName;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *firstCharactor;

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSDictionary *originalDic;

//用来判断是否被选中
@property (nonatomic)BOOL mSelect;
- (instancetype)initWithDic:(NSDictionary*)dic;

- (NSDictionary *)getModelDic;

@end
