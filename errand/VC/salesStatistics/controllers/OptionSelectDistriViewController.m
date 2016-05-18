//
//  OptionSelectDistriViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "OptionSelectDistriViewController.h"

@interface OptionSelectDistriViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
}

@property (nonatomic, copy) void(^selectedDistriDicCB)(NSDictionary *distriDic);

@end

@implementation OptionSelectDistriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择配送商";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    
    [self uiConfig];
    [self getDistributionInfo];
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)getDistributionInfo
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/distribution"];
    NSDictionary *dic = @{@"province": _contactModel.provincial,
                          @"city": _contactModel.city};
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        _dataArray = [NSMutableArray arrayWithArray:responseObject];
        
        if (_dataArray.count == 0) {
            [Dialog simpleToast:@"无配送商信息"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [_tableView reloadData];
        [self hideHud];
    } errorCB:^(NSError *error) {
        
        [self hideHud];
    }];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.textLabel.font = GDBFont(15);
        cell.textLabel.textColor = COMMON_FONT_BLACK_COLOR;
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"vendor"];
    
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
    return 44;
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
    _selectedDistriDicCB(_dataArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedDistriDicAction:(void(^)(NSDictionary *distriDic))action
{
    _selectedDistriDicCB = action;
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
