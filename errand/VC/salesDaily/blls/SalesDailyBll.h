//
//  SalesDailyBll.h
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "SalesDailyModel.h"
#import "CommentModel.h"
#import "VisitManagerModel.h"
@interface SalesDailyBll : RequestUtil

//获取大厅全部信息
- (void)getAllStatisticsData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex category:(NSNumber*)category viewCtrl:(id)viewCtrl;

//先上传图片，成功后发表动态
- (void)getQiniuTokenWithImgArray:(NSArray*)ImgArray  successArrBlock:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

//发表日报
- (void)addsalesDailyData:(void (^)(SalesDailyModel *model))result content:(NSString*)content selectStaffArray:(NSArray *)selectStaffArry selectDepartmentArray:(NSArray *)selectDepartmentArray category:(NSNumber*)category sendingPlace:(NSString *)sendingPlace open:(NSNumber*)open pics:(NSArray*)pics viewCtrl:(id)viewCtrl organization:(NSString *)organization organID:(NSNumber *)organID;
//发表评论
- (void)createCommentData:(void (^)(CommentModel *model))result sid:(NSNumber*)sid sname:(NSString*)sname tid:(NSNumber*)tid tname:(NSString*)tname reportID:(NSNumber *)reportID  content:(NSString *)content selectStaffArray:(NSArray *)selectStaffArry selectDepartmentArray:(NSArray *)selectDepartmentArray viewCtrl:(id)viewCtrl;
//At我的
- (void)getAtmeData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;
//评论我的  我评论的
- (void)getCommentmeData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex type:(int)type viewCtrl:(id)viewCtrl;


- (void)getReportDetailData:(void (^)(SalesDailyModel *model))result reportID:(NSNumber *)reportID viewCtrl:(id)viewCtrl;

//日报统计
- (void)getReportCountData:(void (^)(NSArray *arr))successArr beingDate:(NSString *)beingDate  oids:(NSArray *)oids ids:(NSArray*)ids viewCtrl:(id)viewCtrl;

//下级所有员工包含学徒
- (void)getMyMemberData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl null:(void(^)())null;

//下级部门
- (void)getMyTreeData:(void (^)(NSArray *arr))successArr viewCtrl:(id)viewCtrl;

//搜索大厅的数据
- (void)getHallSearchData:(void (^)(NSArray *arr))successArr pageIndex:(int)pageIndex category:(NSNumber*)category content:(NSString*)content beingDate:(NSString *)beingDate  endDate:(NSString *)endDate  oids:(NSArray *)oids ids:(NSArray*)ids viewCtrl:(id)viewCtrl;

//删除日报
- (void)deleteReport:(void (^)(int  result))result reportID:(NSNumber*)reportID viewCtrl:(id)viewCtrl;

@end
