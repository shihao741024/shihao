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

//获取选择医生的数据
- (void)searchDoctorInHospital:(void (^)(NSArray *arr))successArr hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl null:(void(^)())null;
//获取通讯录首页数据
- (void)getAllContactDataData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;
//获取医院详情数据
- (void)getHospitalDetail:(void (^)(HospitalDetailModel *model))result hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl;
//获取医院医生数据
- (void)getHospitalDoctor:(void (^)(NSArray *arr))successArr hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl;
//获取选择医院的数据
- (void)gethospitalsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID viewCtrl:(id)viewCtrl;
//获取选择医生的数据
-(void)getChoosedoctorsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID hospitalID:(NSNumber*)hospitalID viewCtrl:(id)viewCtrl null:(void(^)())null;
//获取选择医院的数据, type == 7
- (void)getTypeHospitalsData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

@end
