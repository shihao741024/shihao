//
//  AttendanceBll.h
//  errand
//
//  Created by gravel on 15/12/28.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "MyRecordModel.h"
#import "StaffRecordModel.h"
#import "StaffInfoModel.h"
@interface AttendanceBll : RequestUtil

//@property (nonatomic, strong) NSMutableArray *dataArray;

-(void)addAttendanceData:(void (^)(MyRecordModel *model))result  longitude:(NSString*)longitude latitude:(NSString*)latitude name:(NSString*)name viewCtrl:(id)viewCtrl;

//获取所有的考勤记录
-(void)getRecordData:(void (^)( NSArray  *array))result  type:(int)type pageIndex:(int)pageIndex startDate:(NSString *)startDate endDate:(NSString *)endDate viewCtrl:(id)viewCtrl;

//获取今天考勤记录的方法
-(void)getTodayRecordData:(void (^)( NSArray  *array, int totalElements))result  type:(int)type pageIndex:(int)pageIndex startDate:(NSString *)startDate  endDate:(NSString*)endDate viewCtrl:(id)viewCtrl;

//获取搜索的考勤记录
-(void)getRealSearchRecordData:(void (^)( NSArray  *array))result  type:(int)type pageIndex:(int)pageIndex startDate:(NSString *)startDate  endDate:(NSString*)endDate  staffStr:(NSString*)staffStr viewCtrl:(id)viewCtrl;

- (void)getStaffInfo:(void (^)( NSArray  *array))result pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;

@end
