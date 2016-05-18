//
//  SalesStaticsBll.h
//  errand
//
//  Created by gravel on 15/12/21.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "SalesStatisticsModel.h"
#import "ProductionModel.h"
#import "ContactBll.h"
#import "ContactModel.h"
#import "DoctorsModel.h"
@interface SalesStatisticsBll : RequestUtil

-(void)getAllsalesStatisticsData:(void (^)(NSArray *arr))successArr  pageIndex:(int)pageIndex category:(int)category hospitalID:(NSNumber*)hospitalID productionID:(NSNumber*)productionID beginDate:(NSString *)beginDate endDate:(NSString *)endDate doctorId:(NSNumber *)doctorId viewCtrl:(id)viewCtrl;

-(void)getAllsalesStatisticsData:(void (^)(NSArray *arr))successArr  pageIndex:(int)pageIndex category:(int)category dic:(NSDictionary *)dic viewCtrl:(id)viewCtrl;

-(void)addsalesStatisticsData:(void (^)(SalesStatisticsModel *model))result  ContactModel:(ContactModel*)contactModel doctorsModel:(DoctorsModel*)doctorsModel productionModel:(ProductionModel*)productionModel count:(NSString*)count pss:(NSString*)pss category:(NSNumber*)category upDate:(NSString*)upDate price:(NSString *)price viewCtrl:(id)viewCtrl;

- (void)deletesalesStatisticsData:(void (^)(int result))result salesStatisticsID:(NSNumber*)salesStatisticsID viewCtrl:(id)viewCtrl;

- (void)editsalesStatisticsData:(void (^)(SalesStatisticsModel *model))result salesStatisticsID:(NSNumber*)salesStatisticsID hospitalID:(NSNumber*)hospitalID hospitalName:(NSString*)hospitalName provincial:(NSString*)provincial city:(NSString*)city doctorID:(NSNumber*)doctorID doctorName:(NSString*)doctorName office:(NSString*)office productID:(NSNumber*)productID specification:(NSString *)specification productName:(NSString*)productName count:(NSString*)count pss:(NSString*)pss category:(NSNumber*)category upDate:(NSString*)upDate price:(NSString *)price packageUnit:(NSString *)packageUnit viewCtrl:(id)viewCtrl;

- (void)getSalesCountData:(void (^)(NSArray *arr))successArr category:(int)category beginDate:(NSString*)beginDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl;

@end
