//
//  CustomerVisitChildViewController.m
//  errand
//
//  Created by gravel on 15/12/19.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CustomerVisitChildViewController.h"
#import "CustomerVisitBll.h"
#import "CustomerVisitModel.h"
#import "TaskTableViewCell.h"
#import "CustomerVisitDetailViewController.h"
@interface CustomerVisitChildViewController ()<SRRefreshDelegate ,UITableViewDataSource,UITableViewDelegate>@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;

@property (nonatomic, copy) void(^willAppearCB)();

@end

@implementation CustomerVisitChildViewController{
    float navHeight;
    NSMutableArray *dataArray;
    int pageIndex;
    int _totalElements;
    NSString *_visitDateStr;
    NSString *_todayDateStr;
    UILabel *_amountLabel;
    AmotButton *_todayBtn;
    UIView *_topBgView;
    AmotButton *_leftBtn;
    AmotButton *_rightBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    _willAppearCB();
}

- (void)myVisitWillAppear:(void(^)())action
{
    _willAppearCB = action;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
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
    CustomerVisitBll *visitBll = [[CustomerVisitBll alloc]init];
    
    [visitBll getAllCustomerVisitData:^(int totalElements, NSArray *arr) {
        _totalElements = totalElements;
        [self hideHud];
//        if(pageIndex==1){
//            [dataArray removeAllObjects];
//        }
        [dataArray removeAllObjects];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataArray addObject:obj];
        }];
        [_tableView reloadData];
        [self createTopView];
        
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
    } pageIndex:pageIndex visitDate:_visitDateStr category:[NSNumber numberWithInt:_type] viewCtrl:self];//0 计划 1 临时
 
}

-(void)initView{
    dataArray=[[NSMutableArray alloc] init];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    //换成今天的0点的YYYYMMddHHmmss 字符串
    NSString *  startString=[NSString stringWithFormat:@"%@%@",[dateformatter stringFromDate:[NSDate date]],@"000000"];
    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
    [dateformatter2 setDateFormat:@"YYYYMMddHHmmss"];
//    把今天0点的字符串换成时间格式
    NSDate *startDate = [dateformatter2 dateFromString:startString];
    NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
//    把时间格式换成YYYY-MM-dd HH:mm:ss的字符串
    [dateformatter3 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    _visitDateStr = [dateformatter3 stringFromDate:startDate];
    _todayDateStr = [NSString stringWithString:_visitDateStr];
    
    navHeight=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    float bottomHeight=SEG_HEIGHT;
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, navHeight+49, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-bottomHeight-49)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self createSlime];
//    [self createMJ];
    [self initData];
}
- (void)createTopView{
    
    //如果创建过 就不新建
    if (_topBgView == nil) {
        _topBgView = [[UIView alloc]init];
        _topBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topBgView];
        _leftBtn = [[AmotButton alloc]init];
        [_leftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
        [_topBgView addSubview:_leftBtn];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBtn = [[AmotButton alloc]init];
        [_rightBtn setImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
        [_topBgView addSubview:_rightBtn];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _amountLabel = [[UILabel alloc]init];
        [_amountLabel setFont:[UIFont systemFontOfSize:15]];
        _amountLabel.textColor = [UIColor grayColor];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        [_topBgView addSubview:_amountLabel];
        
        _todayBtn = [[AmotButton alloc]init];
        [_todayBtn setImage:[UIImage imageNamed:@"todayBtn"] forState:UIControlStateNormal];
        _todayBtn.hidden = YES;
        _todayBtn.userInteractionEnabled = NO;
        [_topBgView addSubview:_todayBtn];
        [_todayBtn addTarget:self action:@selector(todayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *superView = _topBgView;
        [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.width.equalTo(SCREEN_WIDTH);
            make.height.equalTo(@49);
        }];
        [_todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.mas_right).offset(-10);
            make.width.equalTo(@30);
            make.height.equalTo(@20);
            make.centerY.equalTo(_topBgView);
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_todayBtn.mas_left).offset(-15);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(_topBgView);
        }];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(10+30+10);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(_topBgView);
        }];
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftBtn.mas_right).offset(0);
            make.right.equalTo(_rightBtn.mas_left).offset(0);
            make.centerY.equalTo(_topBgView);
            //        make.centerX.equalTo(topBgView);
        }];

    }
   
    //对时间进行判断
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //今天的秒数
    NSTimeInterval todaySecond = [[dateFormatter dateFromString:_todayDateStr] timeIntervalSince1970];
    //获取往前一天的秒数
    NSDate *clickDate = [dateFormatter dateFromString:_visitDateStr];
    NSTimeInterval clickSecond = [clickDate timeIntervalSince1970];
    
    if (clickSecond - todaySecond == 86400) {
        _amountLabel.text = [NSString stringWithFormat:@"明天有%d个拜访", _totalElements];
        _todayBtn.hidden = NO;
        _todayBtn.userInteractionEnabled = YES;
    }else if (clickSecond - todaySecond ==  86400*2){
        _amountLabel.text = [NSString stringWithFormat:@"后天有%d个拜访", _totalElements];
    }else if (clickSecond - todaySecond ==  -86400){
        _amountLabel.text = [NSString stringWithFormat:@"昨天有%d个拜访", _totalElements];
        _todayBtn.hidden = NO;
        _todayBtn.userInteractionEnabled = YES;
    }else if (clickSecond - todaySecond ==  -86400*2){
        _amountLabel.text = [NSString stringWithFormat:@"前天有%d个拜访", _totalElements];
    }else if (clickSecond - todaySecond ==  0){
        _amountLabel.text = [NSString stringWithFormat:@"今天有%d个拜访", _totalElements];
        _todayBtn.hidden = YES;
        _todayBtn.userInteractionEnabled = NO;
        
    }else{
        
        _amountLabel.text = [NSString stringWithFormat:@"%@有%d个拜访",[_visitDateStr substringToIndex:10], _totalElements];
    }
    
    
}

- (void)leftBtnClick{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取往前一天的日期
    NSDate *date = [dateFormatter dateFromString:_visitDateStr];
    NSTimeInterval second = [date timeIntervalSince1970];
    _visitDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second - 86400]];
    //请求点击日期的数据
    pageIndex = 0;
    [self initData];
    
}
- (void)rightBtnClick{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取往前一天的日期
    NSDate *date = [dateFormatter dateFromString:_visitDateStr];
    NSTimeInterval second = [date timeIntervalSince1970];
    _visitDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second + 86400]];
    
    //请求点击日期的数据
    pageIndex = 0;
    [self initData];
    
}
- (void)todayBtnClick{
  
    _visitDateStr = [NSString stringWithString:_todayDateStr];
    //请求点击日期的数据
    pageIndex = 0;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"cell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    CustomerVisitModel *model=dataArray[indexPath.row];
    
    [cell setCustomerVisitModel:model];
    cell.callPhoneBlock = ^(){
        [self openCall:model.phoneNumber];
    };
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerVisitDetailViewController *customerVisitDetail = [[CustomerVisitDetailViewController alloc]init];
    customerVisitDetail.visitID = [dataArray[indexPath.row] visitID];
    customerVisitDetail.status = [dataArray[indexPath.row] stateString];
    customerVisitDetail.indexPath = indexPath;
    customerVisitDetail.changeVisitStatusBlock = ^(NSIndexPath *changeIndexPath , NSString *status){
        CustomerVisitModel *model = dataArray[changeIndexPath.row];
        model.stateString = status;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:changeIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    [customerVisitDetail setRefreshBeforeDataCB:^{
        pageIndex=1;
        [self initData];
    }];

    [self.navigationController pushViewController:customerVisitDetail animated:YES];
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
    __block  CustomerVisitChildViewController *VisitVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [VisitVC initData];
    }];
}

- (void)refreshData {
    
    _visitDateStr = _dateStr;
    
    pageIndex=1;
    [self initData];
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
