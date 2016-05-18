//
//  StaffView.m
//  errand
//
//  Created by gravel on 16/2/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SelectStaffView.h"
//#import "AttendanceBll.h"

@implementation SelectStaffView{
    
    int pageIndex;
    MBProgressHUD *HUD;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIView *_bgView;
    SRRefreshView *_slimeView;
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
        //下属的表格
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, SCREEN_HEIGHT -40)];
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
        [self createSlime];
        [self createMJ];
    }else{
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _tableView.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 40);
    }
}

- (void)initData{

    if (pageIndex == 0 ) {
        [self showHintInView:self];
        pageIndex = 1;
    }else if (pageIndex == 1){
        [self showInfica];
    }else{
        [self showInfica];
    }
    AttendanceBll *bll = [[AttendanceBll alloc]init];
    [bll getStaffInfo:^(NSArray *array) {
        
        if (pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        [self hideHud];
        [_tableView reloadData];
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    } pageIndex:pageIndex viewCtrl:self];
}
-(void)createSlime{
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset =0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor grayColor];
    _slimeView.slime.skinColor = [UIColor grayColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor grayColor];
    
    [_tableView addSubview:_slimeView];
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
    
    StaffInfoModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.staffInfoName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffInfoModel *model = _dataArray[indexPath.row];
    if([self.delegate respondsToSelector:@selector(selectStaffWithName:andTelephone:andID:)]){
        [self.delegate selectStaffWithName:model.staffInfoName andTelephone:model.staffInfoTele andID:model.staffInfoID];
    }
//    _staffLbl.text = model.staffInfoName;
//    _staffTele = model.staffInfoTele;
    [_delegate selectStaffWithInfo:model];
    
    _bgView.frame = CGRectZero;
    _tableView.frame = CGRectZero;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 50)];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 0, 40, 50)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 50)];
    view.backgroundColor = COMMON_BLUE_COLOR;
    headerLabel.text = @"请选择下属员工";
    [view addSubview:headerLabel];
    return view;
}
- (void)backButtonClick{
    
    _bgView.frame = CGRectZero;
    _tableView.frame = CGRectZero;
    
}
- (void)showHintInView:(UIView*)v{
    [self showHudInView:v hint:NSLocalizedString(@"Loading", @"Loading")];
}
- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    [self showInfica];
    HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelColor=[UIColor grayColor];
    HUD.labelText = hint;
    
    HUD.labelFont=[UIFont systemFontOfSize:12.0];
    HUD.color=[UIColor clearColor];
    [view addSubview:HUD];
    [HUD show:YES];
}
- (void)hideHud   {
    [self hideInfica];
    [HUD hide:YES];
    
}
-(void)showInfica{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)hideInfica{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
//清除不需要的行
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = COMMON_BACK_COLOR;
    [tableView setTableFooterView:view];
    
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    pageIndex=1;
    [self initData];
    
}
#pragma mark 上拉加载
-(void)createMJ{
    __block  SelectStaffView *staffview = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [staffview initData];
    }];
}

@end
