//
//  CompetitionVC.m
//  errand
//
//  Created by gravel on 16/2/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CompetitionVC.h"
#import "DeclareBll.h"
#import "ProductionModel.h"
#import "CommonBll.h"
#import "ContactViewController.h"
#import "ProductionsTableViewCell.h"
#import "BATableView.h"
#import "pinyin.h"

@interface CompetitionVC ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate, BATableViewDelegate, UISearchBarDelegate>

@end

@implementation CompetitionVC{
    NSMutableArray *dataArray;
    BATableView *_tableView;
    UISearchBar *_searchBar;
    int pageIndex;
    NSMutableArray *_showArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"ChooseProduct", @"ChooseProduct");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self initView];
    [self createSearchBar];
    // Do any additional setup after loading the view.
}


-(void)initView{
    
    [self createSearchBar];
    
    dataArray=[[NSMutableArray alloc] init];
    _tableView=[[BATableView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.separatorStyle = 0;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets =NO;
//    [self setExtraCellLineHidden:_tableView];
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

- (void)initData{
    
    CommonBll *commonBll = [[CommonBll alloc]init];
    [commonBll  getCompetitionProductionData:^(NSArray *arr) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataArray addObject:obj];
        }];
        
        [self configRightIndex];
        
        [_tableView reloadData];
        [self hideHud];

    } viewCtrl:self];
  
}
- (void)configRightIndex
{
    _showArray = [NSMutableArray array];
    [self sortCharactorWithSourceArray:(NSMutableArray *)dataArray returnArray:_showArray];
    
    [_tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _showArray.count;
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

#pragma mark -  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_showArray[section] count] == 0) {
        return 1;
    }else {
        return [_showArray[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ([_showArray[section] count] == 0 ? 0: 30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ProductionsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if ([_showArray[indexPath.section] count] != 0) {
        ProductionModel *model = _showArray[indexPath.section][indexPath.row];
        [cell fillData:model];
    }else {
        [cell hideAllView:YES];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section + 65 > 90) {
        return @"    #";
    }else {
        return [NSString stringWithFormat:@"    %c", (int)section + 65];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        ProductionModel *model = _showArray[indexPath.section][indexPath.row];
        self.feedBackProductionModelBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
 
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
