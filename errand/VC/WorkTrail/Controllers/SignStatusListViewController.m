//
//  SignStatusListViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SignStatusListViewController.h"
#import "BATableView.h"
#import "WorkTrailFunction.h"
#import "SignStatusTableViewCell.h"

@interface SignStatusListViewController ()<BATableViewDelegate, UISearchBarDelegate>
{
    BATableView *_baTableView;
    UISearchBar *_searchBar;
    NSMutableArray *_showArray;
    
}
@end

@implementation SignStatusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _status;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self addBackButton];
    
    [self dataConfig];
    [self uiConfig];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [_showArray removeAllObjects];
        [WorkTrailFunction sortCharactorWithSourceArray:(NSMutableArray *)_dataArray returnArray:_showArray keyStr:@"userName"];
        
    }else {
        [_showArray removeAllObjects];
        [WorkTrailFunction sortCharactorWithSourceArray:(NSMutableArray *)_dataArray returnArray:_showArray keyStr:@"userName"];
        
        for (NSInteger i=0; i<_showArray.count; i++) {
            NSMutableArray *array = _showArray[i];
            for (NSInteger j=array.count-1; j>=0; j--) {
                NSDictionary *dic = array[j];
                NSRange range = [dic[@"userName"] rangeOfString:searchText];
                if (range.location == NSNotFound) {
                    [array removeObject:dic];
                }
            }
        }
        
    }
    
    [_baTableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (void)dataConfig
{
    _showArray = [NSMutableArray array];
    [WorkTrailFunction sortCharactorWithSourceArray:(NSMutableArray *)_dataArray returnArray:_showArray keyStr:@"userName"];
    
    [_baTableView reloadData];
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
- (void)uiConfig
{
    [self createSearchBar];
    
    _baTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 64+50, kWidth, kHeight-64-50)];
    _baTableView.delegate = self;
    [self.view addSubview:_baTableView];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_showArray[indexPath.section] count] == 0) {
        return 0;
    }else {
        return 64;
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section + 65 > 90) {
        return @"    #";
    }else {
        return [NSString stringWithFormat:@"    %c", (int)section + 65];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    SignStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SignStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    if ([_showArray[indexPath.section] count] != 0) {
        [cell fillData:_showArray[indexPath.section][indexPath.row]];
    }else {
        [cell hideAllView:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
