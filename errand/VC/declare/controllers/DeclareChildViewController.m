//
//  DeclareChildViewController.m
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DeclareChildViewController.h"
#import "DeclareBll.h"
#import "TaskTableViewCell.h"
#import "DeclareDetailViewController.h"
@interface DeclareChildViewController ()<SRRefreshDelegate ,UITableViewDataSource,UITableViewDelegate>{
    float navHeight;
    NSMutableArray *dataArray;
    int pageIndex;
    BOOL isSearch;
    NSArray *_searchArray;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;


@end

@implementation DeclareChildViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_model) {
        [dataArray insertObject:_model atIndex:0];
        [_tableView reloadData];
        _model = nil;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSearchData:) name:@"sendSearchArray" object:nil];
    // Do any additional setup after loading the view.
}
- (void)getSearchData:(NSNotification*)notification{
    
    NSArray *infoArray = notification.object;
    
    NSMutableDictionary *saveDic = [infoArray lastObject];
    if ([saveDic[@"type"] integerValue] == _type) {
        _saveDic = saveDic;
        
        _searchArray = infoArray;
        pageIndex = 0;
        isSearch = YES;
        [self initData];
    }
    
    
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
    DeclareBll *declareBll = [[DeclareBll alloc]init];
    if (isSearch == NO) {
        [declareBll getAllDeclareData:^(NSArray *arr) {
            if(pageIndex==1){
                
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } type:_type pageIndex:pageIndex  viewCtrl:self];
   
    }else{
//        ^(NSString *title,NSString *2customerName,NSString *3useWay,NSString *4aim,NSString *5remark,NSString *6statusStr,NSNumber* 7status,NSNumber *8productID,NSNumber *9hospitalID,NSNumber *10doctorID){
        [declareBll getSearchDeclareData:^(NSArray *arr) {
            if(pageIndex==1){
                
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } type:_type pageIndex:pageIndex name:_searchArray[0] Hospital:_searchArray[8] doctor:_searchArray[9] production:_searchArray[7] description:_searchArray[2] goal:_searchArray[3] remark:_searchArray[4] status:_searchArray[6]  viewCtrl:self];
    }
    
}
-(void)initView{
    dataArray=[[NSMutableArray alloc] init];
    _searchArray = [NSMutableArray array];
    navHeight=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    float bottomHeight=SEG_HEIGHT;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-bottomHeight)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self createMJ];
    [self createSlime];
    [self initData];
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
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"cell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    DeclareModel *model=dataArray[indexPath.row];
 
    [cell setDeclareModel:model type:_type];
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeclareDetailViewController *declareDetail = [[DeclareDetailViewController alloc]init];
    DeclareModel *model=dataArray[indexPath.row];
    declareDetail.declareID = model.declareID;
    declareDetail.type = _type;
    declareDetail.status = [model.currentStatus intValue];
    declareDetail.indexPath = indexPath;
    
    [self.navigationController pushViewController:declareDetail animated:YES];
    declareDetail.changeDeclareStatusBlock = ^(NSIndexPath *changeIndexPath , NSNumber *status, NSString *moneyStr){
        DeclareModel *model = dataArray[changeIndexPath.row];
        model.currentStatus = status;
        if (![moneyStr isEqualToString:@""]) {
            model.moneyString = moneyStr;
        }
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:changeIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    [declareDetail setEditFinishRefreshCB:^{
        pageIndex=1;
        [self initData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
-(void)createMJ{
    __block  DeclareChildViewController *myself = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [myself initData];
    }];
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
