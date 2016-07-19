//
//  ContactssViewController.m
//  errand
//
//  Created by 医路同行Mac1 on 16/6/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ContactssViewController.h"
#import "ContactsViewCell.h"
#import "ContactsBll.h"
#import "SearchsViewController.h"
#import "ContactChildViewController.h"
#import "DoctorsViewController.h"
#import "CommonBll.h"

#import "SearchDoctorViewController.h"
#import "HospitalTableViewCell.h"

@interface ContactssViewController ()<SRRefreshDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;

@end

@implementation ContactssViewController{
    //全体员工的数据
    NSMutableArray *allArray;
    
    NSMutableArray *dataArray;
    int pageIndex;
    BOOL isSearch;
    NSArray *_searchArray;
    float navHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = @"选择医院";
    [self addBackButton];
    [self initView];
    
    [self createRightSearchItem];
    
}

- (void)createRightSearchItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)RecordsearchClick
{
    SearchsViewController *searchCtrl = [[SearchsViewController alloc] init];
    searchCtrl.searchArray = _searchArray;
    
    [self.navigationController pushViewController:searchCtrl animated:YES];
    //@property (nonatomic, copy)void (^feedBackHospitalSearchDataBlock)(NSString *keywords,NSString *hospitalrank,NSString *province,NSString *city);
    searchCtrl.feedBackHospitalSearchDataBlock = ^(NSString *keywords,NSString *hospitalrank,NSString *province,NSString *city){
        NSArray *searchArray = @[keywords,hospitalrank,province,city];
        _searchArray = searchArray;
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (_searchArray.count > 0) {
        pageIndex = 0;
        isSearch = YES;
        [self initData];
    }
}
-(void)initView{
    dataArray=[[NSMutableArray alloc] init];
    navHeight=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    //    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self createMJ];
    [self createSlime];
    [self initData];
}

-(void)initData{
    
    ContactsBll *contactsBll = [[ContactsBll alloc]init];
    if(!pageIndex){
        [self showHintInView:self.view];
        pageIndex=1;
    }else if(pageIndex==1){
        [self showInfica];
    }else{
        [self showInfica];
    }
    
    if (isSearch == NO) {
        if (_type == 0) {
            [contactsBll getAllContactsData:^(NSArray *arr) {
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
            } pageIndex:pageIndex viewCtrl:self];
        }else if (_type == 5) {
            [contactsBll getCompetitionHospitalData:^(NSArray *arr) {
                if (pageIndex == 1) {
                    [dataArray removeAllObjects];
                }
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dataArray addObject:obj];
                }];
                if (dataArray.count == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [_tableView reloadData];
                [self hideHud];
                [_slimeView endRefresh];
                [_tableView footerEndRefreshing];
                
            } pageIndex:pageIndex viewCtrl:self];
        }else if (_type == 7 || _type == 8 || _allProduct == YES) {
            [contactsBll getTypeHospitalsData:^(NSArray *arr) {
                if (pageIndex == 1) {
                    [dataArray removeAllObjects];
                }
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dataArray addObject:obj];
                }];
                if (dataArray.count == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [_tableView reloadData];
                [self hideHud];
                [_slimeView endRefresh];
                [_tableView footerEndRefreshing];
            } pageIndex:pageIndex viewCtrl:self];
        } else {
            [contactsBll gethospitalsData:^(NSArray *arr) {
                if (pageIndex == 1) {
                    [dataArray removeAllObjects];
                }
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dataArray addObject:obj];
                }];
                if (dataArray.count == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [_tableView reloadData];
                [self hideHud];
                [_slimeView endRefresh];
                [_tableView footerEndRefreshing];
            } productID:_productModel.productID pageIndex:pageIndex viewCtrl:self];
        }
    } else {
        [contactsBll getSearchHospitalsResult:^(NSArray *arr) {
            if (pageIndex == 1) {
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            if (dataArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } pageIndex:pageIndex keywords:_searchArray[0] kind:@"医院" hospitalrank:_searchArray[1] province:_searchArray[2] city:_searchArray[3] viewCtrl:self];
    }
    
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


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"contactsCell";
    ContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ContactsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.backgroundColor = COMMON_BACK_COLOR;
        if (_type == 6) {
            [cell selectButtonAction:^(ContactsViewCell *selectCell) {
                
                [self backProductAndHospital:selectCell];
            }];
        }
    }
    ContactModel *model = dataArray[indexPath.row];
    if (_type == 6) {
        [cell fillData:model hideSelectBtn:NO];
    }else {
        [cell fillData:model];
    }
    return cell;
}

- (void)backProductAndHospital:(ContactsViewCell *)selectCell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:selectCell];
    //发送通知
    ContactModel *model = dataArray[indexPath.row];
    NSArray *arr;
    if (self.productModel) {
        arr = @[model,self.productModel];
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    }else {
        arr = @[model,@""];
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"feedbackHospitalModel" object:arr userInfo:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //0 通讯录 1 直接 选择医院 调回 2 直接选择医院 并跳到医生 3 从产品 选择医院 调回 4 从产品 选择医院 跳到医生 5竞品
    ContactModel *model = dataArray[indexPath.row];
    
    if (_phonebook) {
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.popIndex = _popIndex;
        doctorVC.phonebook = YES;
        doctorVC.contactModel = model;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
        return;
    }
    if (_type == 1) {
        self.feedBackContactModelBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }else if (_type == 2){
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.popIndex = _popIndex;
        doctorVC.contactModel = model;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
    }else if (_type == 3){
        NSData *productdata = [NSKeyedArchiver archivedDataWithRootObject:self.productModel];
        NSData *contactData = [NSKeyedArchiver archivedDataWithRootObject:model];
        NSArray *costomerArray = @[productdata,contactData];
        NSUserDefaults *costomer = [NSUserDefaults standardUserDefaults];
        [costomer setObject:costomerArray forKey:@"costomerArray"];
        // 获取navigationcontroller栈中的正数第3个视图控制器
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES ];
    }
    else if (_type == 4){
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.contactModel = model;
        doctorVC.popIndex = _popIndex;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
    }
    else if (_type == 5){
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.contactModel = model;
        doctorVC.popIndex = _popIndex;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
    }else if (_type == 6){
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.contactModel = model;
        doctorVC.popIndex = _popIndex;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
        if (_allProduct) {
            doctorVC.type = 8;
            [doctorVC searchDoctorInHospitalSelectAction:^(DoctorsModel *doctormodel) {
                _feedBackHospitalAndDoctor(model, doctormodel);
            }];
        }
    }else if (_type == 7) {
        self.feedBackContactModelBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }else if (_type == 8) {
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.contactModel = model;
        doctorVC.type = 8;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
        
        [doctorVC searchDoctorInHospitalSelectAction:^(DoctorsModel *model) {
            _feedBackDoctorsModelBlock(model);
        }];
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
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    pageIndex=1;
    [self initData];
    
}
#pragma mark 上拉加载
-(void)createMJ{
    __block  ContactssViewController *contactssVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex = pageIndex + 1;
        [contactssVC initData];
    }];
}


@end
