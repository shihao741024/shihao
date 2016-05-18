//
//  VisitRecordDetailViewController.m
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitRecordDetailViewController.h"
#import "VisitRecordDetailTableViewCell.h"
#import "VisitDetailSubTitleTableViewCell.h"

@interface VisitRecordDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_titleArray;
    
    NSDictionary *_resultDic;
}
@end

@implementation VisitRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = @"拜访详情";
    
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
}

- (void)dataConfig
{
    _titleArray = [NSMutableArray array];
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = GDBColorRGB(0.97,0.97,0.97,1);
    [self.view addSubview:_tableView];
    
}

- (void)prepareData
{
    NSString *pathStr = [NSString stringWithFormat:@"/api/v1/sale/visitplans/%@", _visitDic[@"id"]];//_visitDic[@"id"]
    NSString *urlStr = [BASEURL stringByAppendingString:pathStr];
    
    [self showHintInView:self.view];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        [self resultConfig:responseObject];
        [self hideHud];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)resultConfig:(id)responseObject
{
    _resultDic = responseObject;
    
    [_titleArray removeAllObjects];
    [_titleArray addObject:@"info"];
    if (![Function isBlankStrOrNull:_resultDic[@"content"]]) {
        [_titleArray addObject:@"content"];
    }
    if (![Function isBlankStrOrNull:_resultDic[@"summary"]]) {
        [_titleArray addObject:@"summary"];
    }
    [_tableView reloadData];
}

- (CornerStyle)getCornerStyleWithTitle:(NSString *)title
{
    if ([title isEqualToString:@"info"]) {
        if (_titleArray.count == 1) {
            return CornerSingle;
        }else {
            return CornerTop;
        }
    }else if ([title isEqualToString:@"content"]) {
        if (_titleArray.count == 2) {
            return CornerBottom;
        }else {
            return CornerMiddle;
        }
    }else if ([title isEqualToString:@"summary"]) {
        return CornerBottom;
    }else {
        return CornerNone;
    }
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_titleArray[indexPath.row] isEqualToString:@"info"]) {
        
        static NSString *cellid = @"infocellid";
        VisitRecordDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[VisitRecordDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        
        [cell fillData:_resultDic cornerStyle:[self getCornerStyleWithTitle:_titleArray[indexPath.row]]];
        return cell;
        
    }else {
        
        static NSString *cellid = @"subTitlecellid";
        VisitDetailSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[VisitDetailSubTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        if ([_titleArray[indexPath.row] isEqualToString:@"content"]) {
            [cell fillDataWithTitle:@"拜访内容" detail:_resultDic[@"content"] cornerStyle:[self getCornerStyleWithTitle:_titleArray[indexPath.row]]];
        }else {
            [cell fillDataWithTitle:@"拜访总结" detail:_resultDic[@"summary"] cornerStyle:[self getCornerStyleWithTitle:_titleArray[indexPath.row]]];
        }
        return cell;
    }
    
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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
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
