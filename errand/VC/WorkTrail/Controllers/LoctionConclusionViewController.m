//
//  LoctionConclusionViewController.m
//  
//
//  Created by pro on 16/4/6.
//
//

//定位总结
#import "LoctionConclusionViewController.h"
#import "XYPieChart.h"
#import "LocationConclusionTableViewCell.h"
#import "CheckWorkFunction.h"
#import "ColorGuideStatusView.h"
#import "SignStatusListViewController.h"

@interface LoctionConclusionViewController ()<XYPieChartDelegate, XYPieChartDataSource, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_bottomTableView;
    UIScrollView *_scrollView;
    XYPieChart *_pieChartView;
    
    NSArray *_titleArray;
    NSArray *_sliceValueArray;
    ColorGuideStatusView *_colorGuideView;
    
    NSArray *_trueArray;
    NSArray *_falseArray;
    NSArray *_incompleteArray;
    
    NSArray *_countArray;
}
@end

@implementation LoctionConclusionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
}

- (void)dataConfig
{
    _titleArray = @[@"异常", @"点不全", @"正常"];
    _sliceValueArray = @[@10, @30, @60];
    _countArray = @[@"10", @"30", @"60"];
}

- (void)uiConfig
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-42)];
    _scrollView.backgroundColor = COMMON_BACK_COLOR;
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    [self createPieChartView];
    
    [self addColorGuideView];
    [self createBottomTableView];
}

- (void)addColorGuideView
{
    _colorGuideView = [[ColorGuideStatusView alloc] initWithFrame:CGRectMake(15, kFrameY(_pieChartView)+kFrameH(_pieChartView)+40, kWidth-30, 20)];
    [_scrollView addSubview:_colorGuideView];
    _colorGuideView.hidden = YES;
}

- (void)prepareData
{
    [self showHintInView:self.view];
    
    NSString *startDate = [CheckWorkFunction stringFromDate:[NSDate date] isStart:NO];
    NSDictionary *dic = @{@"startDate": startDate};
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/path/count"];
   
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        
        [self configResult:responseObject];
        
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)configResult:(id)responseObject
{
    _trueArray = responseObject[@"normal"];
    _falseArray = responseObject[@"error"];
    _incompleteArray = responseObject[@"unComplete"];
    
    float sum = _trueArray.count + _falseArray.count + _incompleteArray.count;
    NSLog(@"%f", sum);
    _sliceValueArray = @[[NSNumber numberWithFloat:_falseArray.count/sum],
                         [NSNumber numberWithFloat:_incompleteArray.count/sum],
                         [NSNumber numberWithFloat:_trueArray.count/sum]];
    
    
    
    _countArray = @[[NSString stringWithFormat:@"%ld", (unsigned long)_falseArray.count],
                    [NSString stringWithFormat:@"%ld", (unsigned long)_incompleteArray.count],
                    [NSString stringWithFormat:@"%ld", (unsigned long)_trueArray.count]];
    [_bottomTableView reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(pieChartViewReloadData) userInfo:nil repeats:NO];
    
    _pieChartView.hidden = NO;
    _bottomTableView.hidden = NO;
    _colorGuideView.hidden = NO;
    
}

- (void)pieChartViewReloadData
{
    [_pieChartView reloadData];
}

- (void)createPieChartView
{
    _pieChartView = [[XYPieChart alloc] initWithFrame:CGRectMake(0, 0, 200, 200) Center:CGPointZero Radius:100];
    _pieChartView.dataSource = self;
    _pieChartView.startPieAngle = -M_PI_2;
//    _pieChartView.animationSpeed = 0.1;
    _pieChartView.showPercentage = NO;
    _pieChartView.labelColor = [UIColor whiteColor];
    _pieChartView.labelFont = [UIFont systemFontOfSize:13];
    _pieChartView.selectedSliceOffsetRadius = 5;
    _pieChartView.pieCenter = CGPointMake(kWidth/2.0, 100+20);
    _pieChartView.userInteractionEnabled = NO;
    [_scrollView addSubview:_pieChartView];
    _pieChartView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createBottomTableView
{
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kFrameY(_colorGuideView)+kFrameH(_colorGuideView)+40, kWidth-30, 50+3*40)];
    _bottomTableView.scrollEnabled = NO;
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    _bottomTableView.separatorStyle = 0;
    _bottomTableView.layer.cornerRadius = 5;
    _bottomTableView.layer.borderColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.80 alpha:1.00].CGColor;
    _bottomTableView.layer.borderWidth = 0.5;
    _bottomTableView.hidden = YES;
    [_scrollView addSubview:_bottomTableView];
    
    LocationConclusionTableHeadView *tableHeadview = [[LocationConclusionTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth-30, 50)];
    _bottomTableView.tableHeaderView = tableHeadview;
    
    _scrollView.contentSize = CGSizeMake(0, kFrameY(_bottomTableView)+kFrameH(_bottomTableView)+20);
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart;
{
    return _sliceValueArray.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
{
    return [_sliceValueArray[index] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index;
{
    if (index == 0) {//正常
        return [UIColor colorWithRed:0.88 green:0.50 blue:0.43 alpha:1.00];
        
    }else if (index == 1) {//点不全
        return [UIColor colorWithRed:0.46 green:0.25 blue:0.84 alpha:1.00];
    }else {//异常
        return [UIColor colorWithRed:0.20 green:0.64 blue:0.41 alpha:1.00];
    }
    
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index;
{
    if (index == 0) {
        return [NSString stringWithFormat:@"%@人", _countArray[index]];
        
    }else if (index == 1) {
        return [NSString stringWithFormat:@"%@人", _countArray[index]];
    }else {
        return [NSString stringWithFormat:@"%@人", _countArray[index]];
    }
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    LocationConclusionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LocationConclusionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    [cell fillDescAndTitle:_titleArray[indexPath.row]];
    [cell fillCount:_countArray[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
//    if ([_titleArray[indexPath.row] isEqualToString:@"点不全"]) {
//        return 40;
//    }else {
//        return 80;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_titleArray[indexPath.row] isEqualToString:@"异常"]) {
        SignStatusListViewController *signStatusCtrl = [[SignStatusListViewController alloc] init];
        signStatusCtrl.status = _titleArray[indexPath.row];
        signStatusCtrl.dataArray = _falseArray;
        [self.navigationController pushViewController:signStatusCtrl animated:YES];
        
    }else if ([_titleArray[indexPath.row] isEqualToString:@"点不全"]) {
        SignStatusListViewController *signStatusCtrl = [[SignStatusListViewController alloc] init];
        signStatusCtrl.status = _titleArray[indexPath.row];
        signStatusCtrl.dataArray = _incompleteArray;
        [self.navigationController pushViewController:signStatusCtrl animated:YES];
        
    }else if ([_titleArray[indexPath.row] isEqualToString:@"正常"]) {
        SignStatusListViewController *signStatusCtrl = [[SignStatusListViewController alloc] init];
        signStatusCtrl.status = _titleArray[indexPath.row];
        signStatusCtrl.dataArray = _trueArray;
        [self.navigationController pushViewController:signStatusCtrl animated:YES];
        
    }
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


@implementation LocationConclusionTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.83 green:0.82 blue:0.80 alpha:1.00];
        
        UILabel *statusLabel = [self createGeneralLabel:16 frame:CGRectMake(0, 0, 75, 50) textColor:COMMON_FONT_BLACK_COLOR];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = @"状态";
        
        UILabel *descLabel = [self createGeneralLabel:16 frame:CGRectMake(75, 0, kWidth-30-150, 50) textColor:COMMON_FONT_BLACK_COLOR];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.text = @"描述";
        
        UILabel *countLabel = [self createGeneralLabel:16 frame:CGRectMake(kWidth-30-75, 0, 75, 50) textColor:COMMON_FONT_BLACK_COLOR];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.text = @"人数";
        
    }
    return self;
}

@end
