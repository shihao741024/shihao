//
//  DistriSelectView.m
//  errand
//
//  Created by 高道斌 on 16/4/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DistriSelectView.h"

@interface DistriSelectView()

@property (nonatomic, copy) void(^selectedIndexPathCB)(NSIndexPath *indexPath);

@end

@implementation DistriSelectView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = titleArray;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 190, 30*5) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = 0;
    [self addSubview:_tableView];
    
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = COMMON_FONT_BLACK_COLOR.CGColor;
    _tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.selectionStyle = 0;
        cell.textLabel.font = GDBFont(15);
        cell.textLabel.textColor = COMMON_FONT_BLACK_COLOR;
    }
    cell.textLabel.text = _titleArray[indexPath.row][@"vendor"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidden = YES;
    _selectedIndexPathCB(indexPath);
}

- (void)selectedIndexPathAction:(void(^)(NSIndexPath *indexPath))action
{
    _selectedIndexPathCB = action;
}

- (void)realoadDataWithArray:(NSMutableArray *)titleArray
{
    _titleArray = titleArray;
    [_tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
