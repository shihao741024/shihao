//
//  DistriSelectView.h
//  errand
//
//  Created by 高道斌 on 16/4/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistriSelectView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray;

- (void)selectedIndexPathAction:(void(^)(NSIndexPath *indexPath))action;

- (void)realoadDataWithArray:(NSMutableArray *)titleArray;

@end
