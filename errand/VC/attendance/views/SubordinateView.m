//
//  SubordinateView.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SubordinateView.h"
#import "StaffModel.h"

@implementation SubordinateView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiConfig];
        
    }
    return self;
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = 0;
    [self addSubview:_tableView];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.textLabel.font = GDBFont(15);
        cell.textLabel.textColor = COMMON_FONT_BLACK_COLOR;
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"name"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
    _selectIndex(indexPath.row);
}

- (void)selectIndexAction:(void (^)(NSInteger))action
{
    _selectIndex = [action copy];
}

- (void)reloadData:(NSMutableArray *)dataArray;
{
    
    _dataArray = dataArray;
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)reloadDataWithModelArray:(NSMutableArray *)dataArray
{
    
    NSMutableArray *dicArray = [NSMutableArray array];
    for (StaffModel *model in dataArray) {
        [dicArray addObject:[model getModelDic]];
    }
    _dataArray = dicArray;
    [_tableView reloadData];
}

- (void)reloadDataWithSubordinateArray:(NSMutableArray *)nameArray
{
    NSMutableArray *dicArray = [NSMutableArray array];
    for (NSString *name in nameArray) {
        [dicArray addObject:@{@"name": name}];
    }
    _dataArray = dicArray;
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
