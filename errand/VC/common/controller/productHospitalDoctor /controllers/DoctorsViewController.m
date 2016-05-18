//
//  DoctorsViewController.m
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorsViewController.h"
#import "StaffTableViewCell.h"
#import "ContactChildViewController.h"
#import "ContactBll.h"
#import "BATableView.h"
#import "CommonBll.h"
#import "DoctorFillViewController.h"
#import "DoctorDetailShowViewController.h"


@interface DoctorsViewController ()<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource,BATableViewDelegate>

@property (nonatomic, copy) void(^searchDoctorInHospitalCB)(DoctorsModel *model);

@end

@implementation DoctorsViewController{
    UISearchBar * _searchBar;
    // 初始时表单
    BATableView *_originTableView;
    
    //全体员工的数据
    NSMutableArray *allArray;
    
    //用于刷新界面的数据
    NSMutableArray *dataArray;
    
    UILabel *_titleLabel;
 
    
    // 索引test
    UIView * _suoYinView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createNavTitleView];
    [self createOriginTableView];
    
    // Do any additional setup after loading the view.
}

/**
 *  获得数据
 */
- (void)createNavTitleView{
    [self addBackButton];
  
    self.title = NSLocalizedString(@"chooseDoctor", @"chooseDoctor");

}

- (void)searchDoctorInHospitalSelectAction:(void(^)(DoctorsModel *model))action
{
    _searchDoctorInHospitalCB = action;
}


-(void)searchDoctorInHospital
{
    ContactBll *contactBll = [[ContactBll alloc]init];
    [contactBll searchDoctorInHospital:^(NSArray *arr) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allArray addObject:obj];
            
        }];
        dataArray = [NSMutableArray arrayWithArray:allArray];
        [self createSearchBar];
        [_originTableView reloadData];
        //        [self createSuoYinView];
        [self hideHud];
    } hospitalID:_contactModel.hospitalID  viewCtrl:self null:^{
        [Dialog simpleToast:@"没有更多数据"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)initData{
    
    [self showHintInView:self.view];
    
    if (_phonebook) {
        [self searchDoctorInHospital];
        return;
    }
    
    if (_type == 8) {
        [self searchDoctorInHospital];
        return;
    }
    
    //竞品
    if (_productionModel == nil) {
        CommonBll *commonBll = [[CommonBll alloc]init];
        [commonBll getCompetitionDoctorsData:^(NSArray *arr) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
                
            }];
            
            dataArray = [NSMutableArray arrayWithArray:allArray];
            [self createSearchBar];
            [_originTableView reloadData];
            [self hideHud];
        } hospitalID:_contactModel.hospitalID viewCtrl:self];
        
    }else{
        ContactBll *contactBll = [[ContactBll alloc]init];
        [contactBll getChoosedoctorsData:^(NSArray *arr) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
                
            }];
            
            dataArray = [NSMutableArray arrayWithArray:allArray];
            [self createSearchBar];
            [_originTableView reloadData];
            //        [self createSuoYinView];
            [self hideHud];
            
        }productID:_productionModel.productID  hospitalID:_contactModel.hospitalID  viewCtrl:self null:^{
            [Dialog simpleToast:@"没有更多数据"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
   
  
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([dataArray[indexPath.section] count]) {
        static NSString *CellTableIdentifier = @"staffCell";
//        StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
//        if (cell == nil) {
//            cell = [[StaffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier andType:1];
//        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
            cell.selectionStyle = 0;
        }
       
        DoctorsModel *model = dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text  =model.name;
        cell.detailTextLabel.text = model.office;
//            cell.nameLabel.text = model.name;
//            cell.phoneNumLabel.text = model.office;
//        
//        [cell.stateBtn setImage:[UIImage imageNamed:@"bottom_my"] forState:UIControlStateNormal];
//        cell.callPhoneBlock = ^(){
//            
//        };
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
    return 50;
//    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorsModel *model = dataArray[indexPath.section][indexPath.row];
    
    if (_phonebook == YES) {
        DoctorDetailShowViewController *doctorFillCtrl = [[DoctorDetailShowViewController alloc] init];
        doctorFillCtrl.doctorModel = model;
        [self.navigationController pushViewController:doctorFillCtrl animated:YES];
        
        return;
    }
    
    if (_type == 8) {
        _searchDoctorInHospitalCB(model);
        
        if (_popIndex == 0) {
            NSArray *array = self.navigationController.viewControllers;
            [self.navigationController popToViewController:array[array.count-3] animated:YES];
        }else
        {
            NSArray *array = self.navigationController.viewControllers;
            [self.navigationController popToViewController:array[2] animated:YES];
        }
        
        return;
    }
    
    //竞品不需要产品为前提
    if (self.productionModel == nil) {
        NSData *contactData = [NSKeyedArchiver archivedDataWithRootObject:self.contactModel];
        NSData *doctorsData = [NSKeyedArchiver archivedDataWithRootObject:model];
        NSArray *costomerArray = @[@"",contactData,doctorsData];
        NSUserDefaults *costomer = [NSUserDefaults standardUserDefaults];
        [costomer setObject:costomerArray forKey:@"costomerArray"];
    }else{
       NSData *productdata = [NSKeyedArchiver archivedDataWithRootObject:self.productionModel];
        NSData *contactData = [NSKeyedArchiver archivedDataWithRootObject:self.contactModel];
        NSData *doctorsData = [NSKeyedArchiver archivedDataWithRootObject:model];
        NSArray *costomerArray = @[productdata,contactData,doctorsData];
        NSUserDefaults *costomer = [NSUserDefaults standardUserDefaults];
        [costomer setObject:costomerArray forKey:@"costomerArray"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:addVisitSelectCustomerNotification object:self userInfo:nil];
    }
   
    if (_popIndex == 0) {
        // 获取navigationcontroller栈中的正数第3个视图控制器
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES ];
    }else {
        // 获取navigationcontroller栈中的正数第3个视图控制器
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:_popIndex] animated:YES ];
    }
    
    // 获取navigationcontroller栈中的倒数第4个视图控制器
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -4]animated:YES ];

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
    for (DoctorsModel *model in allArray) {
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
            for (DoctorsModel *model in allArray[i]) {
                if (([model.name rangeOfString:_searchBar.text].location != NSNotFound)||
                    ([[self transformToPinyinWithHanzi:model.name] rangeOfString:_searchBar.text].location!= NSNotFound)) {
                    [wordArray addObject:model];
                    //搜索结果后需要刷新一下
                }
            }
            if (wordArray.count > 0) {
                [dataArray addObject:wordArray];
            }
            
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
//- (void)createSuoYinView {
//    _suoYinView = [[UIView alloc] init];
//    //    _suoYinView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:_suoYinView];
//    
//    UIView *superView = self.view;
//    [_suoYinView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.top.equalTo(superView.mas_top).offset(100);
//        make.right.equalTo(superView.mas_right).offset(0);
//        make.centerY.equalTo(superView).offset(25);
//        make.width.equalTo(@20);
//        make.height.equalTo(@(superView.height - 64 - 49 - 27));
//    }];
//    
//    for (int i = 0; i < 27; i++) {
//        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, (superView.height - 64 - 49 - 27)/27 * i, 20, (superView.height - 64 - 49 - 27)/27)];
//        btn.tag = 100 + i;
//        if (SCREEN_HEIGHT < 568) {
//            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        }
//        if (SCREEN_WIDTH > 375) {
//            [btn.titleLabel setFont:[UIFont systemFontOfSize:20]];
//        }
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000] forState:UIControlStateHighlighted];
//        if (i == 26) {
//            [btn setTitle:@"#" forState:UIControlStateNormal];
//        } else {
//            
//            [btn setTitle:[NSString stringWithFormat:@"%c",65+i] forState:UIControlStateNormal];
//        }
//        [btn addTarget:self action:@selector(suoYinBtn:) forControlEvents:UIControlEventAllTouchEvents];
//        
//        [_suoYinView addSubview:btn];
//    }
//}

//- (void)suoYinBtn:(UIButton *)btn {
//    DoctorsModel *model;
//    UIView *view;
//    UILabel *label;
//    //    if (view == nil) {
//    view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -(SCREEN_WIDTH / 5))/2, (SCREEN_HEIGHT -(SCREEN_WIDTH / 5))/2+64+64, SCREEN_WIDTH / 5, SCREEN_WIDTH / 5)];
//    view.backgroundColor = COMMON_BLUE_COLOR;
//    
//    [self.view addSubview:view];
//    label = [[UILabel alloc]init];
//    label.text= btn.titleLabel.text;
//    label.textColor = COMMON_FONT_BLACK_COLOR;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:[MyAdapter aDapterView:27]];
//    [view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(view);
//        make.centerY.equalTo(view);
//        make.width.equalTo(view.mas_width);
//        make.height.equalTo(view.mas_height);
//    }];
//    //    }
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [view removeFromSuperview];
//    });
//    int i = 0;
//    for (i = 0; i < dataArray.count; i++) {
//        
//        
//        model = dataArray[i][0];
//        if ([btn.currentTitle isEqualToString:model.firstCharactor]) {
//            [_originTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            return;
//        }
//    }
//    
//}
- (NSString *)transformToPinyinWithHanzi:(NSString*)hanzi{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:hanzi];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
    
    return ms;
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
