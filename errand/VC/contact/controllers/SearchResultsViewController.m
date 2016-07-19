//
//  SearchResultViewController.m
//  errand
//
//  Created by 医路同行Mac1 on 16/6/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "ContactsBll.h"
#import "SearchViewController.h"
#import "DoctorsViewController.h"
#import "DoctorDetailShowViewController.h"
#import "ContactsViewController.h"
#import "ContactsViewCell.h"
#import "DoctorsViewCell.h"


@interface SearchResultsViewController ()<SRRefreshDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;

@end

@implementation SearchResultsViewController{
    NSMutableArray *dataArray;
    int pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = @"搜索结果";
    [self addedBackButton];
    
    [self initView];
}

-(void)initView{
    dataArray=[[NSMutableArray alloc] init];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self createMJ];
    [self createSlime];
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
    
    ContactsBll *contactsBll = [[ContactsBll alloc]init];
//    SearchViewController *vc = [[SearchViewController alloc] init];
    
    if ([_kind isEqualToString:@"医生"]) {
        _type = 1;
    } else {
        _type = 2;
    }
    if (_type == 1) {
        [contactsBll getSearchDoctorsResult:^(NSArray *arr) {
            if (pageIndex == 1) {
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } pageIndex:pageIndex keywords:_keywords kind:_kind department:_department viewCtrl:self];
    }else if (_type == 2) {
        [contactsBll getSearchHospitalsResult:^(NSArray *arr) {
            if (pageIndex == 1) {
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } pageIndex:pageIndex keywords:_keywords kind:_kind hospitalrank:_hospitalrank province:_province city:_city viewCtrl:self];
    }
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
//设置cell分割线靠左
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        static NSString *cell1id = @"doctorsCell";
        DoctorsViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cell1id];
        if (!cell1) {
            cell1 = [[DoctorsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell1id];
            cell1.backgroundColor = COMMON_BACK_COLOR;
        }
        DoctorModel *model1 = dataArray[indexPath.row];
        [cell1 fillData:model1];
        return cell1;
    }else {
        static NSString *cell2id = @"contactsCell";
        ContactsViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cell2id];
        if (!cell2) {
            cell2 = [[ContactsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell2id];
            cell2.backgroundColor = COMMON_BACK_COLOR;
        }
        ContactModel *model2 = dataArray[indexPath.row];
        [cell2 fillData:model2];
        return cell2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 2) {
        ContactModel *model = dataArray[indexPath.row];
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.popIndex = _popIndex;
        doctorVC.phonebook = YES;
        doctorVC.contactModel = model;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
        
    }else {
        DoctorsModel *model = dataArray[indexPath.row];
        DoctorDetailShowViewController *doctorFillCtrl = [[DoctorDetailShowViewController alloc] init];
        doctorFillCtrl.doctorID = model.doctorID;
        [self.navigationController pushViewController:doctorFillCtrl animated:YES];
    }
}


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_slimeView scrollViewDidScroll];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_slimeView scrollViewDidEndDraging];
}
#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView{
    pageIndex=1;
    [self initData];
}
#pragma mark 上拉加载
-(void)createMJ {
    __block  SearchResultsViewController *resultsVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex = pageIndex + 1;
        [resultsVC initData];
    }];
}

-(void)createSlime {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addedBackButton {
    UIImage* img=[UIImage imageNamed:@"title_back.png"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 32, 32);
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(navigationItemClickeds:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
    
}
- (void)navigationItemClickeds:(UIButton *)barButtonItem {
    
    ContactsViewController *vc = [[ContactsViewController alloc] init];
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[vc class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
