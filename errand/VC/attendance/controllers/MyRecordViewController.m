//
//  MyRecordViewController.m
//  errand
//
//  Created by gravel on 15/12/29.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MyRecordViewController.h"
#import "AttendanceTableViewCell.h"
#import "AttendanceBll.h"
#import "MyRecordModel.h"
#import "StaffRecordModel.h"
@interface MyRecordViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@end

@implementation MyRecordViewController{
    UITableView *_tableView;
    SRRefreshView *_slimeView;
    NSMutableArray *_dataArray;
    int pageIndex;
}
@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (type == 0) {
        self.title = NSLocalizedString(@"MyRecord",@"MyRecord");
    }else{
        self.title = NSLocalizedString(@"StaffRecord",@"StaffRecord");
    }
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_dataArray.count-PageToBottomLoad)
    {
        pageIndex++;
        [self initData];
    }
}
- (void)createRightItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)searchClick{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.2;
    [self.view addSubview:view];
}
- (void)createView{
    [self addBackButton];
    [self createRightItem];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets =NO;
    _dataArray=[[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:_tableView];
    [self createSlime];
    [self initData];
}
- (void)initData{
    if (pageIndex == 0 ) {
        [self showHintInView:self.view];
        pageIndex = 1;
    }else if (pageIndex == 1){
        [self showInfica];
    }else{
        [self showInfica];
    }
    [AttendanceBll getAllAttendanceData:^(NSArray *arr) {
        if (pageIndex == 1) {
            [_dataArray removeAllObjects];
        }
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        [_tableView reloadData];
        
        [self hideHud];
        [_slimeView endRefresh];
    } pageIndex:pageIndex];
}

-(void)createSlime{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset =0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView addSubview:_slimeView];
        });
    });
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyAdapter aDapterView:60];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AttendanceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (type == 0) {
        MyRecordModel *model = _dataArray[indexPath.row];
        [cell setAttendanceModel:model];
    }else{
        StaffRecordModel *model =_dataArray[indexPath.row];
        [cell setStaffRecordModel:model];
    }
    
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return [MyAdapter aDapterView:26];
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, [MyAdapter aDapterView:26])];
    label.backgroundColor = COMMON_BACK_COLOR;
    label.text = @"2015.11.21";
    label.font = [UIFont systemFontOfSize:[MyAdapter aDapterView:12]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COMMON_FONT_BLACK_COLOR;
    return label;
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

//start refresh.
- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView{
    pageIndex=1;
    [self initData];
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
