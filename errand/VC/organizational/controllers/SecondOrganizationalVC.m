//
//  OrganizationalViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SecondOrganizationalVC.h"
#import "StaffModel.h"
#import "StaffTableViewCell.h"
#import "OrganizationalChildViewController.h"
#import "OrganizationBll.h"
#import "PulldownMenu.h"
#import "BATableView.h"
@interface SecondOrganizationalVC ()<UISearchBarDelegate, BATableViewDelegate,PulldownMenuDelegate>

@end

@implementation SecondOrganizationalVC{
    UISearchBar * _searchBar;
    // 初始时表单
    BATableView *_originTableView;
    
    //全体员工的数据
    NSMutableArray *allArray;
    
    //用于刷新界面的数据
    NSMutableArray *dataArray;
    
    UILabel *_titleLabel;
    UIView *_popUpView;
    
    
     PulldownMenu *pulldownMenu;
   
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createNavTitleView];
     [self createSearchBar];
    [self createOriginTableView];
    [self addBackButton];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [pulldownMenu shouqiMenu];
    
}
/**
 *  获得数据
 */
- (void)createNavTitleView{

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, 100, 44)];
    _titleLabel.text = [NSString stringWithFormat:@"%@^", NSLocalizedString(@"allStaff", @"allStaff")];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView = _titleLabel;

    pulldownMenu = [[PulldownMenu alloc] initWithNavigationController:self.navigationController andTitleLabel:_titleLabel];
    [self.navigationController.view insertSubview:pulldownMenu belowSubview:self.navigationController.navigationBar];
    
    [pulldownMenu insertButton:[NSString stringWithFormat:@"%@^", NSLocalizedString(@"allStaff", @"allStaff")]];
    [pulldownMenu insertButton:[NSString stringWithFormat:@"%@^", NSLocalizedString(@"sortByAge", @"sortByAge")]];
    [pulldownMenu insertButton:[NSString stringWithFormat:@"%@^", NSLocalizedString(@"sortByApartment", @"sortByApartment")]];
    
    pulldownMenu.delegate = self;
    
    [pulldownMenu loadMenu];

 
    
    
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
    [self showHintInView:self.view];
    OrganizationBll *organizationBll = [[OrganizationBll alloc]init];
    [organizationBll getSecondOrgnizationData:^(NSArray *arr) {
    [self hideHud];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allArray addObject:obj];
        }];
      dataArray = [NSMutableArray arrayWithArray:allArray];
     [_originTableView reloadData];
    } viewCtrl:self];
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
    _originTableView = [[BATableView alloc]initWithFrame:CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-49)];
    _originTableView.delegate = self;
     _originTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _originTableView.backgroundColor = COMMON_BACK_COLOR;
    [self.view addSubview:_originTableView];
        // 通过手势收起 searchBar 弹出的键盘
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [_originTableView addGestureRecognizer:tapGesture];
    [self initData];
    
    
//    [self createSuoYinView];
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
        StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (cell == nil) {
            cell = [[StaffTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier andType:1];
        }
        StaffModel *model;
        model = dataArray[indexPath.section][indexPath.row];
        [cell.stateBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        cell.callPhoneBlock = ^(){
            [self openCall:model.phoneNumber];
        };
        cell.nameLabel.text = model.staffName;
        cell.phoneNumLabel.text = model.phoneNumber;
        cell.backgroundColor = COMMON_BACK_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.iconImgView sd_setImageWithURL:(NSURL *)model.avatar placeholderImage:[UIImage imageNamed:@"headerImg_default"]];
        
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
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [pulldownMenu shouqiMenu];
   
    OrganizationalChildViewController *OrganizationalChild = [[OrganizationalChildViewController alloc]init];
        OrganizationalChild.staffModel = dataArray[indexPath.section][indexPath.row];
  
    [self.navigationController pushViewController:OrganizationalChild animated:YES];
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


//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//        _searchBar.showsCancelButton = YES;
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
// 
//  
//}
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [_searchBar resignFirstResponder];
//    _searchBar.text = @"";
//    _searchBar.showsCancelButton = NO;
//    [dataArray removeAllObjects];
//    for (StaffModel *model in allArray) {
//        [dataArray addObject:model];
//    }
//    [_originTableView reloadData];
//
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
////    _searchBar.showsCancelButton = NO;
//}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if ([_searchBar.text isEqualToString:@""] ) {
//        [dataArray removeAllObjects];
//        dataArray = [NSMutableArray arrayWithArray:allArray];
////        for (StaffModel *model in allArray) {
////            [dataArray addObject:model];
////        }
//       
//    }else{
//        [dataArray removeAllObjects];
//        for (int i = 0; i < 27; i++) {
//            NSMutableArray *wordArray = [NSMutableArray array];
//            for (StaffModel *model in allArray[i]) {
//               
//                if ([model.staffName rangeOfString:_searchBar.text].location != NSNotFound||[model.phoneNumber rangeOfString:_searchBar.text].location != NSNotFound) {
//                    [wordArray addObject:model];
//                    //搜索结果后需要刷新一下
//                }
//            }
//            [dataArray addObject:wordArray];
//        }
//        
//        
//       
//    }
//    [_originTableView reloadData];     
//    
//}
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
////    NSLog(@"22");
//}

    
#pragma mark - 手势收起键盘
-(void)dismissKeyBoard{
    [_searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
