//
//  LocationDetailViewController.m
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "LocationDetailTableViewCell.h"
#import "ShowSiteViewController.h"

@interface LocationDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;

}


@end


@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"位置明细";
    
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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
- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/sale/path/track/%@", _saleId];
    NSDictionary *dic = @{@"startDate": _startDate};
//    NSDictionary *dic = @{@"startDate": [Function stringFromDate:[NSDate date]]};
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
//        NSLog(@"responseObject-------------->%@",responseObject);
        [self configResult:responseObject];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
    
}

- (void)configResult:(id)responseObject
{
    [_dataArray removeAllObjects];
    NSMutableArray *result = responseObject[@"path"];
    for (NSDictionary *resDic in result) {
        if (resDic[@"coordinate"] == [NSNull null]) {
            
        }else {
            [_dataArray addObject:resDic];
        }
    }
    
    [_tableView reloadData];
    
    if (_dataArray.count == 0) {
        [Dialog simpleToast:NoMoreData];
    }
}



#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    LocationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LocationDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
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
//    NSLog(@" _dataArray[indexPath.row]------------------>%@", _dataArray[indexPath.row]);
    CLLocationDegrees lat =  [_dataArray[indexPath.row][@"coordinate"][@"latitude"] doubleValue];
    CLLocationDegrees lon = [_dataArray[indexPath.row][@"coordinate"][@"longitude"] doubleValue];
    NSString *titleStr = _dataArray[indexPath.row][@"createDate"];
    NSString *subtilte= _dataArray[indexPath.row][@"coordinate"][@"name"];
//    NSLog(@"lat:%f",lat);
//    NSLog(@"lon:%f",lon);
    
       
    
    ShowSiteViewController *siteVC = [[ShowSiteViewController alloc]init];
    siteVC.lat = lat;
    siteVC.lon = lon;
    siteVC.datetitle = titleStr;
    siteVC.siteTitle = subtilte;
    [self.navigationController pushViewController:siteVC animated:NO];
    
    
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
