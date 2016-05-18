//
//  SelectStaffViewController.m
//  errand
//
//  Created by gravel on 16/3/1.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SelectStaffViewController.h"
#import "StaffTableViewCell.h"
#import "OrganizationBll.h"
#import "BATableView.h"
#import "DepartmentView.h"
#import "SelectDepartmentVC.h"//选择部门
#import "Node.h"
#import "SalesDailyBll.h"
#import "FirstOrganizationalVC.h"
@interface SelectStaffViewController ()<UISearchBarDelegate, BATableViewDelegate>

@end

@implementation SelectStaffViewController{
    UISearchBar * _searchBar;
    // 初始时表单
    BATableView *_originTableView;
    
    //全体员工的数据
    NSMutableArray *allArray;
    
    //用于刷新界面的数据
    NSMutableArray *dataArray;
    
    UILabel *_titleLabel;
    UIView *_popUpView;
    
    UIButton *_sureButton;
    
//   被选中个数
    int count;
    
    // 选中展示 scrollview
    UIScrollView * _selectedScrollView;
    
    // 选中所需艾特对象存储数组
    NSMutableArray * _selectedArray;
    
    float _btnX;
    float _btnY;
    int _tag;
    
    //被选中的部门
    NSMutableArray *_departmentSelectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createNavTitleView];
    [self createOriginTableView];
    [self addBackButton];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"_type_type%d", _type);
}
//- (void)resetTableViewInset
//{
//    _originTableView.frame = CGRectMake(0, 44+21, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
//    _originTableView.tableView.frame = _originTableView.bounds;
//    _selectedScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH - 100, 44);
//    _sureButton.frame = CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 44, 100, 44);
//    
//}

/**
 *  获得数据
 */
- (void)createNavTitleView{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 44)];
    _titleLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"selectStaff", @"selectStaff")];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = _titleLabel;
}



- (void)initData{
    [self showHintInView:self.view];
    if (_type == 0) {
        OrganizationBll *organizationBll = [[OrganizationBll alloc]init];
        [organizationBll getSecondOrgnizationData:^(NSArray *arr) {
            [self hideHud];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
            }];
            
            if (_taskSearchPeople) {
                [self createSearchBar];
            }
            if (_reportSearchPublish) {
                [self createSearchBar];
            }
            
            [self createBottomView];
            [self createDepartmentView];
            dataArray = [NSMutableArray arrayWithArray:allArray];
            [self matchSelectedModel];
            [_originTableView reloadData];
            
        } viewCtrl:self];
    }else{
        SalesDailyBll *bll = [[SalesDailyBll alloc]init];
        [bll getMyMemberData:^(NSArray *arr) {
            NSLog(@"getMyMemberData --- %@", arr);
            [self hideHud];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [allArray addObject:obj];
            }];
            [self createSearchBar];
            [self createBottomView];
            [self createDepartmentView];
            NSLog(@"getMyMemberDataallArray --- %@", allArray);
            dataArray = [NSMutableArray arrayWithArray:allArray];
            
            [self matchSelectedModel];
            
            [_originTableView reloadData];
            
        } viewCtrl:self null:^{
            [Dialog simpleToast:NoMoreData];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (void)matchSelectedModel
{
    
    for (StaffModel *selectedModel in _staffModelArray) {
        for (NSArray *array in dataArray) {
            
            for (StaffModel *model in array) {
                if ([model.ID isEqual:selectedModel.ID]) {
                    model.mSelect = YES;
                    
                    [_selectedArray addObject:model];
                    [self createButtonWithTitle:model.staffName andID:model.ID colorType:0];
                }
            }
            
        }
    }
    
    [_sureButton setTitle:[NSString stringWithFormat:@"确定(%ld)",(_selectedArray.count)] forState:UIControlStateNormal];
    
    for (NSDictionary *selectedDic in _staffDicArray) {
        for (NSArray *array in dataArray) {
            
            for (StaffModel *model in array) {
                if ([model.ID isEqual:selectedDic[@"ID"]]) {
                    model.mSelect = YES;
                    
                    [_selectedArray addObject:model];
                    [self createButtonWithTitle:model.staffName andID:model.ID colorType:0];
                }
            }
            
        }
    }
    
    [_sureButton setTitle:[NSString stringWithFormat:@"确定(%ld)",(_selectedArray.count)] forState:UIControlStateNormal];
    
}


/**
 *  建立搜索栏
 */
- (void)createSearchBar {
    
    
    if ( _type == 3) {
//        UIView *searchBg = [[UIView alloc]initWithFrame:CGRectMake(10, 4 + 64 , SCREEN_WIDTH-20, 44-8)];
//        searchBg.backgroundColor = [UIColor redColor];
//        searchBg.layer.cornerRadius = 18;
//        searchBg.clipsToBounds = YES;
//        [self.view addSubview:searchBg];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,  64, SCREEN_WIDTH, 44)];
        _searchBar.placeholder = @"请输入关键字";
        [_searchBar setContentMode:UIViewContentModeCenter];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = [UIColor blueColor];
//        _searchBar.backgroundImage = [self imageWithColor:COMMON_BACK_COLOR size:_searchBar.bounds.size];
//        _searchBar.barTintColor = [UIColor whiteColor];
//        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.view addSubview:_searchBar];

    }else{
        UIView *searchBg = [[UIView alloc]initWithFrame:CGRectMake(10, 4, SCREEN_WIDTH-20, 44-8)];
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
        
        if (_subordinateLayout) {
            searchBg.frame = CGRectMake(10, 64+4, SCREEN_WIDTH-20, 44-8);
        }
    }
   
}

- (void)createDepartmentView{
    //type为2或3时 不需要选择部门
    if (_type !=2 && _type != 3) {

        if (_reportSearchPublish) {
            return;
        }
            DepartmentView *view = [[DepartmentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            [self.view addSubview:view];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(departmentTap)];
            [view addGestureRecognizer:tap];
    }
    
    
}

/**
 *  按部门选择 点击事件
 */
- (void)departmentTap{
    
    //跳到选择部门界面
    
    if (_searchVisitRecord) {
        FirstOrganizationalVC *organizationVC = [[FirstOrganizationalVC alloc]init];
        organizationVC.type =2;
        organizationVC.title = @"选择人员";
        organizationVC.selectDicArray = _staffDicArray;
        organizationVC.searchVisitRecord = YES;
        [self.navigationController pushViewController:organizationVC animated:YES];
        [organizationVC setFeedBackStaffArrayCB:^(NSMutableArray *dicArray) {
            for (NSDictionary *dic in dicArray) {
                StaffModel *model = [[StaffModel alloc] init];
                model.mSelect = YES;
                model.ID = dic[@"ID"];
                model.staffName = dic[@"name"];
                
                for (NSInteger i=0; i<dataArray.count; i++) {
                    NSMutableArray *modelArray = dataArray[i];
                    for (NSInteger j=0; j<modelArray.count; j++) {
                        StaffModel *allModel = modelArray[j];
                        if ([allModel.ID isEqual:model.ID]) {
                            allModel.mSelect = YES;
                            
                            BOOL hasSelect = NO;
                            for (NSInteger i=0; i<_selectedArray.count; i++) {
                                StaffModel *seModel = _selectedArray[i];
                                if ([seModel.ID isEqual:model.ID]) {
                                    hasSelect = YES;
                                    break;
                                    
                                }
                            }
                            if (hasSelect == NO) {
                                [_selectedArray addObject:allModel];
                                [self createButtonWithTitle:model.staffName andID:model.ID colorType:0];
                            }
                        }
                    }
                }
                
            }
            [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(_selectedArray.count + _departmentSelectArray.count)] forState:UIControlStateNormal];
            NSLog(@"%@", dataArray);
            [_originTableView reloadData];
        }];
        return;
    }
    
    if (_selectCarryPeople) {
        FirstOrganizationalVC *organizationVC = [[FirstOrganizationalVC alloc]init];
        organizationVC.type =2;
        organizationVC.title = @"选择人员";
        organizationVC.selectCarryPeople = YES;
        [self.navigationController pushViewController:organizationVC animated:YES];
        organizationVC.feedBackStaffInfoBlock = ^(NSString *staffName,NSNumber *staffID){
            _seletNodeStaffBlock(staffName, staffID);
        };
        return;
    }
   
        SelectDepartmentVC *vc = [[SelectDepartmentVC alloc]init];
    vc.extendedLayoutIncludesOpaqueBars = self.extendedLayoutIncludesOpaqueBars;
    vc.edgesForExtendedLayout = self.edgesForExtendedLayout;
        vc.type = _type;
    vc.selectCarryPeople = _selectCarryPeople;
        vc.departmentSelectArray = [NSMutableArray arrayWithArray:_departmentSelectArray];
        [self.navigationController pushViewController:vc animated:YES];
        vc.departmentSelectArrayBlock = ^(NSMutableArray *selectArray){
            
            if (_departmentSelectArray.count) {
                
                for (int i = 0; i < _departmentSelectArray.count; i++) {
                    
                    UIButton * btn = (UIButton *)[_selectedScrollView viewWithTag:[_departmentSelectArray[i] nodeId]];
                    if (i == 0 ) {
                        _btnX = btn.frame.origin.x;
                        _btnY = btn.frame.origin.y;
                    }
                    [btn removeFromSuperview];
                }
                _selectedScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 100, _btnY + 20);
            }
            
            _departmentSelectArray = selectArray;
            
            [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)", (_selectedArray.count + _departmentSelectArray.count)] forState:UIControlStateNormal];
            
            for (int i = 0; i < _departmentSelectArray.count; i++) {
                
                [self createButtonWithTitle:[_departmentSelectArray[i] name] andID:[NSString stringWithFormat:@"%d", [_departmentSelectArray[i] nodeId]] colorType:1];
            }
            
        };
    
}
/**
 *  建立员工表
 */
- (void)createOriginTableView{
    _departmentSelectArray = [NSMutableArray array];
    allArray = [NSMutableArray array];
    if (_type ==2 ) {
         _originTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 44 , SCREEN_WIDTH, SCREEN_HEIGHT-64-44  - 44 )];
    }else if (_type == 3){
        _originTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 44  + 64 , SCREEN_WIDTH, SCREEN_HEIGHT-64-44  - 44 )];
    }else{
//        _originTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 44 + 50, SCREEN_WIDTH, SCREEN_HEIGHT-64-44  - 44 - 50)];
       _originTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-64-44   - 50)];
    }
    
    if (_subordinateLayout) {
        _originTableView.frame = CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-50);
        _originTableView.tableView.frame = _originTableView.bounds;
    }
    
    _originTableView.delegate = self;
//    _originTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _originTableView.backgroundColor = COMMON_BACK_COLOR;
    _originTableView.tableView.bounces = NO;
    [self.view addSubview:_originTableView];
    // 通过手势收起 searchBar 弹出的键盘
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [_originTableView addGestureRecognizer:tapGesture];
    [self initData];
    
    
}

/**
 *  建立底部确定 视图
 */
- (void)createBottomView{
    _selectedArray = [NSMutableArray array];
    [self createSelectedScrollView];
    if (_type != 3) {
        _sureButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT  - 64 - 44, 100, 44)];
    }else{
        _sureButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT  - 44, 100, 44)];
    }
    
    if (_subordinateLayout) {
        _sureButton.frame = CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 44, 100, 44);
    }
    
    _sureButton.backgroundColor = COMMON_BLUE_COLOR;
    [_sureButton setTitle:@"确定(0)" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_sureButton];
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --- 确定的点击事件
- (void)sureButtonClick{
    if (_selectCarryPeople) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_searchVisitRecord) {
        NSMutableArray *dicArray = [NSMutableArray array];
        for (StaffModel *model in _selectedArray) {
            NSDictionary *dic = @{@"name": model.staffName, @"ID": model.ID};
            [dicArray addObject:dic];
        }
        if (dicArray.count != 0) {
            _searchVisitRecordStaffCB(dicArray);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_type == 2) {
        self.selectstaffArrayBlock(_selectedArray);
    }else{
        if (_reportSearchPublish) {
            self.selectstaffArrayBlock(_selectedArray);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if ((_selectedArray.count != 0)||(_departmentSelectArray.count != 0)) {
            self.selectArrayBlock(_selectedArray,_departmentSelectArray);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 创建展示选中人员 _selectedArray
- (void)createSelectedScrollView {
    
    _btnX = 0;
    _btnY = 0;
    _tag = 0;
    if (_type != 3) {
        _selectedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH - 100, 44)];
    }else{
        _selectedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 , SCREEN_WIDTH - 100, 44)];
    }
    
    if (_subordinateLayout) {
        _selectedScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH - 100, 44);
    }
    
    _selectedScrollView.backgroundColor = [UIColor whiteColor];
    _selectedScrollView.bounces = NO;
    [self.view addSubview:_selectedScrollView];
}

// @的每一个对象均为一个btn
- (void)createButtonWithTitle:(NSString *)title andID:(NSString *)ID colorType:(int)colorType{
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:13]];
    size.width += 10;
    if (_btnX + size.width > SCREEN_WIDTH - 100) {
        
        _btnY += 20;
        _btnX = 0;
        _selectedScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 100, _btnY + 20);
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_btnX, _btnY, size.width, 20)];
    btn.tag = [ID intValue];
    [btn setTitle:title forState:UIControlStateNormal];
    if (colorType == 0) {
        [btn setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    _btnX += size.width;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedScrollView addSubview:btn];
//    _selectedScrollView.contentOffset = CGPointMake(0, _btnY);
    if (_btnY > 44) {
        _selectedScrollView.contentOffset = CGPointMake(0, _btnY - 44);
    }
}

- (void)btnClick:(UIButton *)btn {

    //数据源是二维数组
    //不在视图上的NSPathindex 为nil
    int j =0 ;
    int i = 0;
    for (j = 0; j <dataArray.count; j++) {
        for (i = 0; i < [dataArray[j] count]; i++) {
            UITableViewCell *cell = [_originTableView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
//            NSLog(@"%@",[dataArray[j][i] staffName]);
            
            if ([btn.currentTitle isEqualToString:[dataArray[j][i] staffName]]) {
                cell.imageView.image = [UIImage imageNamed:@"itemchoice_unchecked"];
                
                //
                // 更新数据源
                NSMutableArray * array = [NSMutableArray arrayWithArray:dataArray[j]];
                StaffModel *model2 = array[i];
                model2.mSelect = NO;
                [array replaceObjectAtIndex:i withObject:model2];
                [dataArray replaceObjectAtIndex:j withObject:array];
                // 更新 _selectedScrollView UI
//                for (StaffModel *model in _selectedArray) {
//                    if ([model.ID intValue] == btn.tag) {
//                        [_selectedArray removeObject:model];
//                        break;
//                    }
//                }
                _btnY = btn.frame.origin.y;
                _btnX = btn.frame.origin.x;
                
                int k;
                for (k = 0; k < _selectedArray.count; k++) {
//                    NSLog(@"%d    %d", [[_selectedArray[k] ID] intValue], btn.tag);
                    if ([[_selectedArray[k] ID] intValue] == btn.tag) {
                        [_selectedArray removeObjectAtIndex:k];
                        [btn removeFromSuperview];
                        break;
                    }
                }
                for (k = k; k < _selectedArray.count; k++) {
                    UIButton * button = [_selectedScrollView viewWithTag:[[_selectedArray[k] ID] intValue]];
                    [button removeFromSuperview];
                    [self createButtonWithTitle:[_selectedArray[k] staffName] andID:[_selectedArray[k] ID] colorType:0];
                }
                for (k = 0; k < _departmentSelectArray.count; k++) {
                    UIButton * button = [_selectedScrollView viewWithTag:[_departmentSelectArray[k] nodeId]];
                    [button removeFromSuperview];
                    [self createButtonWithTitle:[_departmentSelectArray[k] name] andID:[NSString stringWithFormat:@"%d", [_departmentSelectArray[k] nodeId]] colorType:1];
                }
                [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)", (_selectedArray.count + _departmentSelectArray.count)] forState:UIControlStateNormal];
//                _selectedScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT + 20);
                break;
            }
            
        }
    }
    
    for (int i = 0; i < _departmentSelectArray.count; i++) {
        
        if (btn.tag == [_departmentSelectArray[i] nodeId]) {
            
            _btnX = btn.frame.origin.x;
            _btnY = btn.frame.origin.y;
            [btn removeFromSuperview];
            [_departmentSelectArray removeObjectAtIndex:i];
            for (i = i; i < _departmentSelectArray.count; i++) {
                
                UIButton * button = [_selectedScrollView viewWithTag:[_departmentSelectArray[i] nodeId]];
                [button removeFromSuperview];
                [self createButtonWithTitle:[_departmentSelectArray[i] name] andID:[NSString stringWithFormat:@"%d", [_departmentSelectArray[i] nodeId]] colorType:1];
            }
            [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)", (_selectedArray.count + _departmentSelectArray.count)] forState:UIControlStateNormal];
            break;
        }
    }
    _selectedScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 100, _btnY + 20);
//    _selectedScrollView.contentOffset = CGPointMake(0, _btnY);
}

// 根据 _selectedArray 创建@对象的btn
- (void)createBtnBySelectedarray {
    
    for (int i = 0; i < _selectedArray.count; i++) {
        
        [self createButtonWithTitle:[_selectedArray[i] staffName] andID:[_selectedArray[i] ID]  colorType:0];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier];
        }
        StaffModel *model;
        model = dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text = model.staffName;
        cell.detailTextLabel.text = model.phoneNumber;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model.mSelect == YES) {
            cell.imageView.image = [UIImage imageNamed:@"itemchoice_checked"];
            if (_type == 3 || _selectCarryPeople == YES) {
                cell.imageView.image = [UIImage imageNamed:@""];
            }

        }
        else{
             cell.imageView.image = [UIImage imageNamed:@"itemchoice_unchecked"] ;
            if (_type == 3 || _selectCarryPeople == YES) {
                cell.imageView.image = [UIImage imageNamed:@""];
            }
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

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
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_originTableView.tableView cellForRowAtIndexPath:indexPath];
    StaffModel *model = dataArray[indexPath.section][indexPath.row];
    
    if (_selectCarryPeople == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        self.selectstaffBlock(model);
        return;
    }
    
    if (_taskSearchPeople == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        self.selectstaffBlock(model);
        return;
    }
    //type==3时  是单选 然后跳到上一级页面
    if (_type == 3) {
        
         [self.navigationController popViewControllerAnimated:YES];
         self.selectstaffBlock(model);
       
        
    }else{
        if (model.mSelect == NO) {
            
            cell.imageView.image = [UIImage imageNamed:@"itemchoice_checked"];
            if (_type == 3) {
                cell.imageView.image = [UIImage imageNamed:@""];
            }
            
            [_selectedArray addObject:model];
            [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(_selectedArray.count + _departmentSelectArray.count)] forState:UIControlStateNormal];
            for (int i = 0; i < _departmentSelectArray.count; i++) {
                UIButton * btn = [_selectedScrollView viewWithTag:[_departmentSelectArray[i] nodeId]];
                if (i == 0) {
                    _btnX = btn.frame.origin.x;
                    _btnY = btn.frame.origin.y;
                }
                [btn removeFromSuperview];
            }
            [self createButtonWithTitle:model.staffName andID:model.ID colorType:0];
            for (int i = 0; i < _departmentSelectArray.count; i++) {
                [self createButtonWithTitle:[_departmentSelectArray[i] name] andID:[NSString stringWithFormat:@"%d", [_departmentSelectArray[i] nodeId]] colorType:1];
            }
            model.mSelect = YES;
        }else{
            cell.imageView.image = [UIImage imageNamed:@"itemchoice_unchecked"];
            if (_type == 3) {
                cell.imageView.image = [UIImage imageNamed:@""];
            }
            model.mSelect = NO;
            
            // 删除数组中的model
            int i;
            for (i = 0; i < _selectedArray.count; i++) {
                
                if ([model.ID intValue] == [[_selectedArray[i] ID] intValue]) {
                    [_selectedArray removeObjectAtIndex:i];
                    UIButton *btn = [_selectedScrollView viewWithTag:[model.ID intValue]];
                    _btnY = btn.frame.origin.y;
                    _btnX = btn.frame.origin.x;
                    [btn removeFromSuperview];
                    break;
                }
            }
            [_sureButton setTitle:[NSString stringWithFormat:@"确定(%lu)",(_selectedArray.count + _departmentSelectArray.count)] forState:UIControlStateNormal];
            
            for (i = i; i < _selectedArray.count; i++) {
                
                UIButton *btn = [_selectedScrollView viewWithTag:[[_selectedArray[i] ID] intValue]];
                [btn removeFromSuperview];
                [self createButtonWithTitle:[_selectedArray[i] staffName] andID:[_selectedArray[i] ID] colorType:0];
            }
            for (int j = 0; j < _departmentSelectArray.count; j++) {
                
                UIButton *btn = [_selectedScrollView viewWithTag:[_departmentSelectArray[j] nodeId]];
                [btn removeFromSuperview];
                [self createButtonWithTitle:[_departmentSelectArray[j] name] andID:[NSString stringWithFormat:@"%d", [_departmentSelectArray[j] nodeId]] colorType:1];
            }
            
            // 刷新 _selectedScrollView
            //        [_selectedScrollView removeFromSuperview];
            //        [self createSelectedScrollView];
            //        [self createBtnBySelectedarray];
        }
        _selectedScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 100, _btnY + 20);
        if (_btnY > 44) {
            _selectedScrollView.contentOffset = CGPointMake(0, _btnY - 44);
        }
        NSMutableArray * array = [NSMutableArray arrayWithArray:dataArray[indexPath.section]];
        [array replaceObjectAtIndex:indexPath.row withObject:model];
        [dataArray replaceObjectAtIndex:indexPath.section withObject:array];
        
    }
  
}
#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    [dataArray removeAllObjects];
    for (StaffModel *model in allArray) {
        [dataArray addObject:model];
    }
    [_originTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([_searchBar.text isEqualToString:@""] ) {
        [dataArray removeAllObjects];
        dataArray = [NSMutableArray arrayWithArray:allArray];
        
    }else{
        [dataArray removeAllObjects];
        for (int i = 0; i < allArray.count; i++) {
            NSMutableArray *wordArray = [NSMutableArray array];
            for (StaffModel *model in allArray[i]) {
                if (([model.staffName rangeOfString:_searchBar.text].location != NSNotFound)||
                    ([[self transformToPinyinWithHanzi:model.staffName] rangeOfString:_searchBar.text].location!= NSNotFound)) {
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
//获取汉语拼音
- (NSString *)transformToPinyinWithHanzi:(NSString*)hanzi{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:hanzi];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
    
    return ms;
}

#pragma mark - 手势收起键盘
-(void)dismissKeyBoard{
    [_searchBar resignFirstResponder];
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


