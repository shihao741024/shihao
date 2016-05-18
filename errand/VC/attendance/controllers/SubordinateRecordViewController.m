//
//  SubordinateRecordViewController.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SubordinateRecordViewController.h"
#import "CheckWorkFunction.h"
#import "SearchView.h"
#import "SearchSubordinateRecordViewController.h"
#import "SubordinateRecordTableViewCell.h"

@interface SubordinateRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
//    SubordinateView *_subordinateView;
//    SubordinateDateSelectView *_dateSelectView;
//    UITableView *_tableView;
    
    int seclectedFlag;
    UIView *_bgView;
    SearchView *_searchView;
    
    int _dayIndex;//当前天数下标，默认今天0
    NSInteger _slectedSubordinate; //选中的右边下属的下标，默认第一个0
    NSMutableArray *_subordinateArray; //所有的下属数组
    
    
    
}
@end

@implementation SubordinateRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下属考勤记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self uiConfig];
    [self dataConfig];
    [self getSubordinate];
    
}

- (void)dataConfig
{
    _dayIndex = 0;
    _slectedSubordinate = 0;
}

- (void)uiConfig
{
    [self addBackButton];
    [self createRightItem];
    [self createSubordinateView];
    [self createDateSelectView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(75, 64+40, kWidth-75, kHeight-(64+40)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = GDBColorRGB(0.85, 0.85, 0.85, 1);
    [self.view addSubview:_tableView];
}

- (void)refreshDateTitle
{
    NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
    NSString *startDate = [CheckWorkFunction stringFromDate:date isStart:YES];
    NSString *endDate = [CheckWorkFunction stringFromDate:date isStart:NO];
    [_dateSelectView reloadTitle:[startDate substringToIndex:10]];
    
    if (_dayIndex == 0) {
        [_dateSelectView reloadTitle:@"今天"];
    }else if (_dayIndex == 1) {
        [_dateSelectView reloadTitle:@"明天"];
    }else if (_dayIndex == -1) {
        [_dateSelectView reloadTitle:@"昨天"];
    }else if (_dayIndex == 2) {
        [_dateSelectView reloadTitle:@"后天"];
    }else if (_dayIndex == -2) {
        [_dateSelectView reloadTitle:@"前天"];
    }
}

//创建上边日期切换视图
- (void)createDateSelectView
{
    _dateSelectView = [[SubordinateDateSelectView alloc] initWithFrame:CGRectMake(75, 64, kWidth-75, 40)];
    [self.view addSubview:_dateSelectView];
    
    [_dateSelectView seletedDateAction:^(NSString *position) {
        if ([position isEqualToString:@"left"]) {
            _dayIndex = _dayIndex-1;
            [self refreshDateTitle];
            [self getFirstSubordinate:_subordinateArray];
        }else {
            _dayIndex = _dayIndex+1;
            [self refreshDateTitle];
            [self getFirstSubordinate:_subordinateArray];
        }
        
    }];
}
//创建右边下属列表
- (void)createSubordinateView
{
    _subordinateView = [[SubordinateView alloc] initWithFrame:CGRectMake(0, 64+0.5, 75, kHeight-64)];
    [self.view addSubview:_subordinateView];
    
    [_subordinateView selectIndexAction:^(NSInteger index) {
        _dayIndex = 0;
        _slectedSubordinate = index;
        [self refreshDateTitle];
        [self getFirstSubordinate:_subordinateArray];
    }];
}

- (void)createRightItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}

//首先调取下属
- (void)getSubordinate
{
    [self showHintInView:self.view];
    [self showInfica];
    
    NSString *url = [BASEURL stringByAppendingString:pathSalesXs];
    [Function generalPostRequest:url infoDic:nil resultCB:^(id responseObject) {
        if (responseObject) {
            
            _subordinateArray = [NSMutableArray arrayWithArray:responseObject];
            
            if (_subordinateArray.count == 0) {
                [Dialog simpleToast:@"您没有下属员工!"];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            [_subordinateView reloadData:_subordinateArray];
            
            [self getFirstSubordinate:[NSMutableArray arrayWithArray:responseObject]];
        }
        
        [self hideInfica];
        [self hideHud];
    } errorCB:^(NSError *error) {
        [self hideInfica];
        [self hideHud];
    }];
    
}

//切换下属或者日期时刷新数据
- (void)getFirstSubordinate:(NSMutableArray *)array
{
    if (array.count != 0) {
        NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
        NSString *startDate = [CheckWorkFunction stringFromDate:date isStart:YES];
        NSString *endDate = [CheckWorkFunction stringFromDate:date isStart:NO];
        
        [self prepareData:startDate endDate:endDate ids:[NSMutableArray arrayWithObject:array[_slectedSubordinate][@"id"]]];
    }
    
}


- (void)RecordsearchClick{
    
    if (_bgView == nil) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.2;
        _bgView.tag = 100;
        [self.view addSubview:_bgView];
    }
    if (_searchView == nil) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, 250) andWithType:1];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.alpha = 1;
        _searchView.tag = 101;
        [self.view addSubview:_searchView];
    }
    if (seclectedFlag == 0) {
        _bgView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [UIView animateWithDuration:0.3 animations:^{
            
            _searchView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 250);
        }];
        seclectedFlag = 1;
    }else{
        _bgView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [UIView animateWithDuration:0.3 animations:^{
            
            _searchView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        }];
        seclectedFlag = 0;
    }
    //
    //    //根据搜索条件 刷新数据源
    //
    __block UIView *myBgView = _bgView;
    __block SearchView *mySearchView = _searchView;
    __block SubordinateRecordViewController *myself = self;
    __block UITableView *myTableView = _tableView;
    
    [_searchView setRecordModelBlock:^(NSString *startDate, NSString *endDate, NSMutableArray *modelArray) {
        myBgView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [UIView animateWithDuration:0.3 animations:^{
            
            mySearchView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        }];
        seclectedFlag = 0;
        [myself showSearchSubordinateViewCtrl:startDate endDate:endDate modelArray:modelArray];
    }];
    
}

- (void)showSearchSubordinateViewCtrl:(NSString *)startDate endDate:(NSString *)endDate modelArray:(NSMutableArray *)modelArray
{
    SearchSubordinateRecordViewController *searchRecordVC = [[SearchSubordinateRecordViewController alloc]init];
    searchRecordVC.passStartDate = startDate;
    searchRecordVC.passEndDate = endDate;
    searchRecordVC.modelArray = modelArray;
    [self.navigationController pushViewController:searchRecordVC animated:YES];
}

- (void)prepareData:(NSString *)startDate endDate:(NSString *)endDate ids:(NSMutableArray *)ids
{
    NSDictionary *dic = @{@"startDate": startDate,
                          @"endDate": endDate,
                          @"ids": ids};
    
    NSLog(@"pathKqXs--%@,%@, %@", startDate, endDate, ids);
    NSString *url = [BASEURL stringByAppendingString:pathKqXs];
    [Function generalPostRequest:url infoDic:dic resultCB:^(id responseObject) {
        _dataArray = [NSMutableArray arrayWithArray:responseObject];
        [_tableView reloadData];
//        if (_dataArray.count == 0) {
//            [Dialog simpleToast:NoMoreData];
//        }
    } errorCB:^(NSError *error) {
        _dataArray = [NSMutableArray array];
        [_tableView reloadData];
    }];
    
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    SubordinateRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SubordinateRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.selectionStyle = 0;
    }
    [cell fillData:_dataArray[indexPath.row]];
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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headId = @"headid";
    TableViewHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    if (!headView) {
        headView = [[TableViewHeaderView alloc] initWithReuseIdentifier:headId];
    }
    if (_dataArray.count != 0) {
        headView.titleLabel.text = [Function getDateAndWeek:_dataArray[section][@"createDate"]];
    }else {
        headView.titleLabel.text = @"";
    }
    
    return headView;
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

@implementation TableViewHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth-75, 40)];
    _titleLabel.font = GDBFont(15);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
}

@end
