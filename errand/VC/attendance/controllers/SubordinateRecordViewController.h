//
//  SubordinateRecordViewController.h
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "SubordinateView.h"
#import "SubordinateDateSelectView.h"

//tableView的头部视图
@interface TableViewHeaderView : UITableViewHeaderFooterView

@property (nonnull, strong) UILabel *titleLabel;

@end


@interface SubordinateRecordViewController : UIViewController

//右边的下属View
@property (nonnull, strong) SubordinateView *subordinateView;
//上边的切换日期View
@property (nonnull, strong) SubordinateDateSelectView *dateSelectView;
@property (nonnull, strong) UITableView *tableView;

@property (nonnull, strong) NSMutableArray *dataArray;

@end
