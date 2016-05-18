//
//  PullSelectTableView.h
//  errand
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterLabelTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *centerLabel;

@end

@interface PullSelectTableView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray;

- (void)selectedIndexPathAction:(void(^)(NSIndexPath *indexPath))action;

@end
