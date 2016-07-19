//
//  StatisticsEdittingVC.h
//  errand
//
//  Created by wjjxx on 16/2/24.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesStatisticsModel.h"
@interface StatisticsEdittingVC : UIViewController

@property (nonatomic, retain) NSArray *dataArray;

@property (nonatomic, assign) int salesStatisticsType;//0 购进上报  1 纯销上报  2 竞品上报

@property (nonatomic, strong)SalesStatisticsModel *salesStatisticsModel;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic, copy)void (^feedBackSalesStatisticsBlock)(SalesStatisticsModel *salesStatisticsModel);

@property (nonatomic, copy)void (^feedBackEditSalesStatisticsBlock)(NSIndexPath *changeIndexPath ,SalesStatisticsModel *salesStatisticsModel);

@end
