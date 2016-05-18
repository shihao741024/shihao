//
//  MissionBll.h
//  errand
//
//  Created by gravel on 15/12/11.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "MissionModel.h"
#import "MissionDetailModel.h"
@interface MissionBll : RequestUtil


/**
 *  获取我的出差管理列表
 *
 *  @param successArr 回调数组
 *  @param type       类型  0我提交的  1我处理的
 *  @param pageIndex  页索引
 */
-(void)getAllMissionData:(void (^)(NSArray *arr))successArr type:(int)type  pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;

//获取我接收的数量
- (void)getMissionCount:(void (^)(int result))result viewCtrl:(id)viewCtrl;
/**
 *   提交出差申请
 *
 *  @param successArr 回调数组
 *  @param type       类型  0我提交的  1我处理的
 *  @param pageIndex  页索引
 */

-(void)addMissionData:(void (^)(int  result, MissionModel *model))result  start:(NSString*)start dest:(NSString*)dest travelMode:(int)travelMode  content:(NSString*)content startDate:(NSString*)startDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl;

/**
 *  /出差管理列表详情
 *
 *  @param result    result description
 *  @param missionID missionID description
 */

-(void)getDetailMissionData:(void (^)(MissionDetailModel  *model))result  missionID:(NSNumber*)missionID viewCtrl:(id)viewCtrl;


- (void)dealMissionData:(void(^)(int result, id responseObj))result failure:(void(^)(int failure))failure MissionID:(NSNumber*)MissionID dealType:(int)dealType message:(NSString*)message viewCtrl:(id)viewCtrl;

- (void)deleteMissionData:(void(^)(int result))result MissionID:(NSNumber*)MissionID viewCtrl:(id)viewCtrl;

//
- (void)getSearchMissionData:(void (^)(NSArray *arr))successArr type:(int)type pageIndex:(int)pageIndex start:(NSString*)start  dest:(NSString*)dest content:(NSString *)content  startDate:(NSString *)startDate  endDate:(NSString *)endDate  travelMode:(NSNumber*)travelMode status:(NSNumber*)status viewCtrl:(id)viewCtrl;

//编辑页面
- (void)editMissionData:(void (^)(MissionModel *model))result missionID:(NSNumber*)missionID start:(NSString*)start dest:(NSString*)dest travelMode:(int)travelMode content:(NSString*)content startDate:(NSString*)startDate endDate:(NSString*)endDate viewCtrl:(id)viewCtrl;

@end
