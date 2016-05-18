//
//  TravelSituationViewController.m
//  
//
//  Created by pro on 16/4/14.
//
//

#import "TravelSituationViewController.h"
#import "LocationDetailViewController.h"
#import "TravelSituationTableViewCell.h"

@interface TravelSituationViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_headDateLabel;
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
}
@end

@implementation TravelSituationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = @"出行情况";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItemTitle:@"明细"];
    
    [self uiConfig];
    [self prepareDate];
    
}

- (void)rightItemTitleClick
{
    LocationDetailViewController *detailCtrl = [[LocationDetailViewController alloc] init];
    detailCtrl.saleId = _saleId;
    detailCtrl.startDate = _startDate;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)uiConfig
{
    [self createHeadDateView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kWidth, kHeight-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    
}

- (void)createHeadDateView
{
    _headDateLabel = [self.view createGeneralLabel:15 frame:CGRectMake(0, 64, kWidth, 40) textColor:COMMON_FONT_BLACK_COLOR];
    _headDateLabel.textAlignment = NSTextAlignmentCenter;
    _headDateLabel.text = [_startDate substringToIndex:10];
}

- (void)prepareDate
{
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/sale/path/summary/%@", _saleId];
    NSDictionary *dic = @{@"startDate": _startDate};
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        
        [self configResult:responseObject];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)configResult:(id)responseObject
{
    _dataArray = [NSMutableArray arrayWithArray:responseObject];
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    TravelSituationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TravelSituationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        
    }
    if (indexPath.row == 0) {
        [cell fillData:_dataArray[indexPath.row] beforeDic:nil];
    }else {
        [cell fillData:_dataArray[indexPath.row] beforeDic:_dataArray[indexPath.row-1]];
    }
    
    if (indexPath.row == _dataArray.count-1) {
        [cell hideLinkImgView:YES];
    }else {
        [cell hideLinkImgView:NO];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
