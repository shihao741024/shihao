//
//  SalesStatisticsChildViewController.h
//  errand
//
//  Created by gravel on 15/12/19.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "SalesStatisticsModel.h"
#import "StatisticsCountModel.h"

@interface SalesStatisticsChildViewController : BaseNoTabViewController

@property (nonatomic, assign)int type;

@property (nonatomic, strong)SalesStatisticsModel *salesStatisticsModel;

@property (nonatomic, strong)StatisticsCountModel *statisticsCountModel;

@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, strong) NSDictionary *paraDic;

@property (nonatomic, strong) NSDictionary *saveDic;

- (void)searchActionRefreshData;

- (void)addFinishRefreshData;

@end
