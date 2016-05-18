//
//  TaskModel.h
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property(nonatomic, copy)NSString *createDate;
@property(nonatomic, copy)NSString *taskName;
@property(nonatomic, copy)NSString *phoneNumber;
@property(nonatomic, copy)NSString *receiverName;
@property(nonatomic, copy)NSString *stauts;
@property(nonatomic, copy)NSString *contentStr;
@property(nonatomic, copy)NSString *planCompleteDate;
@property(nonatomic, copy)NSNumber *taskID;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic, copy)NSString *priority;
@property(nonatomic, copy)NSString *releaser;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
