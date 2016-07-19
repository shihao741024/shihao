//
//  ContactsBll.h
//  errand
//
//  Created by 医路同行Mac1 on 16/6/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "RequestUtil.h"
#import "RequestUtil.h"
#import "HospitalDetailModel.h"

@interface ContactsBll : RequestUtil
//获取通讯录首页医院的信息
- (void)getAllContactsData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;
//获取搜索医生的结果
- (void)getSearchDoctorsResult:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex keywords:(NSString *)keywords kind:(NSString *)kind department:(NSString *)department viewCtrl:(id)viewCtrl;
//获取搜索医院的结果
- (void)getSearchHospitalsResult:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex keywords:(NSString *)keywords kind:(NSString *)kind hospitalrank:(NSString *)hospitalrank province:(NSString *)province city:(NSString *)city viewCtrl:(id)viewCtrl;


//获取医院详情数据
- (void)getHospitalDetail:(void (^)(HospitalDetailModel *model))result hospitalID:(NSNumber*)hospitalID pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;
//获取选择医院的数据
- (void)gethospitalsData:(void (^)(NSArray *arr))successArr productID:(NSNumber*)productID pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;
//获取选择医院的数据, type == 7
- (void)getTypeHospitalsData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;


//竞品医院查询 type == 5
- (void)getCompetitionHospitalData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;

@end
