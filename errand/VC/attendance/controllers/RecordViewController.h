//
//  MyRecordViewController.h
//  errand
//
//  Created by gravel on 15/12/29.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SRRefreshView *slimeView;

@property (nonatomic, assign)int type;//0 我的考勤记录 1 下属考勤记录
@end
