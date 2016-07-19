//
//  VisitManagerToRecordViewController.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitManagerToRecordViewController.h"
#import "GeneralTopDateChangeView.h"
#import "CheckWorkFunction.h"
#import "VisitRecordTableViewCell.h"
#import "VisitRecordDetailViewController.h"

@interface VisitManagerToRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    GeneralTopDateChangeView *_dateChangeView;
    
    NSMutableArray *_dataArray;
    NSInteger pageIndex;
}
@end

@implementation VisitManagerToRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = @"拜访记录";
    pageIndex = 1;
    
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
}

- (void)dataConfig
{
    _dataArray = [NSMutableArray array];
}

- (void)uiConfig
{
//    [self createDateChangeView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
    [self.view addSubview:_tableView];
    
    __block VisitManagerToRecordViewController *blockSelf = self;
    [_tableView addFooterWithCallback:^{
        pageIndex = pageIndex + 1;
        [blockSelf prepareData];
    }];
}

- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/visitplans/list"];
    NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
    NSString *startDate = [CheckWorkFunction stringFromDate:date isStart:YES];
    NSString *endDate = [CheckWorkFunction stringFromDate:date isStart:NO];
    NSDictionary *dic = @{@"startDate": startDate,
                          @"endDate": endDate,
                          @"ids": _ids,
                          @"page": [NSNumber numberWithInteger: pageIndex],
                          @"size": @"10"};
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        
        [_dataArray addObjectsFromArray:[NSMutableArray arrayWithArray:responseObject[@"content"]]];
//        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"content"]];

        [_tableView reloadData];
        
        if (_dataArray.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        
        _dateChangeView.titleLabel.text = [NSString stringWithFormat:@"%@有%ld个拜访", [Function dateChangeTitle:_dayIndex dateStr:startDate], _dataArray.count];
        
        [_tableView footerEndRefreshing];
        [self hideHud];
    } errorCB:^(NSError *error) {
        [_tableView footerEndRefreshing];
        [self hideHud];
    }];
    
    
}

- (void)createDateChangeView
{
    _dateChangeView = [[GeneralTopDateChangeView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    _dateChangeView.todayButton.hidden = YES;
    [self.view addSubview:_dateChangeView];
    
    [_dateChangeView buttonClickAction:^(NSInteger type) {
        
        if (type == -1) {
            _dayIndex = _dayIndex - 1;
        }else if (type == 1) {
            _dayIndex = _dayIndex + 1;
        }else {
            _dayIndex = 0;
        }
        
        if (_dayIndex == 0) {
            _dateChangeView.todayButton.hidden = YES;
        }else {
            _dateChangeView.todayButton.hidden = NO;
        }
        
        [self prepareData];
    }];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    VisitRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[VisitRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VisitRecordDetailViewController *visitRecordDetailCtrl = [[VisitRecordDetailViewController alloc] init];
    visitRecordDetailCtrl.visitID = _dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:visitRecordDetailCtrl animated:YES];
    
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
