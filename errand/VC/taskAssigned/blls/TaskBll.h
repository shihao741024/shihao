//
//  TaskBll.h
//  errand
//
//  Created by gravel on 15/12/16.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestUtil.h"
#import "TaskModel.h"
#import "TaskDetailModel.h"

@interface TaskBll : RequestUtil

/**
 *  获取我的任务交办列表
 *
 *  @param successArr 回调数组
 *  @param type       类型  0我提交的  1我处理的
 *  @param pageIndex  页索引
 *  @param pageSize   页容量
 */
-(void)getAllTaskData:(void (^)(NSArray *arr))successArr type:(int)type  pageIndex:(int)pageIndex viewCtrl:(id)viewCtrl;

-(void)addTaskData:(void (^)(NSArray<TaskModel *> *modelArray))result  to:(NSNumber*)to name:(NSString *)name telephone:telephone priority:(int)priority content:(NSString*)content title:(NSString*)title planCompleteDate:(NSString*)planCompleteDate viewCtrl:(id)viewCtrl tos:(NSArray *)tos;

-(void)getDetailTaskData:(void (^)(TaskDetailModel *model))result  taskID:(NSNumber*)taskID  viewCtrl:(id)viewCtrl;

- (void)dealTaskData:(void(^)(int result))result  taskID:(NSNumber*)taskID dealType:(int)dealType feedback:(NSString *)feedback viewCtrl:(id)viewCtrl;

- (void)getTaskSearchData:(void (^)(NSArray *arr))successArr  type:(int)type  pageIndex:(int)pageIndex title:(NSString *)title content:(NSString *)content category:(NSNumber*)category beingDate:(NSString *)beingDate  endDate:(NSString *)endDate  to:(NSNumber*)to viewCtrl:(id)viewCtrl;

@end
