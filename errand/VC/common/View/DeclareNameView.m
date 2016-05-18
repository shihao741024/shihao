//
//  DeclareNameView.m
//  errand
//
//  Created by wjjxx on 16/3/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DeclareNameView.h"

@implementation DeclareNameView{

    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIView *_bgView;
    UILabel *_headerLabel;
    UILabel *_lineLabel;
    UIButton *_backButton;
   
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createStaffView];
    }
    return self;
}

#pragma mark ---- StaffView  用于选择下属员工
- (void)createStaffView{
    _dataArray = [NSMutableArray array];
    
    if (_bgView == nil) {
        //有透明度的背景
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.7;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_bgView];
        
        
        
        _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 50)];
        _headerLabel.backgroundColor = [UIColor whiteColor];
        _headerLabel.text = @"   项目名称";
        _headerLabel.font = [UIFont boldSystemFontOfSize:20];
        _headerLabel.textColor = COMMON_BLUE_COLOR;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_headerLabel];
        
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20, 2)];
        _lineLabel.backgroundColor = COMMON_BLUE_COLOR;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_lineLabel];
        
        
        //下属的表格
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 72, SCREEN_WIDTH - 20, SCREEN_HEIGHT -72-10)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [[[UIApplication sharedApplication] keyWindow] addSubview:_tableView];
        [self setExtraCellLineHidden:_tableView];
        [self initData];
        
    }else{
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _tableView.frame = CGRectMake(10, 72, SCREEN_WIDTH - 20, SCREEN_HEIGHT -72-10);
    }
    
    
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 50, 50)];
    _backButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _backButton.backgroundColor = [UIColor whiteColor];
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
    [_backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_backButton];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initData{
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"DeclareNameList" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [_tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if([self.delegate respondsToSelector:@selector(selectDeclareName:)]){
        [self.delegate selectDeclareName:_dataArray[indexPath.row]];
    }
    _bgView.frame = CGRectZero;
    _tableView.frame = CGRectZero;
    _headerLabel.frame = CGRectZero;
    _lineLabel.frame = CGRectZero;
    _backButton.frame = CGRectZero;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)backButtonClick{
    
    _bgView.frame = CGRectZero;
    _tableView.frame = CGRectZero;
    _headerLabel.frame = CGRectZero;
    _lineLabel.frame = CGRectZero;
    _backButton.frame = CGRectZero;
    
}

//清除不需要的行
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = COMMON_BACK_COLOR;
    [tableView setTableFooterView:view];
    
}
@end
