//
//  CustomerVisitBll.h
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "CustomerVisitModel.h"
#import "VisitManagerModel.h"
#import "VisitDetailModel.h"
@interface CustomerVisitBll : RequestUtil

-(void)getAllCustomerVisitData:(void (^)(int totalElements,NSArray *arr))successArr  pageIndex:(int)pageIndex visitDate:(NSString*)visitDate category:(NSNumber*)category viewCtrl:(id)viewCtrl;
//获得拜访详情页数据
- (void)getCustomerVisitDetailData:(void (^)(VisitDetailModel *model))result visitID:(NSNumber*)visitID viewCtrl:(id)viewCtrl;

-(void)addCustomerVisitData:(void (^)(CustomerVisitModel *model))result  Hospital:(NSNumber*)Hospital doctor:(NSNumber*)doctor production:(NSNumber*)production visitDate:(NSString*)visitDate  content:(NSString*)content category:(NSNumber*)category viewCtrl:(id)viewCtrl;

- (void)addSigninData:(void (^)(NSDictionary *result))result category:(int)category visitID:(NSNumber*)visitID longitude:(NSString*)longitude latitude:(NSString*)latitude name:(NSString*)name Message:(NSString *)Message viewCtrl:(id)viewCtrl;

- (void)getAllVisitManagerData:(void(^)(NSArray *arr))sucessManager startDate:(NSString*)startDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl;

@end
