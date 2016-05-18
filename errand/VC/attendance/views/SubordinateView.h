//
//  SubordinateView.h
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubordinateView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)reloadData:(NSMutableArray *)dataArray;

@property (nonatomic, copy) void(^selectIndex)(NSInteger index);

- (void)selectIndexAction:(void(^)(NSInteger index))action;

- (void)reloadDataWithModelArray:(NSMutableArray *)dataArray;

- (void)reloadDataWithSubordinateArray:(NSMutableArray *)nameArray;

@end
