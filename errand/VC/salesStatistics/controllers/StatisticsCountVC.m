//
//  StatisticsCountVC.m
//  errand
//
//  Created by gravel on 16/2/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "StatisticsCountVC.h"
#import "SalesStatisticsBll.h"
#import "CountView.h"
#import "CountTableViewCell.h"
#import "StatisticsCountModel.h"
#import "SalesStatisticsChildViewController.h"
@interface StatisticsCountVC ()<CountViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *_beginDate;
    NSString *_endDate;
}

@end

@implementation StatisticsCountVC{
   CountView * _topBgView;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UIView *_headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self addBackButton];
    [self initView];
    [self createTopView];
    // Do any additional setup after loading the view.
}

-(void)initView{
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(5, 64 + 49, SCREEN_WIDTH - 10, SCREEN_HEIGHT-64-49)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets =NO;
    [self creaetHeaderView];
    [self initData];
}

- (void)initData{
    [self showHintInView:self.view];
    _dataArray = [NSMutableArray array];
    //获取到今天的时间
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSString *beginAndEndStr =[self getMonthBeginAndEndWith:[dateFormatter stringFromDate:todayDate]];
    NSString *beginDate = [beginAndEndStr substringToIndex:10];
    NSString *endDate = [beginAndEndStr substringFromIndex:11];
    _beginDate = beginDate;
    _endDate = endDate;

    SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
    [salesBll getSalesCountData:^(NSArray *arr) {
       [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           [_dataArray addObject:obj];
       }];
        if (_dataArray.count == 0) {
            [Dialog simpleToast:@"没有数据"];
        }else{
            _tableView.tableHeaderView = _headerView;
        }
        [_tableView reloadData];
        [self hideHud];
    } category:_type beginDate:beginDate endDate:endDate viewCtrl:self];
}

- (void)creaetHeaderView{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -10 , 44)];
    _headerView.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
    
    float pillWidth = (SCREEN_WIDTH - 10)/3;
    
    UILabel *pillLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pillWidth, 44)];
    pillLabel.text = @"药品";
    pillLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:pillLabel];
  

    UILabel *hospitalLabel = [[UILabel alloc]initWithFrame:CGRectMake(pillWidth, 0, pillWidth, 44)];
    hospitalLabel.text = @"医院";
    hospitalLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:hospitalLabel];

    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(pillWidth*2, 0, pillWidth, 44)];
    countLabel.text = @"数量";
    countLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:countLabel];
  
}
//按月来查询
- (void)createTopView{
    
    //如果创建过 就不新建
    if (_topBgView == nil) {
        _topBgView = [[CountView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 49)  type:0];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        _topBgView.backgroundColor = [UIColor whiteColor];
        _topBgView.delegate = self;
        [self.view addSubview:_topBgView];
        
    }
    
}

#pragma mark -----  UITableViewDataSource  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    StatisticsCountModel *model = _dataArray[indexPath.row];
    
    // 奇数行 灰色  偶数行 白色
    if (indexPath.row % 2 ) {
         [cell setStatisticsCountModel:model andColor:COMMON_BACK_COLOR type:_type];
    }else{
        [cell setStatisticsCountModel:model andColor:[UIColor whiteColor] type:_type];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SalesStatisticsChildViewController *childController = [[SalesStatisticsChildViewController alloc]init];
    StatisticsCountModel *model = _dataArray[indexPath.row];
    childController.statisticsCountModel = model;
    childController.beginDate = _beginDate;
    childController.endDate = _endDate;
    childController.type = _type;
    if (_type == 0) {
        childController.title  = NSLocalizedString(@"salesReport", @"salesReport");
    }else if (_type == 1){
        childController.title  = NSLocalizedString(@"pureSalesReport", @"pureSalesReport");
    }else{
        childController.title  = NSLocalizedString(@"competeReport", @"competeReport");
    }
    [self.navigationController pushViewController:childController animated:YES];
    
}
#pragma mark --- CountViewDelegate

- (void)buttonClickWithMonth:(NSString *)month{
    
    [_dataArray removeAllObjects];
    [self showHintInView:self.view];
    NSString *beginAndEndStr = [self getMonthBeginAndEndWith:month];
    NSString *beginDate = [beginAndEndStr substringToIndex:10];
    NSString *endDate = [beginAndEndStr substringFromIndex:11];
    _beginDate = beginDate;
    _endDate = endDate;
    
    SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
    [salesBll getSalesCountData:^(NSArray *arr) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        if (_dataArray.count == 0) {
            _tableView.tableHeaderView = [[UIView alloc]init];
            [Dialog simpleToast:@"没有数据"];
        }else{
            _tableView.tableHeaderView = _headerView;
        }
        [_tableView reloadData];
        [self hideHud];
    } category:_type beginDate:beginDate endDate:endDate viewCtrl:self]                                                  ;

}

//根据年月 获取当月第一天和最后一天
- (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return s;
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
