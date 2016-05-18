//
//  MyRecordViewController.m
//  errand
//
//  Created by gravel on 15/12/29.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "RecordViewController.h"
#import "AttendanceTableViewCell.h"
#import "AttendanceBll.h"
#import "MyRecordModel.h"
#import "StaffRecordModel.h"
#import "SearchView.h"
#import "MySearchRecordViewController.h"
#import "GeneralTopDateChangeView.h"
#import "CheckWorkFunction.h"

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>

@end

@implementation RecordViewController{
//    UITableView *_tableView;
//    SRRefreshView *_slimeView;
//    NSMutableArray *_dataArray;
    
    // 搜索结果数据源
    NSMutableArray *_searchDataArray;
    // 搜索tableview
    UITableView *_searchTableView;
    
    int pageIndex;
    //0 搜索视图收起  1 搜索视图出现
    int seclectedFlag;
    NSString *_searchStarDate;
    NSString *_searchEndDate;
    NSString * _searchStaffStr;
    
    UIView * _bgView;
    SearchView *_searchView;
    BOOL _ISSearch;
    
    GeneralTopDateChangeView *_dateChangeView;
    int _dayIndex;
}
@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (type == 0) {
        self.title = NSLocalizedString(@"MyRecord",@"MyRecord");
    }else{
        self.title = NSLocalizedString(@"StaffRecord",@"StaffRecord");
    }
    self.view.backgroundColor = COMMON_BACK_COLOR;
    _dayIndex = 0;
      _ISSearch = NO;
    [self createView];
  
    // Do any additional setup after loading the view.
}
- (void)createRightItem{
    seclectedFlag = 0;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)RecordsearchClick{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.2;
        _bgView.tag = 100;
        [self.view addSubview:_bgView];
    }
    if (_searchView == nil) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, 250) andWithType:type];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.alpha = 1;
        _searchView.tag = 101;
        [self.view addSubview:_searchView];
    }
    if (seclectedFlag == 0) {
        _bgView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [UIView animateWithDuration:0.3 animations:^{
            
            _searchView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 250);
        }];
        seclectedFlag = 1;
    }else{
        _bgView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [UIView animateWithDuration:0.3 animations:^{
            
            _searchView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        }];
        seclectedFlag = 0;
    }
//
//    //根据搜索条件 刷新数据源
//
    __block UIView *myBgView = _bgView;
    __block SearchView *mySearchView = _searchView;
    __block RecordViewController *myself = self;
    __block UITableView *myTableView = _tableView;
    
    _searchView.recordBlock = ^(NSString * startDate ,NSString* endDate, NSString *staffStr,BOOL ISSearch){
        myBgView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [UIView animateWithDuration:0.3 animations:^{
            
            mySearchView.frame = CGRectMake(-SCREEN_WIDTH, 64-SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        }];
        seclectedFlag = 0;
         pageIndex = 0;
        _searchEndDate = endDate;
        _searchStarDate = startDate;
        _searchStaffStr = staffStr;
//        _ISSearch = ISSearch;
        [myself showSearchMyRecord];
//        _dataArray = [NSMutableArray array];
//        [myTableView reloadData];
//        [myself initData];
    };

}

- (void)createView{
    [self addBackButton];
    [self createRightItem];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets =NO;
    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:_tableView];
    [self createSlime];
//    [self createMJ];
    [self createDateChangeView];
    [self initData];
    
}

- (void)createDateChangeView
{
    _dateChangeView = [[GeneralTopDateChangeView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    _dateChangeView.todayButton.hidden = YES;
    [self.view addSubview:_dateChangeView];
    
    _tableView.frame = CGRectMake(10, 64+60, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64-60);
    
    
    [_dateChangeView buttonClickAction:^(NSInteger theTyep) {
        
        if (theTyep == -1) {
            _dayIndex = _dayIndex - 1;
        }else if (theTyep == 1) {
            _dayIndex = _dayIndex + 1;
        }else {
            _dayIndex = 0;
        }
        
        if (_dayIndex == 0) {
            _dateChangeView.todayButton.hidden = YES;
        }else {
            _dateChangeView.todayButton.hidden = NO;
        }
        
        [self initData];
    }];
}

- (NSString *)getStartDate
{
    NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
    NSString *startDate = [CheckWorkFunction stringFromDate:date isStart:YES];
    return startDate;
}

- (NSString *)getEndDate
{
    NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
    NSString *endDate = [CheckWorkFunction stringFromDate:date isStart:NO];
    return endDate;
}

- (void)initData{
    
    NSString *startDate = [self getStartDate];
    NSString *endDate = [self getEndDate];
    
    _dateChangeView.titleLabel.text = [Function dateChangeTitle:_dayIndex dateStr:startDate];
   
    if (_ISSearch == NO) {
        [self showHintInView:self.view];
        
         AttendanceBll *attendanBll = [[AttendanceBll alloc]init];
        [attendanBll getRecordData:^(NSArray *array) {
            
            [_dataArray removeAllObjects];
            
            MyRecordModel *modelOne = [[_dataArray lastObject] lastObject];
            MyRecordModel *modelTwo = [[array firstObject] firstObject];
            
            if ([modelTwo.flagTimeStr isEqualToString:modelOne.flagTimeStr]) {
                
                NSMutableArray *itemArray = [NSMutableArray arrayWithArray:[_dataArray lastObject]];
                [itemArray addObjectsFromArray:[array firstObject]];
                [_dataArray removeLastObject];
                
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
                [tempArray removeObjectAtIndex:0];
                
                [_dataArray addObject:itemArray];
                [_dataArray addObjectsFromArray:tempArray];
                
            } else {
                
                [_dataArray addObjectsFromArray:array];
            }
            
            [_tableView reloadData];
            [self hideHud];
            [_slimeView endRefresh];
            [_tableView footerEndRefreshing];
        } type:type pageIndex:pageIndex startDate:startDate endDate:endDate viewCtrl:self];
 
    }
    if (_ISSearch == YES) {
//        [self showSearchMyRecord];
    }
  
}

- (void)showSearchMyRecord
{
    MySearchRecordViewController *mySearchRecordVC = [[MySearchRecordViewController alloc]init];
    mySearchRecordVC.passStartDate = _searchStarDate;
    mySearchRecordVC.passEndDate = _searchEndDate;
    mySearchRecordVC.type = 0;
    [self.navigationController pushViewController:mySearchRecordVC animated:YES];
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
//            [_tableView addSubview:_slimeView];
        });
    });
    
}

#pragma mark--- UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyAdapter aDapterView:60];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"tableview  %lu",(unsigned long)_dataArray.count);
    return [_dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AttendanceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (type == 0) {
        MyRecordModel *model = _dataArray[indexPath.section][indexPath.row];
        [cell setAttendanceModel:model];
    }else{
        StaffRecordModel *model =_dataArray[indexPath.section][indexPath.row];
        [cell setStaffRecordModel:model];
    }
    
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//        return [MyAdapter aDapterView:40];
    return 0.01;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    /*
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, [MyAdapter aDapterView:40])];
    label.backgroundColor = COMMON_BACK_COLOR;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[[_dataArray[section] lastObject] flagTimeStr]];
   NSString *weekStr = [self weekdayStringFromDate:date];
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter  alloc]init];
//    [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
//    NSString *dateStr = [dateFormatter1 stringFromDate:date];
    
    label.text = [NSString stringWithFormat:@"%@%@%@",[[_dataArray[section] lastObject] flagTimeStr],@"  ",weekStr];
//    label.text = [[_dataArray[section] lastObject] flagTimeStr];
    label.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:17]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COMMON_FONT_BLACK_COLOR;
    return label;
     */
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

#pragma mark 上拉加载
-(void)createMJ{
    __block RecordViewController *recordVC =self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [recordVC initData];
    }];
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
