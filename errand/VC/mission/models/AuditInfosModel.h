//
//  AuditInfosModel.h
//  errand
//
//  Created by wjjxx on 16/3/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuditInfosModel : NSObject

//*审批的时间*/
@property(nonatomic,copy)NSString *auditDate;
//*审批的信息*/
@property(nonatomic,copy)NSString *message;
//*审批人的名字或部门的名字*/
@property(nonatomic,copy)NSString *name;
//*审批人id*/
@property(nonatomic,strong)NSNumber *auditID;
//*状态*/
@property(nonatomic,strong)NSNumber *status;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
