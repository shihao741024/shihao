//
//  TaskEdittingViewController.h
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DeclareModel.h"
#import "SalesStatisticsModel.h"
@interface TaskEdittingViewController : UIViewController

@property (nonatomic, retain) NSArray *dataArray;

@property (nonatomic, assign) int type;//0 任务交办  1 费用申报  3 销售统计 4 客户拜访

@property (nonatomic, assign) int salesStatisticsType;//0 销售上报  1 传销上报  2 竞品上报

@property (nonatomic, strong)SalesStatisticsModel *salesStatisticsModel;

@property (nonatomic, copy)void (^feedBackBlock)(TaskModel *taskModel);

@property (nonatomic, copy)void (^feedBackDeclareBlock)(DeclareModel *declareModel);

@property (nonatomic, copy)void (^feedBackSalesStatisticsBlock)(SalesStatisticsModel *salesStatisticsModel);

@property (nonatomic, copy) void(^editFinishRefreshCB)();
@property (nonatomic, strong) id editModel;


@property (nonatomic, copy)void (^feedBackBlockTaskModels)(NSArray<TaskModel *> *models);

@end
