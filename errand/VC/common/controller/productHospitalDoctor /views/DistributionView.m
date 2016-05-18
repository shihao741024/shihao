//
//  DistributionView.m
//  errand
//
//  Created by gravel on 16/2/24.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DistributionView.h"
#import "CommonBll.h"
#import "DistriModel.h"
@implementation DistributionView
{
    
    MBProgressHUD *HUD;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIView *_bgView;
    UILabel *_headerLabel;
    UILabel *_lineLabel;
    UIButton *_backButton;
}


- (instancetype)initWithFrame:(CGRect)frame provincial:(NSString*)provincial city:(NSString*)city{
    if (self = [super initWithFrame:frame]) {
        _provincial = provincial;
        _city = city;
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
        _headerLabel.text = @"   配送商";
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
   [self showHintInView:[[UIApplication sharedApplication] keyWindow]];
    CommonBll *commonBll = [[CommonBll alloc]init];
    [commonBll getDistributionData:^(NSArray *arr) {
      [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          [_dataArray addObject:obj];
      }];
        if (_dataArray.count == 0) {
            [Dialog simpleToast:@"没有合适的供应商，请手工填写"];
        }
        [_tableView reloadData];
        [self hideHud];
    } Province:_provincial City:_city viewCtrl:self];
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
    
    DistriModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.vendor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DistriModel *model = _dataArray[indexPath.row];
    if([self.delegate respondsToSelector:@selector(selectPss:)]){
        [self.delegate selectPss:model.vendor];
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
    [self hideHud];
    _bgView.frame = CGRectZero;
    _tableView.frame = CGRectZero;
    _headerLabel.frame = CGRectZero;
    _lineLabel.frame = CGRectZero;
    _backButton.frame = CGRectZero;
    
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

@end
