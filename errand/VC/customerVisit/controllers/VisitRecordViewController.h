//
//  VisitRecordViewController.h
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitRecordViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSDictionary *saveDic;

- (void)refreshData;

- (void)visitRecordWillAppear:(void(^)())action;

@end
