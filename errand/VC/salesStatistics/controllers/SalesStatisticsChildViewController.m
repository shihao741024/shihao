//
//  SalesStatisticsChildViewController.m
//  errand
//
//  Created by gravel on 15/12/19.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SalesStatisticsChildViewController.h"
#import "SalesStatisticsBll.h"
#import "TaskTableViewCell.h"
#import "XXTableViewCell.h"
#import "StatisticsEdittingVC.h"
#import "StatisticsCountVC.h"
@interface SalesStatisticsChildViewController ()<SRRefreshDelegate ,UITableViewDataSource,UITableViewDelegate, XXTableViewDelegate>{
    float navHeight;
    NSMutableArray *dataArray;
    int pageIndex;
    NSMutableArray *_cellsArray;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;

@end

@implementation SalesStatisticsChildViewController
@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_salesStatisticsModel) {
        [dataArray insertObject:_salesStatisticsModel atIndex:0];
        [_tableView reloadData];
        _salesStatisticsModel = nil;
    }
}

- (void)searchActionRefreshData
{
    pageIndex = 1;
    [self initData];
}


- (void)addFinishRefreshData
{
    pageIndex = 1;
    _paraDic = nil;
    [self initData];
}

-(void)initData{
  
    if(!pageIndex){
        [self showHintInView:self.view];
        pageIndex=1;
        
    }else if(pageIndex==1){
        
        [self showInfica];
    }else{
        [self showInfica];
    }
    
    //当_statisticsCountModel == nil的时候 说明不是汇总进去来的
    if (_statisticsCountModel == nil) {
        SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
        [salesBll getAllsalesStatisticsData:^(NSArray *arr) {
            
            if(pageIndex==1){
                
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self createCountIcon];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
            
        } pageIndex:pageIndex category:type dic:_paraDic viewCtrl:self];
        
//        [salesBll getAllsalesStatisticsData:^(NSArray *arr) {
//            
//        } pageIndex:pageIndex category:type hospitalID:@-100  productionID:@-100];
    }else{
        NSNumber *hospitalId = @0;
        NSNumber *doctorId = @0;
        if (type == 0) {
            hospitalId = _statisticsCountModel.hospitalID;
            doctorId = nil;
        }else {
            hospitalId = nil;
            doctorId = _statisticsCountModel.doctorId;
        }
        SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
        [salesBll getAllsalesStatisticsData:^(NSArray *arr) {
            if(pageIndex==1){
                
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } pageIndex:pageIndex category:type hospitalID:hospitalId productionID:_statisticsCountModel.pillID beginDate:_beginDate endDate:_endDate doctorId:doctorId viewCtrl:self];
    }
    
    
}
-(void)initView{
    dataArray=[[NSMutableArray alloc] init];
    _cellsArray = [NSMutableArray array];
    navHeight=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    float bottomHeight=SEG_HEIGHT;
    if (_statisticsCountModel == nil){
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-bottomHeight+2)];
    }else{
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
   
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self createSlime];
    [self createMJ];
    [self initData];
}

/**
 *  建立汇总的按钮
 */
- (void)createCountIcon{
    AmotButton *countButton = [[AmotButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 60, SCREEN_HEIGHT - 64  - 60, 60, 60)];
    [countButton setImage:[UIImage imageNamed:@"toggle"] forState:UIControlStateNormal];
    [countButton setImage:[UIImage imageNamed:@"toggle"] forState:UIControlStateSelected];
    [self.view addSubview:countButton];
    [countButton addTarget:self action:@selector(countButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  汇总按钮的点击事件
 */
- (void)countButtonClick{
    StatisticsCountVC *countVC = [[StatisticsCountVC alloc]init];
    if (type == 0) {
        
        countVC.title = NSLocalizedString(@"SalesCount", @"SalesCount");
        
    }else if (type == 1){
        
        countVC.title = NSLocalizedString(@"pureSalesCount", @"pureSalesCount");

    }else{
        countVC.title = NSLocalizedString(@"competeCount", @"competeCount");
    }
    countVC.type = type;
    [self.navigationController pushViewController:countVC animated:YES];
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
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (type == 1) {
        return 150;
    }else {
        return 150;
    }
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"cell";
    XXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[XXTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier andTag:indexPath.item];
        cell.delegateOfXXTableView = self;
        [_cellsArray addObject:cell];
    }
    cell.bgScrollView.contentOffset = CGPointMake(0, 0);
    SalesStatisticsModel *model=dataArray[indexPath.row];
    [cell setSalesStatisticsModel:model andType:type];
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //删除按钮的回调
    cell.deleteBtnClickBlock = ^(NSNumber* salesStatisticsID, XXTableViewCell *currentCell){
        
        
        NSIndexPath *indexPath = [tableView indexPathForCell:currentCell];
        SalesStatisticsModel *model=dataArray[indexPath.row];
        if (![Function inBeforeMonthFirstDay:model.dateString]) {
            
            [Dialog simpleToast:@"上报修改的有效期是上月至本月的数据"];
            return ;
        }
        
        SalesStatisticsBll *bll = [[SalesStatisticsBll alloc]init];
        [self showHintInView:self.view];
        [bll deletesalesStatisticsData:^(int result) {
            [self hideHud];
            [Dialog simpleToast:@"删除成功"];
            [dataArray removeObjectAtIndex:indexPath.item];
            
            [_tableView reloadData];
            //            [_tableView beginUpdates];
            //            [_tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]  withRowAnimation: UITableViewRowAnimationAutomatic];
            //            [_tableView endUpdates];
        } salesStatisticsID:salesStatisticsID viewCtrl:self];
    };
    
//    编辑按钮的回调
    cell.editBtnClickBlock = ^(NSNumber* salesStatisticsID, XXTableViewCell *currentCell){
        
        NSIndexPath *indexPath = [tableView indexPathForCell:currentCell];
        SalesStatisticsModel *model=dataArray[indexPath.row];
        if (![Function inBeforeMonthFirstDay:model.dateString]) {
            
            [Dialog simpleToast:@"上报修改的有效期是上月至本月的数据"];
            return ;
        }
        
        StatisticsEdittingVC *taskEditVC = [[StatisticsEdittingVC alloc] init];
        NSArray *dataArray2;
        // //0 销售上报  1 传销上报  2 竞品上报
        if ((type == 0)||(type == 2)) {
            if (type == 0) {
                taskEditVC.title=NSLocalizedString(@"salesReport", @"salesReport");
            }else{
                taskEditVC.title=NSLocalizedString(@"competeReport", @"competeReport");
            }
            dataArray2 = @[[NSString stringWithFormat:@"%@:", NSLocalizedString(@"productName", @"productName")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"selectCustomer", @"selectCustomer")],[NSString stringWithFormat:@"%@:",NSLocalizedString(@"upDate", @"upDate")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"productNum", @"productNum")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"distributBusiness", @"distributBusiness")], @"单价(元):"];
        }else if (type == 1){
            taskEditVC.title=NSLocalizedString(@"pureSalesReport", @"pureSalesReport");
            dataArray2 = @[[NSString stringWithFormat:@"%@:", NSLocalizedString(@"productName", @"productName")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"selectCustomer", @"selectCustomer")],[NSString stringWithFormat:@"%@:", NSLocalizedString(@"productNum", @"productNum")],[NSString stringWithFormat:@"%@:",NSLocalizedString(@"upDate", @"upDate")]];
        }
        taskEditVC.dataArray = dataArray2;
         taskEditVC.salesStatisticsModel = model;
        taskEditVC.salesStatisticsType = type;
        taskEditVC.indexPath = indexPath;
        [self.navigationController pushViewController:taskEditVC animated:YES];
        taskEditVC.feedBackEditSalesStatisticsBlock = ^(NSIndexPath *changeIndexPath ,SalesStatisticsModel *salesStatisticsModel){
            dataArray[changeIndexPath.row]  = salesStatisticsModel;
            
//            [_tableView reloadData];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:changeIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            [Dialog simpleToast:@"修改成功"];
        };
    };
    return  cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (XXTableViewCell *cell in _cellsArray) {
        if (cell.flag) {
            [UIView animateWithDuration:0.1 animations:^{
                cell.bgScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
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

#pragma mark - XXTableViewDelegate
// cell的点击方法
- (void)clickCellWithIndex:(NSInteger)index {
//    NSLog(@"dianji %lu", (long)index);
    for (XXTableViewCell *cell in _cellsArray) {
        if (cell.flag) {
            [UIView animateWithDuration:0.1 animations:^{
                cell.bgScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

- (void)isScrollViewInCellMove:(BOOL)flag andIndex:(NSInteger)index{
    for (XXTableViewCell *cell in _cellsArray) {
        if (cell.flag && cell.tag != index) {
            [UIView animateWithDuration:0.1 animations:^{
                cell.bgScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

#pragma mark 上拉加载
-(void)createMJ{
    __block  SalesStatisticsChildViewController *salesVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [salesVC initData];
    }];
}

@end
