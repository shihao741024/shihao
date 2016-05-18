//
//  PullSelectTableView.m
//  errand
//
//  Created by pro on 16/4/13.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "PullSelectTableView.h"

@interface PullSelectTableView()

@property (nonatomic, copy) void(^selectedIndexPathCB)(NSIndexPath *indexPath);

@end

@implementation PullSelectTableView

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 44*3) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self addSubview:_tableView];
    _tableView.layer.borderWidth = 0.5;
    _tableView.layer.borderColor = COMMON_FONT_GRAY_COLOR.CGColor;
    _tableView.backgroundColor = kTableViewColor;
    
    //设置cell分割线靠左
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
//设置cell分割线靠左
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    CenterLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[CenterLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.centerLabel.text = _titleArray[indexPath.row];
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
    return 44;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation CenterLabelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.backgroundColor = kTableViewColor;
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = COMMON_FONT_BLACK_COLOR;
        _centerLabel.font = GDBFont(15);
        [self.contentView addSubview:_centerLabel];
    }
    return self;
}

@end
