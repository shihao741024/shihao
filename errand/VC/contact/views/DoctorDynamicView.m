//
//  DoctorDynamicView.m
//  errand
//
//  Created by 高道斌 on 16/5/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorDynamicView.h"

@interface DoctorDynamicView()<UITableViewDelegate, UITableViewDataSource>
{
//    UITableView *_tableView;
    NSMutableArray *_heights;
}

@end

@implementation DoctorDynamicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dicArray = [NSMutableArray array];
        _dataArray = [NSMutableArray array];
        _heights = [NSMutableArray array];
        
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerButton.frame = CGRectMake((kWidth-100)/2.0, 0, 100, 40);
    [_footerButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [_footerButton setTitle:@"收回" forState:UIControlStateSelected];
    [_footerButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    [_footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_footerButton];
    _footerButton.titleLabel.font = GDBFont(14);
    _tableView.tableHeaderView = view;
}

- (void)footerButtonClick:(UIButton *)button
{
    _buttonClickCB(button);
}

- (void)reloadData:(id)responseObject pageIndex:(NSInteger)pageIndex
{
    if (pageIndex == 1) {
        [_dicArray removeAllObjects];
    }
    [_dicArray addObjectsFromArray:[NSArray arrayWithArray:responseObject[@"content"]]];
    
    _dataArray = [NSMutableArray array];
    
    _heights = [NSMutableArray array];
    
    
    CGFloat sumHeight = 0.0;
    
    if (_dicArray.count != 0) {
        sumHeight = 27.0;
        [_dataArray addObject:@"动态"];
        [_heights addObject:@27];
    }
    
    
    
    for (NSDictionary *dic in _dicArray) {
        NSTimeInterval timetamp = [dic[@"visitDate"] doubleValue]/1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timetamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter stringFromDate:date];
        
        NSString *str = [NSString stringWithFormat:@"%@  %@  拜访总结：%@", dateStr, dic[@"belongTo"][@"name"], dic[@"summary"]];
//        NSString *str = @"FunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunctionFunction";
        CGSize size = [Function sizeOfStr:str andFont:GDBFont(14) andMaxSize:CGSizeMake(kWidth-30, CGFLOAT_MAX)];
        
        CGFloat height = size.height+10;
        
        [_dataArray addObject:str];
        [_heights addObject:[NSNumber numberWithFloat:height]];
        
        sumHeight = sumHeight+height;
    }
    
    
    self.frame = CGRectMake(0, 0, kWidth, sumHeight+40);
    _tableView.frame = CGRectMake(0, 0, kWidth, sumHeight+40);
    _changeSelfHeightCB(sumHeight+40);
    [_tableView reloadData];
    
    
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = 0;
        cell.backgroundColor = COMMON_BACK_COLOR;
        cell.textLabel.font = GDBFont(14);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 27)];
        label.tag = 1242342;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        label.textColor = COMMON_BLUE_COLOR;
        
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1242342];
    
    
    if (indexPath.row == 0) {
        cell.textLabel.hidden = YES;
        label.hidden = NO;
        label.text = _dataArray[indexPath.row];
        cell.textLabel.text = @"";
        
    }else {
        cell.textLabel.hidden = NO;
        label.hidden = YES;
        label.text = @"";
    }
    
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
    return [_heights[indexPath.row] floatValue];
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
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
