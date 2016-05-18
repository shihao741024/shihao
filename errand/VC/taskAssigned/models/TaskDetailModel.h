//
//  TaskDetailModel.h
//  errand
//
//  Created by gravel on 16/1/12.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetailModel : NSObject

@property(nonatomic, copy)NSString *createDate;
@property(nonatomic, copy)NSString *taskName;
@property(nonatomic, copy)NSString *phoneNumber;
//*下达任务的人*/
@property(nonatomic, copy)NSString *receiverName;
@property(nonatomic, copy)NSString *stauts;
@property(nonatomic, copy)NSString *contentStr;
@property(nonatomic, copy)NSString *planCompleteDate;
@property(nonatomic, copy)NSString *priority;
//审批流程
@property(nonatomic, copy)NSString *feedback;
- (instancetype)initWithDic:(NSDictionary *)dic;



@property(nonatomic, copy)NSString *toName;

@end
