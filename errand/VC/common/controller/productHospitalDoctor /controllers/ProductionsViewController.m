//
//  ProductionsViewController.m
//  errand
//
//  Created by gravel on 16/1/19.
//  Copyright © 2016年 weishi. All rights reserved.
//
#import "ProductionsViewController.h"
#import "DeclareBll.h"
#import "ProductionModel.h"
#import "CommonBll.h"
#import "ContactViewController.h"
#import "ContactsViewController.h"
#import "ContactssViewController.h"

#import "ProductionsTableViewCell.h"
#import "BATableView.h"
#import "pinyin.h"

@interface ProductionsViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate, BATableViewDelegate, UISearchBarDelegate>

@end

@implementation ProductionsViewController{
    NSMutableArray *dataArray;
    BATableView *_tableView;
    SRRefreshView *_slimeView;
    int pageIndex;
    UISearchBar *_searchBar;
    
    NSMutableArray *_showArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"ChooseProduct", @"ChooseProduct");
    _showArray = [NSMutableArray array];
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initView{
    [self createSearchBar];
    
    dataArray=[[NSMutableArray alloc] init];
    _tableView=[[BATableView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
//    _tableView.dataSource=self;
    self.view.backgroundColor=GDBColorRGB(0.94, 0.94, 0.96, 1);
    _tableView.backgroundColor=GDBColorRGB(0.94, 0.94, 0.96, 1);
//    _tableView.tableView.separatorStyle = 0;
    
    self.automaticallyAdjustsScrollViewInsets =NO;
//    [self setExtraCellLineHidden:_tableView];
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self createMJ];
    [self createSlime];
    [self initData];
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

- (void)sortCharactorWithSourceArray:(NSMutableArray *)sourceArray returnArray:(NSMutableArray *)returnArray
{
    //按字母顺序分组
    
    for (int i=0; i<26; i++) {
        NSMutableArray *itemArray = [NSMutableArray array];
        
        for (int j=0; j<sourceArray.count; j++) {
            ProductionModel *model = sourceArray[j];
            char firstCharactor = pinyinFirstLetter([model.name characterAtIndex:0]);
            if (firstCharactor == 97 + i) {
                [itemArray addObject:model];
            }
        }
        [returnArray addObject:itemArray];
        
    }
    
    NSMutableArray *extraArray = [NSMutableArray arrayWithArray:sourceArray];
    for (int i=0; i<sourceArray.count; i++) {
        ProductionModel *model = sourceArray[i];
        
        for (int j=0; j<26; j++) {
            char firstCharactor = pinyinFirstLetter([model.name characterAtIndex:0]);
            if (firstCharactor == 97 + j) {
                [extraArray removeObject:model];
                break;
            }
        }
    }
    
    if (extraArray.count != 0) {
        [returnArray addObject:extraArray];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [_showArray removeAllObjects];
        [self sortCharactorWithSourceArray:(NSMutableArray *)dataArray returnArray:_showArray];
        
    }else {
        [_showArray removeAllObjects];
        [self sortCharactorWithSourceArray:(NSMutableArray *)dataArray returnArray:_showArray];
        
        for (NSInteger i=0; i<_showArray.count; i++) {
            NSMutableArray *array = _showArray[i];
            for (NSInteger j=array.count-1; j>=0; j--) {
                ProductionModel *model = array[j];
                NSRange range = [model.name rangeOfString:searchText];
                if (range.location == NSNotFound) {
                    [array removeObject:model];
                }
            }
        }
        
    }
    
    [_tableView reloadData];
}

- (void)generalGetRequest:(NSString *)url infoDic:(NSDictionary *)infoDic resultCB:(void(^)(id responseObject))resultCB errorCB:(void(^)(NSError *error))errorCB
{
    
    NSDictionary *dic = [Function getParametersDic:infoDic];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [Function configRequestHeader:manager];
    
    [manager GET:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        resultCB(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [Function maybeShowLoginCtrlWith:error];
        NSLog(@"%@",error);
        errorCB(error);
        
    }];
}

- (void)initData{
    
    if (_allProduct) {
        [self showHintInView:self.view];
        NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/productions"];
        [self generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
            for (NSDictionary *dic in responseObject) {
//                NSLog(@"%@", responseObject);
                ProductionModel *model = [[ProductionModel alloc]initWithDic:dic];
                [dataArray addObject:model];
            }
            
            if (dataArray.count == 0) {
                [Dialog simpleToast:@"没有数据"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self configRightIndex];
            
            [_tableView reloadData];
            
            [self hideHud];
        } errorCB:^(NSError *error) {
            [self hideHud];
        }];
        return;
    }
    
    if(!pageIndex){
        [self showHintInView:self.view];
        pageIndex=1;
    }else if(pageIndex==1){
        [self showInfica];
    }else{
        [self showInfica];
    }
  
    CommonBll *commonBll = [[CommonBll alloc]init];
    [commonBll getProductionsData:^(NSArray *arr){
        if(pageIndex==1)
        {
            [dataArray removeAllObjects];
        }
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataArray addObject:obj];
        }];
        
        if (dataArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [self configRightIndex];
        
        [_tableView reloadData];
        [self hideHud];
        [_slimeView endRefresh];
//        [_tableView footerEndRefreshing];
    } viewCtrl:self];
}

- (void)configRightIndex
{
    _showArray = [NSMutableArray array];
    [self sortCharactorWithSourceArray:(NSMutableArray *)dataArray returnArray:_showArray];
    
    [_tableView reloadData];
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
    
//    [_tableView addSubview:_slimeView];
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
- (NSArray *)sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    
    NSMutableArray *indexTitle = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        [indexTitle addObject:[NSString stringWithFormat:@"%c", i + 65]];
    }
    [indexTitle addObject:@"#"];
    return indexTitle;
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_showArray[section] count] == 0) {
        return 1;
    }else {
        return [_showArray[section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ([_showArray[section] count] == 0 ? 0: 30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ProductionsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    if ([_showArray[indexPath.section] count] != 0) {
        ProductionModel *model = _showArray[indexPath.section][indexPath.row];
        [cell fillData:model];
    }else {
        [cell hideAllView:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_showArray[indexPath.section] count] == 0) {
        return 0;
    }else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return kFrameH(cell);
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section + 65 > 90) {
        return @"    #";
    }else {
        return [NSString stringWithFormat:@"    %c", (int)section + 65];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //0 直接返回  1 跳到医院界面 返回  2 跳到医院界面 然后调到医生界面 返回  3 跳到医院界面 可以打勾 也可以跳到医生
    if (_type == 1) {
        ContactssViewController *contactVC = [[ContactssViewController alloc]init];
        contactVC.type = 3;
        contactVC.productModel = _showArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:contactVC animated:YES];
    }else if (_type == 2){
        ContactssViewController *contactVC = [[ContactssViewController alloc]init];
        contactVC.type = 4;
        contactVC.productModel = _showArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:contactVC animated:YES];
    }else if (_type == 3){
        ContactssViewController *contactVC = [[ContactssViewController alloc]init];
        contactVC.type = 6;
        contactVC.allProduct = _allProduct;
        contactVC.popIndex = _popIndex;
        contactVC.productModel = _showArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    else{
        ProductionModel *model = _showArray[indexPath.section][indexPath.row];
        self.feedBackProductionModelBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
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
-(void)createMJ{
    __block  ProductionsViewController *productVC = self;
//    [_tableView addFooterWithCallback:^{
//        pageIndex=pageIndex + 1;
//        [productVC initData];
//    }];
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
