//
//  UIViewController+CreateGeneralView.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "UIViewController+CreateGeneralView.h"

@implementation UIViewController (CreateGeneralView)

- (UITableView *)createGeneralTableView:(CGRect)frame style:(UITableViewStyle)style
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    return tableView;
}

- (void)createRightItemTitle:(NSString *)title
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItemTitleClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightItemTitleClick
{
    
}

@end
