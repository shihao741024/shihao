//
//  ContactViewController.m
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "ContactViewController.h"
#import "StaffTableViewCell.h"
#import "ContactChildViewController.h"
#import "ContactBll.h"
#import "PulldownMenu.h"
#import "DoctorsViewController.h"
#import "BATableView.h"
#import "CommonBll.h"
#import "SearchDoctorViewController.h"
#import "HospitalTableViewCell.h"

@interface ContactViewController ()<UISearchBarDelegate,PulldownMenuDelegate,SRRefreshDelegate, BATableViewDelegate>

@end

@implementation ContactViewController{
    UISearchBar * _searchBar;
 
    BATableView *_originTableView;
  
    //全体员工的数据
    NSMutableArray *allArray;
    
    //用于刷新界面的数据
    NSMutableArray *dataArray;
    
    UILabel *_titleLabel;
    UIView *_popUpView;
    
     // 索引test
    UIView * _suoYinView;
    PulldownMenu *pulldownMenu;
    int pageIndex;
    SRRefreshView *_slimeView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
//    [self createNavTitleView];
    self.title = @"选择医院";
    [self addBackButton];
     [self createOriginTableView];
   
    if (_phonebook) {
        [self createRightSearchItem];
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [pulldownMenu shouqiMenu];
    
    
}

- (void)createRightSearchItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)RecordsearchClick
{
    SearchDoctorViewController *searchDoctorCtrl = [[SearchDoctorViewController alloc] init];
    [self.navigationController pushViewController:searchDoctorCtrl animated:YES];
}


/**
 *  获得数据
 */
- (void)createNavTitleView{
    [self addBackButton];
    if (_type == 1) {
        self.title = NSLocalizedString(@"chooseHospital", @"chooseHospital");
    }else{
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 44)];
        _titleLabel.text = [NSString stringWithFormat:@"%@^", NSLocalizedString(@"allCustomer", @"allCustomer")];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.userInteractionEnabled = YES;
        self.navigationItem.titleView = _titleLabel;
        
        pulldownMenu = [[PulldownMenu alloc] initWithNavigationController:self.navigationController andTitleLabel:_titleLabel];
        [self.navigationController.view insertSubview:pulldownMenu belowSubview:self.navigationController.navigationBar];
        
        [pulldownMenu insertButton:[NSString stringWithFormat:@"%@^", NSLocalizedString(@"allCustomer", @"allCustomer")]];
        [pulldownMenu insertButton:[NSString stringWithFormat:@"%@^", NSLocalizedString(@"sortByAge", @"sortByAge")]];
        [pulldownMenu insertButton:[NSString stringWithFormat:@"%@^", NSLocalizedString(@"sortByApartment", @"sortByApartment")]];
        
        pulldownMenu.delegate = self;
        
        [pulldownMenu loadMenu];

    }
    
    
    
    
}

-(void)menuItemSelected:(NSIndexPath *)indexPath andSelectedTitle:(NSString *)title
{
    _titleLabel.text = title;
    [pulldownMenu animateDropDown];
}

-(void)pullDownAnimated:(BOOL)open
{
    if (open)
    {
      
        NSLog(@"Pull down menu open!");
    }
    else
    {
    
        NSLog(@"Pull down menu closed!");
    }
}

- (void)initData{
 
    ContactBll *contactBLL = [[ContactBll alloc]init];
    if (_type == 0) {
        if(!pageIndex){
            [self showHintInView:self.view];
            pageIndex=1;
        }else if(pageIndex==1){
            [self showInfica];
        }else{
            [self showInfica];
        }
        [contactBLL getAllContactDataData:^(NSArray *arr) {
            if(pageIndex==1)
            {
                [allArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
                
            }];
            dataArray = [NSMutableArray arrayWithArray:allArray];
            [self createSearchBar];
            
            if (dataArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [_originTableView reloadData];
            //            [self createSuoYinView];
            [self hideHud];
            //            [_slimeView endRefresh];
            //            [_originTableView footerEndRefreshing];
            
        } pageIndex:pageIndex viewCtrl:self];

    }else if (_type == 5){
         [self showHintInView:self.view];
        CommonBll *commonBll = [[CommonBll alloc]init];
        [commonBll getCompetitionHospitalData:^(NSArray *arr) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
                
            }];
            dataArray = [NSMutableArray arrayWithArray:allArray];
            if (dataArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [_originTableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];

        } viewCtrl:self];
    }
    else if (_type == 7 || _type == 8 || _allProduct == YES) {
        [self showHintInView:self.view];
        [contactBLL getTypeHospitalsData:^(NSArray *arr) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
                
            }];
            dataArray = [NSMutableArray arrayWithArray:allArray];
            if (dataArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [_originTableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
        } viewCtrl:self];
    }
    else{
        [self showHintInView:self.view];
        [contactBLL gethospitalsData:^(NSArray *arr) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
                
            }];
            dataArray = [NSMutableArray arrayWithArray:allArray];
            if (dataArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [_originTableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            //            [_originTableView footerEndRefreshing];
            
        } productID:_productModel.productID viewCtrl:self];
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
    
    [_originTableView.tableView addSubview:_slimeView];
}

/**
 *  建立搜索栏
 */
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
/**
 *  建立员工表
 */
- (void)createOriginTableView{
    allArray = [NSMutableArray array];
    dataArray = [NSMutableArray array];
    _originTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
//    _originTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _originTableView.delegate = self;
    _originTableView.backgroundColor = COMMON_BACK_COLOR;
    [self.view addSubview:_originTableView];
    // 通过手势收起 searchBar 弹出的键盘
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [_originTableView addGestureRecognizer:tapGesture];
    [self createSearchBar];
      [self initData];
//    [self createSlime];
//    [self createMJ];
    
}

#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    
    NSMutableArray *indexTitle = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        [indexTitle addObject:[NSString stringWithFormat:@"%c", i + 65]];
    }
    [indexTitle addObject:@"#"];
    return indexTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dataArray[section] count] == 0) {
        return 1;
    }
    return [dataArray[section] count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([dataArray[section] count] == 0) {
        return 0;
    }
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    ContactModel *model = dataArray[section][0];
    if (section + 65 > 90) {
        return @"    #";
    }else {
        return [NSString stringWithFormat:@"    %c", (int)section + 65];
    }
}

- (void)backProductAndHospital:(HospitalTableViewCell *)selectCell
{
    NSIndexPath *indexPath = [_originTableView.tableView indexPathForCell:selectCell];
    
    //发送通知
    ContactModel *model = dataArray[indexPath.section][indexPath.row];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([dataArray[indexPath.section] count]) {
        static NSString *cellid = @"hospitalCell";
        HospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[HospitalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            
            if (_type == 6) {
                [cell selectButtonAction:^(HospitalTableViewCell *selectCell) {
                    
                    [self backProductAndHospital:selectCell];
                }];
            }
            
        }
        
        if ([dataArray[indexPath.section] count] == 0) {
            [cell hideAllView:YES];
        }else {
            if (_type == 6) {
                [cell fillData:dataArray[indexPath.section][indexPath.row] hideSelectBtn:NO];
            }else {
                [cell fillData:dataArray[indexPath.section][indexPath.row] hideSelectBtn:YES];
            }
            
        }
        
        cell.backgroundColor = COMMON_BACK_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    } else {
        static NSString *blankCell = @"blankCell";
        StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
        if (!cell) {
            cell = [[StaffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankCell andType:0];
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([dataArray[indexPath.section] count] == 0) {
        return 0;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //0 通讯录 1 直接 选择医院 调回 2 直接选择医院 并跳到医生 3 从产品 选择医院 调回 4 从产品 选择医院 跳到医生 5竞品
    ContactModel *model = dataArray[indexPath.section][indexPath.row];
    
    if (_phonebook) {
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.contactModel = model;
        doctorVC.phonebook = YES;
        doctorVC.productionModel = self.productModel;
        [self.navigationController pushViewController:doctorVC animated:YES];
        
        [doctorVC searchDoctorInHospitalSelectAction:^(DoctorsModel *model) {
            //                _feedBackDoctorsModelBlock(model);
        }];
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
        
        
    }
    else if (_type == 7) {
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
    else{
        [pulldownMenu shouqiMenu];
        dataArray = [NSMutableArray arrayWithArray:allArray];
        ContactChildViewController *contactChild = [[ContactChildViewController alloc]init];
        contactChild.hospitalID = [dataArray[indexPath.section][indexPath.row] hospitalID];
        [self.navigationController pushViewController:contactChild animated:YES];
    }
    NSLog(@"ContactViewController=%@", dataArray);
}



#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    _searchBar.showsCancelButton = YES;
//    UIView *topView = _searchBar.subviews[0];
//    UIButton *cancelButton = [[UIButton alloc]init];
//    for (UIView *subView in topView.subviews) {
//        
//        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//            
//            cancelButton = (UIButton*)subView;
//            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            
//        }
//        
//    }
    _suoYinView.hidden = YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
//    _searchBar.showsCancelButton = NO;
    [dataArray removeAllObjects];
    for (ContactModel *model in allArray) {
        [dataArray addObject:model];
    }
    [_originTableView reloadData];
    _suoYinView.hidden = NO;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//        _searchBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([_searchBar.text isEqualToString:@""] ) {
        [dataArray removeAllObjects];
        dataArray = [NSMutableArray arrayWithArray:allArray];
       
    }else{
        [dataArray removeAllObjects];
        for (int i = 0; i < allArray.count; i++) {
            NSMutableArray *wordArray = [NSMutableArray array];
            for (ContactModel *model in allArray[i]) {
                if (([model.hospitalName rangeOfString:_searchBar.text].location != NSNotFound)||
                    ([[self transformToPinyinWithHanzi:model.hospitalName] rangeOfString:_searchBar.text].location!= NSNotFound)) {
                    [wordArray addObject:model];
                    //搜索结果后需要刷新一下
                }
            }
//            if (wordArray.count > 0) {
                [dataArray addObject:wordArray];
//            }
            
        }

    }
    [_originTableView reloadData];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //    NSLog(@"22");
}


#pragma mark - 手势收起键盘
-(void)dismissKeyBoard{
    [_searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 索引测试使用
#if 0
- (void)createSuoYinView {
    _suoYinView = [[UIView alloc] init];
    //    _suoYinView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_suoYinView];
    
    UIView *superView = self.view;
    [_suoYinView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(superView.mas_top).offset(100);
        make.right.equalTo(superView.mas_right).offset(0);
        make.centerY.equalTo(superView).offset(25);
        make.width.equalTo(@20);
        make.height.equalTo(@(superView.height - 64 - 49 - 27));
    }];
    
    for (int i = 0; i < 27; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, (superView.height - 64 - 49 - 27)/27 * i, 20, (superView.height - 64 - 49 - 27)/27)];
        btn.tag = 100 + i;
        if (SCREEN_HEIGHT < 568) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
        if (SCREEN_WIDTH > 375) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
        if (i == 26) {
            [btn setTitle:@"#" forState:UIControlStateNormal];
        } else {

            [btn setTitle:[NSString stringWithFormat:@"%c",65+i] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(suoYinBtn:) forControlEvents:UIControlEventAllTouchEvents];

        [_suoYinView addSubview:btn];
    }
}

- (void)suoYinBtn:(UIButton *)btn {
    ContactModel *model;
    UIView *view;
    UILabel *label;
//    if (view == nil) {
        view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -(SCREEN_WIDTH / 5))/2, (SCREEN_HEIGHT -(SCREEN_WIDTH / 5))/2+64+64, SCREEN_WIDTH / 5, SCREEN_WIDTH / 5)];
    view.backgroundColor = COMMON_BLUE_COLOR;
    
        [self.view addSubview:view];
        label = [[UILabel alloc]init];
        label.text= btn.titleLabel.text;
    label.textColor = COMMON_FONT_BLACK_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:[MyAdapter aDapterView:27]];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.centerY.equalTo(view);
            make.width.equalTo(view.mas_width);
            make.height.equalTo(view.mas_height);
        }];
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
    int i = 0;
    for (i = 0; i < dataArray.count; i++) {
      
       
        model = dataArray[i][0];
        if ([btn.currentTitle isEqualToString:model.firstCharactor]) {
            [_originTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return;
        }
    }

}
#endif

//获取汉语拼音
- (NSString *)transformToPinyinWithHanzi:(NSString*)hanzi{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:hanzi];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
   
    return ms;
}
#pragma mark - scrollView delegate

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
    pageIndex=1;
    [self initData];
    
}
#pragma mark 上拉加载
//-(void)createMJ{
//    __block  ContactViewController *contactVC = self;
//    [_originTableView addFooterWithCallback:^{
//        pageIndex=pageIndex + 1;
//        [contactVC initData];
//    }];
//}



@end
