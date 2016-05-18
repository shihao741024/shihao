//
//  StatisticsViewController.m
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "StatisticsViewController.h"
#import "SalesDailyBll.h"
#import "VisitManagerModel.h"
#import "VisitManagerTableViewCell.h"
#import "CountView.h"
#import "SelectStaffViewController.h"
#import "StaffModel.h"
#import "Node.h"
@interface StatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate,CountViewDelegate>

@end

@implementation StatisticsViewController{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    SRRefreshView  *_slimeView;
    NSString * _monday;
    NSString * _sunday;
    UINavigationBar *_navigationBar;
    CountView *_topBgView;
}

- ( void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UITabBarController *tbc = self.tabBarController;
    _navigationBar = tbc.navigationController.navigationBar;
    tbc.title = NSLocalizedString(@"dailyStatistics", @"dailyStatistics");
    [self createRightItem];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.rdv_tabBarController.tabBarHidden == NO) {
        _navigationBar.translucent = YES;
    }
}

- (void)createRightItem{
    UIButton * rightBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [rightBtnTwo addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITabBarController *tbc = self.tabBarController;
    tbc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnTwo];
}

- (void)searchClick{
    
    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc setSelectstaffArrayBlock:^(NSMutableArray *staffSelectArray) {
        [self showHintInView:self.view];
        NSMutableArray *oids = [NSMutableArray array];
        NSMutableArray *ids = [NSMutableArray array];
        for (StaffModel *staffModel in staffSelectArray) {
            [ids addObject:[NSNumber numberWithInt:[staffModel.ID intValue]]];
        }
//        for (Node *node in departmentArray) {
//            [oids addObject:[NSNumber numberWithInt:node.nodeId]];
//        }
        SalesDailyBll *bll = [[SalesDailyBll alloc]init];
        [bll getReportCountData:^(NSArray *arr) {
            
            [_dataArray removeAllObjects];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_dataArray addObject:obj];
            }];
            
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            
        } beingDate:_monday oids:nil ids:ids viewCtrl:self];
    }];
    /*
    vc.selectArrayBlock = ^(NSMutableArray *staffSelectArray,NSMutableArray *departmentArray){
        [self showHintInView:self.view];
        NSMutableArray *oids = [NSMutableArray array];
        NSMutableArray *ids = [NSMutableArray array];
        for (StaffModel *staffModel in staffSelectArray) {
            [ids addObject:[NSNumber numberWithInt:[staffModel.ID intValue]]];
        }
        for (Node *node in departmentArray) {
            [oids addObject:[NSNumber numberWithInt:node.nodeId]];
        }
        SalesDailyBll *bll = [[SalesDailyBll alloc]init];
        [bll getReportCountData:^(NSArray *arr) {
            
            [_dataArray removeAllObjects];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_dataArray addObject:obj];
            }];
            
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            
        } beingDate:_monday oids:oids ids:ids viewCtrl:self];
     };
     */


}
-(void)initData{
    
    
    [self showHintInView:self.view];
        
    
    
    SalesDailyBll *dailyBll = [[SalesDailyBll alloc]init];
    [dailyBll getReportCountData:^(NSArray *arr) {
        [_dataArray removeAllObjects];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        
        [_tableView reloadData];
        [self hideHud];
        [_slimeView endRefresh];

    } beingDate:_monday oids:nil ids:nil viewCtrl:self];
    
}

- (void)createView{

    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets =NO;
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self createSlime];
    [self createTopView];
    [self calculteDateOfMondayAndSundayInAWeekWithDate:[NSDate date]];
    [self initData];
}

//按月来查询
- (void)createTopView{
    
    //如果创建过 就不新建
    if (_topBgView == nil) {
        _topBgView = [[CountView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)  type:1];
        _topBgView.backgroundColor = [UIColor whiteColor];
        _topBgView.delegate = self;
        [self.view addSubview:_topBgView];
        
    }
    
}
#pragma mark --- CountViewDelegate
- (void)buttonClickWithMonth:(NSString*)month{
    [_dataArray removeAllObjects];
    [self showHintInView:self.view];
    _monday = month;
    SalesDailyBll *dailyBll = [[SalesDailyBll alloc]init];
    [dailyBll getReportCountData:^(NSArray *arr) {
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        
        [_tableView reloadData];
        [self hideHud];
        [_slimeView endRefresh];
        
    } beingDate:month oids:nil ids:nil viewCtrl:self];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VisitManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[VisitManagerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray  *countArray = _dataArray[indexPath.row];
    [cell setReportCountArray:countArray];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
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
    [self initData];
}

#pragma mark - 计算 date 日期所在周内的 周一 和 周日 的日期
/**
 *  计算 date 日期所在周内的 周一 和 周日 的日期
 *
 *  @param date date description
 */
- (void)calculteDateOfMondayAndSundayInAWeekWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:date];
    
    NSTimeInterval second = [date timeIntervalSince1970];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 根据今天是星期几来计算这个星期的星期一的日期   注：西方的星期天为东方的星期一，因此要做一下判断
    if (components.weekday == 1) {
        
        _sunday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];
        _monday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second - 6 * 86400]];

    } else {
        
        _sunday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second + (8 - components.weekday) * 86400]];
        _monday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second - (components.weekday - 2) * 86400]];
          }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
