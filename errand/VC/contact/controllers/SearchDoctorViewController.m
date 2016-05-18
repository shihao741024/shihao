//
//  SearchDoctorViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchDoctorViewController.h"
#import "DoctorDetailShowViewController.h"
#import "DoctorsModel.h"

@interface SearchDoctorViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
}
@end

@implementation SearchDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = @"查询医生";
    
    [self uiConfig];
}

- (void)uiConfig
{
    [self createRightItem];
    [self createSearchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, kWidth, kHeight-64-50) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)createRightItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)RecordsearchClick
{
    if ([_searchBar.text isEqualToString:@""]) {
        [Dialog simpleToast:@"请输入医生姓名"];
        return;
    }
    [_searchBar resignFirstResponder];
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/doctors/query"];
    NSDictionary *dic = @{@"name": _searchBar.text};
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        
        [self hideHud];
        _dataArray = nil;
        _dataArray = responseObject;
        [_tableView reloadData];
    } errorCB:^(NSError *error) {
        
        [self hideHud];
    }];
}

- (void)createSearchBar {
    
    UIView *searchBg = [[UIView alloc]initWithFrame:CGRectMake(10, 64+4, SCREEN_WIDTH-20, 44-8)];
    searchBg.backgroundColor = COMMON_BACK_COLOR;
    searchBg.layer.cornerRadius = 18;
    searchBg.clipsToBounds = YES;
    [self.view addSubview:searchBg];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH-20, 100)];
    _searchBar.placeholder = @"请输入关键字";
    [_searchBar setContentMode:UIViewContentModeCenter];
    _searchBar.delegate = self;
    _searchBar.backgroundImage = [self imageWithColor:COMMON_BACK_COLOR size:_searchBar.bounds.size];
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [searchBg addSubview:_searchBar];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self RecordsearchClick];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"name"];
    cell.detailTextLabel.text = _dataArray[indexPath.row][@"office"];
    
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
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorsModel *model = [[DoctorsModel alloc] initWithDic:_dataArray[indexPath.row]];
    DoctorDetailShowViewController *doctorFillCtrl = [[DoctorDetailShowViewController alloc] init];
    doctorFillCtrl.doctorModel = model;
    [self.navigationController pushViewController:doctorFillCtrl animated:YES];
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
