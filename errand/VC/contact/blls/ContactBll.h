//
//  ContactBll.h
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "HospitalDetailModel.h"
@interface ContactBll : RequestUtil

- (void)searchDoctorInHospital:(void (^)(NSArray *arr))successArr hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl null:(void(^)())null;

- (void)getAllContactDataData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;

- (void)getHospitalDetail:(void (^)(HospitalDetailModel *model))result hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl;

- (void)getHospitalDoctor:(void (^)(NSArray *arr))successArr hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl;

- (void)gethospitalsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID viewCtrl:(id)viewCtrl;

-(void)getChoosedoctorsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl null:(void(^)())null;

- (void)getTypeHospitalsData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

@end
