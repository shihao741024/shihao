//
//  VisitManagerViewController.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitManagerViewController.h"
#import "GeneralTopDateChangeView.h"
#import "CheckWorkFunction.h"
#import "VisitManagerToRecordViewController.h"


@interface VisitManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    GeneralTopDateChangeView *_dateChangeView;
    UITableView *_tableView;
    int _dayIndex;
    
    NSMutableArray *_dataArray;
}
@end

@implementation VisitManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = @"拜访管理";
    
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
}

- (void)dataConfig
{
    _dayIndex = 0;
    _dataArray = [NSMutableArray array];
}

- (void)uiConfig
{
    [self createDateChangeView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kTableViewColor;
    [self.view addSubview:_tableView];
}

- (void)prepareData
{
    NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
    NSString *startDate = [CheckWorkFunction stringFromDate:date isStart:YES];
    NSString *endDate = [CheckWorkFunction stringFromDate:date isStart:NO];
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/visitplans/manage"];
    
    NSDictionary *dic = @{@"startDate": startDate,
                          @"endDate": endDate};
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        
        [self sortDataArray:[NSMutableArray arrayWithArray:responseObject]];
        
        
        if (_dataArray.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
    
    _dateChangeView.titleLabel.text = [Function dateChangeTitle:_dayIndex dateStr:startDate];
}

- (void)sortDataArray:(NSArray *)array;
{
    NSMutableArray *idArray = [NSMutableArray array];
    NSMutableArray *showArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        
        if ([idArray indexOfObject:dic[@"sale"][@"id"]] == NSNotFound) {
            [idArray addObject:dic[@"sale"][@"id"]];
            [showArray addObject:[NSMutableDictionary dictionaryWithDictionary:
                                  @{@"sale": dic[@"sale"],
                                   @"计划": @"0",
                                   @"临时": @"0"}]];
        }
    }
    
    for (NSDictionary *dic in array) {
        
        for (NSMutableDictionary *showDic in showArray) {
            if ([dic[@"sale"][@"id"] isEqual:showDic[@"sale"][@"id"]]) {
                
                if ([dic[@"category"] isEqual:@0]) {
                    [showDic setObject:dic[@"sum"] forKey:@"计划"];
                    
                }else {
                    [showDic setObject:dic[@"sum"] forKey:@"临时"];
                }
            }
        }
    }
    
    
    
    _dataArray = showArray;
    [_tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.selectionStyle = 0;
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"sale"][@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@+%@条", _dataArray[indexPath.row][@"计划"], _dataArray[indexPath.row][@"临时"]];
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
    VisitManagerToRecordViewController *managerRecordCtrl = [[VisitManagerToRecordViewController alloc] init];
    managerRecordCtrl.dayIndex = _dayIndex;
    managerRecordCtrl.ids = [NSMutableArray arrayWithObject:_dataArray[indexPath.row][@"sale"][@"id"]];
    [self.navigationController pushViewController:managerRecordCtrl animated:YES];
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
