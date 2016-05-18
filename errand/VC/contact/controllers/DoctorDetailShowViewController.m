//
//  DoctorDetailShowViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorDetailShowViewController.h"
#import "DoctorDetailShowTableViewCell.h"
#import "DoctorFillViewController.h"
#import "MassageAndPhoneView.h"
#import "DoctorDynamicView.h"


@interface DoctorDetailShowViewController ()<UITableViewDelegate, UITableViewDataSource, SRRefreshDelegate>
{
    UITableView *_tableView;
    UILabel *_headLabel;
    
    NSMutableArray *_titleArray;
    NSMutableArray *_fillInfoArray;
    BOOL _openFlag;//是否打开查看更多
    
    NSArray *_openTitleArray;
    NSMutableArray *_openFillInfoArray;
    UIButton *_footerButton;
    
    NSDictionary *_resultDic;
    MassageAndPhoneView *_msgPhoneView;
    NSInteger _pageIndex;
    SRRefreshView *_slimeView;
    
    DoctorDynamicView *_dynamicView;
}
@end

@implementation DoctorDetailShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"医生详情";
    _pageIndex = 1;
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createRightItemTitle:@"信息完善"];
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
    [self getDynamicInfo];
}

- (void)getDynamicInfo
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/doctors/summary"];
    NSDictionary *dic = @{@"page": [NSNumber numberWithInteger:_pageIndex],
                          @"size": @"10",
                          @"doctor": @{@"id": _doctorModel.doctorID}};
    
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        
        [_dynamicView reloadData:responseObject pageIndex:_pageIndex];
        
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    } errorCB:^(NSError *error) {
        
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    }];
}

- (void)dataConfig
{
    _openFlag = NO;
    _titleArray = nil;
    _openTitleArray = nil;
    _fillInfoArray = nil;
    _openFillInfoArray = nil;
    
    _titleArray = [NSMutableArray arrayWithArray:@[@"医生姓名：", @"所属科室：", @"职称：", @"联系方式：", @"性别：", @"客户标识："]];
    _openTitleArray = @[@"出生年月：", @"邮箱：", @"家庭住址：", @"毕业学院：", @"身份证：", @"深灰任职：", @"研究领域：", @"文献：", @"特长：", @"行业认资：", @"行政职务："];
    
    _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @""]];
    _openFillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""]];
    
}

- (void)rightItemTitleClick
{
    DoctorFillViewController *doctorFillCtrl = [[DoctorFillViewController alloc] init];
    doctorFillCtrl.doctorModel = _doctorModel;
    [self.navigationController pushViewController:doctorFillCtrl animated:YES];
    
    [doctorFillCtrl updateInfoSuccessAction:^{
        [self dataConfig];
        _dynamicView.footerButton.selected = NO;
        _footerButton.selected = NO;
        [self prepareData];
    }];
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-100) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.separatorStyle = 0;
    
    _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    _headLabel.font = GDBFont(16);
    _headLabel.textColor = COMMON_FONT_BLACK_COLOR;
    _headLabel.textAlignment = NSTextAlignmentCenter;
    _tableView.tableHeaderView = _headLabel;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerButton.frame = CGRectMake((kWidth-100)/2.0, 0, 100, 40);
    [_footerButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [_footerButton setTitle:@"收回" forState:UIControlStateSelected];
    [_footerButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    [_footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_footerButton];
    _footerButton.titleLabel.font = GDBFont(14);
//    _tableView.tableFooterView = view;
    
    _msgPhoneView = [[MassageAndPhoneView alloc] initWithFrame:CGRectMake(0, kHeight-100, kWidth, 100)];
    [self.view addSubview:_msgPhoneView];
    
    [_msgPhoneView msgOrPhoneClickAction:^(NSInteger type) {
        if (type == 0) {
            [self openCall:_resultDic[@"telphone"]];
        }else {
            [self showMessageView:[NSArray arrayWithObjects:_resultDic[@"telphone"] ,nil]];
//            [self sendMassage];
        }
    }];
    
    __block DoctorDetailShowViewController *blockSelf = self;
    [_tableView addFooterWithCallback:^{
        _pageIndex = _pageIndex+1;
        [blockSelf getDynamicInfo];
    }];
    
    _slimeView = [_tableView createSlimeRefreshView];
    _slimeView.delegate = self;
    
    
    _dynamicView = [[DoctorDynamicView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0)];
    _tableView.tableFooterView = _dynamicView;
    
    __block DoctorDynamicView *dynamicView = _dynamicView;
    __block UITableView *table = _tableView;
    
    [_dynamicView setChangeSelfHeightCB:^(CGFloat height) {
        dynamicView.frame = CGRectMake(0, 0, kWidth, height);
        table.tableFooterView = dynamicView;
    }];
    
    [_dynamicView setButtonClickCB:^(UIButton *button) {
        button.selected = !button.selected;
        _openFlag = button.selected;
        if (button.selected) {
            [blockSelf addBottomCell];
        }else {
            [blockSelf deleteBottomCell];
        }
    }];
}

- (void)footerButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    _openFlag = button.selected;
    if (button.selected) {
        [self addBottomCell];
    }else {
        [self deleteBottomCell];
    }
}

- (void)deleteBottomCell
{
    NSMutableIndexSet *muSet = [NSMutableIndexSet indexSet];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i=_titleArray.count-_openTitleArray.count; i<_titleArray.count; i++) {
        [muSet addIndex:i];
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_titleArray removeObjectsAtIndexes:muSet];
    [_fillInfoArray removeObjectsAtIndexes:muSet];
    
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addBottomCell
{
    NSMutableIndexSet *muSet = [NSMutableIndexSet indexSet];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i=_titleArray.count; i<_titleArray.count+_openTitleArray.count; i++) {
        [muSet addIndex:i];
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_titleArray insertObjects:_openTitleArray atIndexes:muSet];
    [_fillInfoArray insertObjects:_openFillInfoArray atIndexes:muSet];
    
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    
}

- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/doctors/%@", _doctorModel.doctorID];
    [self showHintInView:self.view];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        [self hideHud];
        [self configResult:responseObject];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)configResult:(id)responseObject
{
    _resultDic = responseObject;
    _headLabel.text = _resultDic[@"hospital"][@"name"];
    
    //不可在客户端更改
    if (_resultDic[@"name"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:0 withObject:_resultDic[@"name"]];
    }
    if (_resultDic[@"office"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:1 withObject:_resultDic[@"office"]];
    }
    if (_resultDic[@"title"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:2 withObject:_resultDic[@"title"]];
    }
    if (_resultDic[@"telphone"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:3 withObject:_resultDic[@"telphone"]];
        
    }
    if (_resultDic[@"gender"] != [NSNull null]) {
        NSString *genderStr = [[ConfigFile genderArray] objectAtIndex:[_resultDic[@"gender"] integerValue]];
        [_fillInfoArray replaceObjectAtIndex:4 withObject:genderStr];
    }
    if (_resultDic[@"marking"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:5 withObject:_resultDic[@"marking"]];
    }
    
    //可以在客户端更改
    
    if (_resultDic[@"birthday"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:0 withObject:_resultDic[@"birthday"]];
    }
    if (_resultDic[@"email"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:1 withObject:_resultDic[@"email"]];
    }
    if (_resultDic[@"address"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:2 withObject:_resultDic[@"address"]];
    }
    if (_resultDic[@"school"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:3 withObject:_resultDic[@"school"]];
    }
    if (_resultDic[@"card"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:4 withObject:_resultDic[@"card"]];
    }
    if (_resultDic[@"social"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:5 withObject:_resultDic[@"social"]];
    }
    if (_resultDic[@"researchField"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:6 withObject:_resultDic[@"researchField"]];
    }
    if (_resultDic[@"literature"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:7 withObject:_resultDic[@"literature"]];
    }
    if (_resultDic[@"specialty"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:8 withObject:_resultDic[@"specialty"]];
    }
    if (_resultDic[@"qualification"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:9 withObject:_resultDic[@"qualification"]];
    }
    if (_resultDic[@"position"] != [NSNull null]) {
        [_openFillInfoArray replaceObjectAtIndex:10 withObject:_resultDic[@"position"]];
    }
    
    
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    DoctorDetailShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DoctorDetailShowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
    [cell fillData:_fillInfoArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)sendMassage
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        NSArray *phoneArray = @[_resultDic[@"telphone"]];
        controller.recipients = phoneArray;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = @"";
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [self goBackMainAPP];
        //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//从短信页面返回主页面
- (void)goBackMainAPP{
    UIImage* img=[UIImage imageNamed:@"title_back.png"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame =CGRectMake(0, 0, 32, 32);
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(messageItemClicked) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}

- (void)messageItemClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    _pageIndex = 1;
    [self getDynamicInfo];
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
