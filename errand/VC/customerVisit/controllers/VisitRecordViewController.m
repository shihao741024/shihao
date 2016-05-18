//
//  VisitRecordViewController.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitRecordViewController.h"
#import "VisitRecordTableViewCell.h"
#import "VisitRecordDetailViewController.h"
#import "ProductionModel.h"
#import "ContactModel.h"
#import "DoctorsModel.h"

@interface VisitRecordViewController ()<SRRefreshDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSInteger pageIndex;
//    UITableView *_tableView;
    SRRefreshView *_slimeView;
    
//    NSMutableArray *_dataArray;
}

@property (nonatomic, copy) void(^willAppearCB)();

@end

@implementation VisitRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
}

- (void)dataConfig
{
    pageIndex = 1;
    _dataArray = [NSMutableArray array];
}

- (NSMutableDictionary *)configSearchInfo:(NSDictionary *)dic
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *staffDicArray = _saveDic[@"staffDicArray"];
    
    if (staffDicArray != nil) {
        NSMutableArray *ids = [NSMutableArray array];
        for (NSDictionary *dic in staffDicArray) {
            [ids addObject:dic[@"ID"]];
        }
        [muDic setObject:ids forKey:@"ids"];
    }
    ProductionModel *productModel = _saveDic[@"productModel"];
    if (productModel != nil) {
        [muDic setObject:@{@"id": productModel.productID} forKey:@"production"];
    }
    ContactModel *contactModel = _saveDic[@"contactModel"];
    if (contactModel != nil) {
        [muDic setObject:@{@"id": contactModel.hospitalID} forKey:@"hospital"];
    }
    DoctorsModel *doctorsModel = _saveDic[@"doctorsModel"];
    if (doctorsModel != nil) {
        [muDic setObject:@{@"id": doctorsModel.doctorID} forKey:@"doctor"];
    }
    NSString *startDate = _saveDic[@"startDate"];
    if (![startDate isEqualToString:@""]) {
        [muDic setObject:startDate forKey:@"startDate"];
    }
    NSString *endDate = _saveDic[@"endDate"];
    if (![endDate isEqualToString:@""]) {
        [muDic setObject:endDate forKey:@"endDate"];
    }
    NSString *typeStr = _saveDic[@"typeStr"];
    if (![typeStr isEqualToString:@""]) {
        [muDic setObject:typeStr forKey:@"status"];
    }
    NSLog(@"查询提交字段%@", dic);
    return muDic;
}

- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/visitplans/list"];
    NSDictionary *dic = @{@"page": [NSNumber numberWithInteger:pageIndex],
                          @"size": @"10"};
    if (_saveDic) {
        dic = [self configSearchInfo:dic];
    }
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        if (pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        NSMutableArray *content = [NSMutableArray arrayWithArray:responseObject[@"content"]];
        [_dataArray addObjectsFromArray:content];
        [_tableView reloadData];
        
        if (content.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        
        
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    } errorCB:^(NSError *error) {
        
        [self hideHud];
    }];
    
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
    [self.view addSubview:_tableView];
    
    [self addRefreshAndLoadView];
    
}

- (void)addRefreshAndLoadView
{
    _slimeView = [_tableView createSlimeRefreshView];
    _slimeView.delegate = self;
    
    __block  VisitRecordViewController *visitRecordCtrl = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [visitRecordCtrl prepareData];
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
    visitRecordDetailCtrl.visitDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:visitRecordDetailCtrl animated:YES];
    
}

- (void)refreshData
{
    pageIndex = 1;
    
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/visitplans/list"];
    NSDictionary *dic = @{@"page": [NSNumber numberWithInteger:pageIndex],
                          @"size": @"10"};
    if (_saveDic) {
        dic = [self configSearchInfo:dic];
    }
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        if (pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        NSMutableArray *content = [NSMutableArray arrayWithArray:responseObject[@"content"]];
        [_dataArray addObjectsFromArray:content];
        [_tableView reloadData];
        
        if (content.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        
        
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    } errorCB:^(NSError *error) {
        
        [self hideHud];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    _willAppearCB();
}

- (void)visitRecordWillAppear:(void(^)())action
{
    _willAppearCB = action;
}

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
    pageIndex = 1;
    [self prepareData];
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
