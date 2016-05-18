//
//  CommonBll.h
//  errand
//
//  Created by gravel on 16/2/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "RequestUtil.h"

@interface CommonBll : RequestUtil

- (void)getProductionsData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

- (void)getDistributionData:(void (^)(NSArray *arr))successArr Province:(NSString*)province City:(NSString*)city viewCtrl:(id)viewCtrl;

- (void)getdistriData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

- (void)getCompetitionProductionData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

- (void)getCompetitionHospitalData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

- (void)getCompetitionDoctorsData:(void (^)(NSArray *arr))successArr  hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl;
@end
