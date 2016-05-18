//
//  MissionChildViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionChildViewController.h"
#import "MissionListTableViewCell.h"

#import "MissionBll.h"
#import "MissionDetailViewController.h"
@interface MissionChildViewController ()<SRRefreshDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;
@end

@implementation MissionChildViewController{
    float navHeight;
    NSMutableArray *dataArray;
    int pageIndex;
    BOOL isSearch;
}

@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_model) {
        [dataArray insertObject:_model atIndex:0];
        [_tableView reloadData];
        _model = nil;
    }
    
    if (_searchArray.count > 0) {
        pageIndex = 0;
        isSearch = YES;
        [self initData];
    }
    
    if (_editModel) {
        
        [dataArray replaceObjectAtIndex:_editIndexPath.row withObject:_editModel];
        [_tableView reloadData];
//        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_editIndexPath.row inSection:_editIndexPath.section], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        _editModel = nil;
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
    MissionBll *missBLL = [[MissionBll alloc]init];
    if (isSearch == 0) {
        [missBLL getAllMissionData:^(NSArray *arr) {
            if(pageIndex==1)
            {
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } type:type pageIndex:pageIndex viewCtrl:self];
    }else{
//        NSString *start,NSString *dest,NSString *content,NSString *startDate,NSString *endDate,NSNumber * traveType,NSNumber* status, NSString *traveTypeStr,NSString *statusStr
        [missBLL getSearchMissionData:^(NSArray *arr) {
            if(pageIndex==1)
            {
                [dataArray removeAllObjects];
            }
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dataArray addObject:obj];
            }];
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
            
        } type:type pageIndex:pageIndex start:_searchArray[0] dest:_searchArray[1] content:_searchArray[2] startDate:_searchArray[3] endDate:_searchArray[4] travelMode:_searchArray[5] status:_searchArray[6] viewCtrl:self];
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
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    MissionListTableViewCell *cell=[[MissionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"myCell"];
    [_tableView addSubview:cell];
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
    static NSString *CellTableIdentifier = @"myCell";
    MissionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
         cell = [[[NSBundle mainBundle]loadNibNamed:@"MissionListTableViewCell" owner:self options:nil]lastObject];
    }
    MissionModel *model=dataArray[indexPath.row];
    
    [cell fillModel:model type:type];
//    cell.model=model;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MissionDetailViewController *missionDetail = [[MissionDetailViewController alloc]init];
    MissionModel *model = dataArray[indexPath.row];
    missionDetail.missionID = model.missionID;
    missionDetail.indexPath = indexPath;
    [self.navigationController pushViewController:missionDetail animated:YES];
    
    //改变状态成功
    missionDetail.changeMissionStatusBlock = ^(NSIndexPath *changeIndexPath , int  status, MissionModel *missionModel){
        [dataArray replaceObjectAtIndex:changeIndexPath.row withObject:missionModel];
        MissionModel *model = dataArray[changeIndexPath.row];
        model.status = status ;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"numReduce" object:nil];
        [_tableView reloadData];
//        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:changeIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];

    };
    
    missionDetail.deleteMissionDataBlock = ^(NSIndexPath *deleteIndexPath){
        [dataArray removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    };
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
    __block  MissionChildViewController *missionVC = self;
    [_tableView addFooterWithCallback:^{
         pageIndex=pageIndex + 1;
        [missionVC initData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"editMissionData" object:nil];
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
