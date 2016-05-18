//
//  TaskAssignedViewChildViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskAssignedChildViewController.h"
#import "TaskTableViewCell.h"
#import "TaskBll.h"
#import "TaskDetailViewController.h"
@interface TaskAssignedChildViewController ()<SRRefreshDelegate ,UITableViewDataSource,UITableViewDelegate>@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;

@end

@implementation TaskAssignedChildViewController{
    float navHeight;
    NSMutableArray *dataArray;
    int pageIndex;
    BOOL isSearch;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_model) {
        [dataArray insertObject:_model atIndex:0];
        [_tableView reloadData];
        _model = nil;
    }
//    if (_searchArray) {
//        pageIndex = 0;
//         isSearch = YES;
//        [self initData];
//    }
    if (_models) {
        for (TaskModel *model in _models) {
            [dataArray insertObject:model atIndex:0];
        }
        
        [_tableView reloadData];
        _models = nil;
    }
}

- (void)searchAction
{
    if (_searchArray) {
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
    
    TaskBll *taskBll = [[TaskBll alloc]init];

    if (isSearch == 0) {
            [taskBll getAllTaskData:^(NSArray *arr) {
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
        } type:_type pageIndex:pageIndex viewCtrl:self];
    }else{
        [taskBll getTaskSearchData:^(NSArray *arr) {
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
        } type:_type pageIndex:pageIndex title:_searchArray[4] content:_searchArray[3] category:_searchArray[0]  beingDate:_searchArray[1] endDate:_searchArray[2] to:_searchArray[5] viewCtrl:self];
    }
   
    
}
-(void)initView{
    dataArray=[[NSMutableArray alloc] init];
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
    [self createSlime];
    [self initData];
    [self createMJ];
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
    TaskModel *model=dataArray[indexPath.row];
    cell.callPhoneBlock = ^(){
        [self openCall:model.phoneNumber];
    };
    [cell setModel:model category:_type];
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetailViewController *taskDetail = [[TaskDetailViewController alloc]init];
    TaskModel *model=dataArray[indexPath.row];
    taskDetail.taskID = model.taskID;
    taskDetail.type = _type;
    taskDetail.indexPath = indexPath;
    taskDetail.changeStatusBlock = ^(NSIndexPath *changeIndexPath , NSString *status){
        TaskModel *model = dataArray[changeIndexPath.row];
        model.stauts = status;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:changeIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:taskDetail animated:YES];
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
    __block  TaskAssignedChildViewController *myself = self;
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
