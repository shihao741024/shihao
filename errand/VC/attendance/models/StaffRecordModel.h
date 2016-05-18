//
//  StaffRecordModel.h
//  errand
//
//  Created by gravel on 15/12/29.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffRecordModel : NSObject

@property (nonatomic, strong)NSString *addressStr;
@property (nonatomic, strong)NSString *NameStr;
@property (nonatomic, strong)NSString *timeStr;
//@property (nonatomic, strong)NSString *detailTimeStr;
@property (nonatomic, strong) NSString *flagTimeStr;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
