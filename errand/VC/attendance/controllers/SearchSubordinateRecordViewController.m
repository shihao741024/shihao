//
//  SearchSubordinateRecordViewController.m
//  errand
//
//  Created by pro on 16/4/5.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchSubordinateRecordViewController.h"
#import "StaffModel.h"
#import "SubordinateRecordTableViewCell.h"

@interface SearchSubordinateRecordViewController ()
{
    NSMutableArray *_subordinateArray;//下属name数组
    NSMutableArray *_contentArray;//无序的下属dic二维数组
    
    NSInteger _selectSubordinateIndex;//选中的下属下标，默认第一个0
    NSMutableArray *_timeArray;//时间二维数组
    NSMutableArray *_sortDataArray;//时间排序后的下属dic二维数组
}
@end

@implementation SearchSubordinateRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateSelectView.hidden = YES;
    self.tableView.frame = CGRectMake(75, 64, kWidth-75, kHeight-(64));
    
    [self dataConfig];
    
//    [self.subordinateView reloadDataWithModelArray:_modelArray];
    [self searchPrepareData];
    
    [self.subordinateView selectIndexAction:^(NSInteger index) {
        _selectSubordinateIndex = index;
        [self configShowData];
    }];
}

- (void)dataConfig
{
    _subordinateArray = [NSMutableArray array];
    _contentArray = [NSMutableArray array];
    
    _selectSubordinateIndex = 0;
    _timeArray = [NSMutableArray array];
    _sortDataArray = [NSMutableArray array];
}

- (void)searchPrepareData
{
    NSMutableArray *ids = [NSMutableArray array];
    for (StaffModel *model in _modelArray) {
        [ids addObject:model.ID];
    }
    NSDictionary *dic = @{@"startDate": _passStartDate,
                          @"endDate": _passEndDate,
                          @"ids": ids};
    [self showHintInView:self.view];
    
    NSString *url = [BASEURL stringByAppendingString:pathKqXs];
    [Function generalPostRequest:url infoDic:dic resultCB:^(id responseObject) {
        
        if ([responseObject count] == 0) {
            [Dialog simpleToast:NoMoreData];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        [self analyzeData:responseObject];
        
        [self hideHud];
    } errorCB:^(NSError *error) {
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getSubordinate
{
    
}

- (void)createRightItem
{
    
}

-(void)analyzeData:(id)responseObject
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject];
    //解析多少个下属
    for (NSDictionary *dic in array) {
        if ([_subordinateArray indexOfObject:dic[@"belongTo"][@"name"]] == NSNotFound) {
            [_subordinateArray addObject:dic[@"belongTo"][@"name"]];
            
            [_contentArray addObject:[NSMutableArray array]];
            [_timeArray addObject:[NSMutableArray array]];
        }
    }
    [self.subordinateView reloadDataWithSubordinateArray:_subordinateArray];
    
    //解析每个下属的所有考勤
    for (NSDictionary *dic in array) {
        for (NSInteger i=0; i<_subordinateArray.count; i++) {
            if ([dic[@"belongTo"][@"name"] isEqualToString:_subordinateArray[i]]) {
                [_contentArray[i] addObject:dic];
                
                NSString *timeStr = [Function getDateAndWeek:dic[@"createDate"]];
                if ([_timeArray[i] indexOfObject:timeStr] == NSNotFound) {
                    [_timeArray[i] addObject:timeStr];
                }
                
            }
        }
    }
    [self configShowData];
    
}

//每个下属的所有考勤按时间分类，并显示
- (void)configShowData
{
    //当前要显示的下属的数据
    NSArray *dataArray = _contentArray[_selectSubordinateIndex];
    NSArray *timeArray = _timeArray[_selectSubordinateIndex];
    
    NSMutableArray *sortArray = [NSMutableArray array];
    for (NSInteger i=0; i<timeArray.count; i++) {
        NSMutableArray *dicArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArray) {
            NSString *timeStr = [Function getDateAndWeek:dic[@"createDate"]];
            if ([timeStr isEqualToString:timeArray[i]]) {
                [dicArray addObject:dic];
            }
        }
        [sortArray addObject:dicArray];
    }
    
    _sortDataArray = sortArray;
    
    [self.tableView reloadData];
    NSLog(@"%@", _timeArray);
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
    [cell fillData:_sortDataArray[indexPath.section][indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_timeArray.count == 0) {
        return 0;
    }else {
        return [_timeArray[_selectSubordinateIndex] count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sortDataArray[section] count];
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
    if (_sortDataArray.count != 0) {
        headView.titleLabel.text = _timeArray[_selectSubordinateIndex][section];
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
