//
//  EveryLoctionViewController.m
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

//实时位置
#import "EveryLoctionViewController.h"
#import "PullSelectTableView.h"
#import "WorkTrailFunction.h"
#import "PeopleLastLocationTableViewCell.h"
#import "ShowTrailViewController.h"

@interface EveryLoctionViewController ()<BATableViewDelegate, SRRefreshDelegate>
{
    HeadStaticView *_headStaticView;
    NSMutableArray *_dataArray;
    NSMutableArray *_tureArray;
    NSMutableArray *_falseArray;
    
    PullSelectTableView *_pullSelectView;
    EveryLocationBAView *_baTableView;
    SRRefreshView *_slimeView;
    
    NSArray *_countArray;
}
@end

@implementation EveryLoctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self dataConfig];
    [self uiConfig];
    [self prepareDataIsRefresh:NO];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dataConfig
{
    _dataArray = [NSMutableArray array];
    _tureArray = [NSMutableArray array];
    _falseArray = [NSMutableArray array];
    
    _countArray = @[@0, @0, @0];
}

- (void)uiConfig
{
    [self initHeadStaticView];
    
    _baTableView = [[EveryLocationBAView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight-64-42-40)];
    _baTableView.delegate = self;
    _baTableView.status = 0;
    [self.view addSubview:_baTableView];
    
    [self addRefreshAndLoadView];
    [self initPullSelectView];
}

//设置cell分割线靠左
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)addRefreshAndLoadView
{
    _slimeView = [self createSlimeRefreshView];
    _slimeView.delegate = self;
}

- (SRRefreshView *)createSlimeRefreshView
{
    SRRefreshView *slimeView = [[SRRefreshView alloc] init];
    slimeView.upInset =0;
    slimeView.slimeMissWhenGoingBack = YES;
    slimeView.slime.bodyColor = [UIColor grayColor];
    slimeView.slime.skinColor = [UIColor grayColor];
    slimeView.slime.lineWith = 1;
    slimeView.slime.shadowBlur = 4;
    slimeView.slime.shadowColor = [UIColor grayColor];
    [_baTableView.tableView addSubview:slimeView];
    return slimeView;
}

- (void)initPullSelectView
{
    NSArray *array = @[@"全部", @"正常", @"异常"];
    _pullSelectView = [[PullSelectTableView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight-64-42-40) titleArray:(NSMutableArray *)array];
    [self.view addSubview:_pullSelectView];
    _pullSelectView.hidden = YES;
    
    [_pullSelectView selectedIndexPathAction:^(NSIndexPath *indexPath) {
        _headStaticView.chooseButton.selected = NO;
        _baTableView.status = indexPath.row;
        [_baTableView reloadData];
        
        [_headStaticView.chooseButton setTitle:array[indexPath.row] forState:UIControlStateNormal];
        
        [_headStaticView fillCount:[_countArray[indexPath.row] integerValue]];
        
    }];
    
}
- (void)initHeadStaticView
{
    _headStaticView = [[HeadStaticView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    [self.view addSubview:_headStaticView];
    [_headStaticView chooseButtonAction:^(BOOL selected) {
        if (selected) {
            _pullSelectView.hidden = NO;
        }else {
            _pullSelectView.hidden = YES;
        }
    }];
}

- (void)prepareDataIsRefresh:(BOOL)isRefresh
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/path/last"];
    NSDictionary *dic = @{@"ids":@[]};
    //ids为空时不传
    if (!isRefresh) {
        [self showHintInView:self.view];
    }
    [Function generalPostRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        [_slimeView endRefresh];
        [self hideHud];
        [self configSortTrueAndFailed:responseObject];
    } errorCB:^(NSError *error) {
        [self hideHud];
        [_slimeView endRefresh];
        
        
    }];
}

- (void)configSortTrueAndFailed:(id)responseObject
{
    NSMutableArray *sourceArray = responseObject;
    [_headStaticView fillCount:sourceArray.count];
    
    [_dataArray removeAllObjects];
    [_tureArray removeAllObjects];
    [_falseArray removeAllObjects];
    
    NSMutableArray *trueSourceArray = [NSMutableArray array];
    NSMutableArray *falseSourceArray = [NSMutableArray array];
    
    for (NSDictionary *dic in sourceArray) {
        if (dic[@"createDate"] == [NSNull null]) {
            [falseSourceArray addObject:dic];
            
        }else {
            if ([WorkTrailFunction lastLocationInHalfHour:dic[@"createDate"]]) {
                [trueSourceArray addObject:dic];
            }else {
                [falseSourceArray addObject:dic];
            }
        }
    }
    
    _countArray = @[[NSNumber numberWithInteger:sourceArray.count],
                    [NSNumber numberWithInteger:trueSourceArray.count],
                    [NSNumber numberWithInteger:falseSourceArray.count]];
    
    
    [WorkTrailFunction sortCharactorWithSourceArray:sourceArray returnArray:_dataArray keyStr:@"userName"];
    [WorkTrailFunction sortCharactorWithSourceArray:trueSourceArray returnArray:_tureArray keyStr:@"userName"];
    [WorkTrailFunction sortCharactorWithSourceArray:falseSourceArray returnArray:_falseArray keyStr:@"userName"];
    
    [_baTableView reloadData];
    
//    [[a,a],[b,b], [#]]
    
}

- (NSInteger)returnNumRowWithArray:(NSMutableArray *)array index:(NSInteger)index
{
    if ([array[index] count] == 0) {
        return 1;
    }
    return [array[index] count];
}

- (CGFloat)returnRowHeightWithArray:(NSMutableArray *)array indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([array[indexPath.section] count] == 0) {
        return 0;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (NSArray *)sectionIndexTitlesForABELTableView:(BATableView *)tableView
{
    
    NSMutableArray *indexTitle = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        [indexTitle addObject:[NSString stringWithFormat:@"%c", i + 65]];
    }
    [indexTitle addObject:@"#"];
    return indexTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    EveryLocationBAView *baView = (EveryLocationBAView *)tableView.superview;
    if (baView.status == 0) {
        return [self returnNumRowWithArray:_dataArray index:section];
    }else if (baView.status == 1) {
        return [self returnNumRowWithArray:_tureArray index:section];
    }else if (baView.status == 2) {
        return [self returnNumRowWithArray:_falseArray index:section];
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    EveryLocationBAView *baView = (EveryLocationBAView *)tableView.superview;
    if (baView.status == 0) {
        return _dataArray.count;
    }else if (baView.status == 1) {
        return _tureArray.count;
    }else if (baView.status == 2) {
        return _falseArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    EveryLocationBAView *baView = (EveryLocationBAView *)tableView.superview;
    if (baView.status == 0) {
        return ([_dataArray[section] count] == 0 ? 0: 30);
    }else if (baView.status == 1) {
        return ([_tureArray[section] count] == 0 ? 0: 30);
    }else if (baView.status == 2) {
        return ([_falseArray[section] count] == 0 ? 0: 30);
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EveryLocationBAView *baView = (EveryLocationBAView *)tableView.superview;
    if (baView.status == 0) {
        return [self returnRowHeightWithArray:_dataArray indexPath:indexPath tableView:tableView];
    }else if (baView.status == 1) {
        return [self returnRowHeightWithArray:_tureArray indexPath:indexPath tableView:tableView];
    }else if (baView.status == 2) {
        return [self returnRowHeightWithArray:_falseArray indexPath:indexPath tableView:tableView];
    }else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section + 65 > 90) {
        return @"    #";
    }else {
        return [NSString stringWithFormat:@"    %c", (int)section + 65];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    PeopleLastLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[PeopleLastLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    EveryLocationBAView *baView = (EveryLocationBAView *)tableView.superview;
    if (baView.status == 0) {
        if ([_dataArray[indexPath.section] count] != 0) {
            [cell fillData:_dataArray[indexPath.section][indexPath.row] status:0];
        }else {
            [cell hideAllView:YES];
        }
    
    }else if (baView.status == 1) {
        if ([_tureArray[indexPath.section] count] != 0) {
            [cell fillData:_tureArray[indexPath.section][indexPath.row] status:1];
        }else {
            [cell hideAllView:YES];
        }
        
    }else if (baView.status == 2) {
        if ([_falseArray[indexPath.section] count] != 0) {
            [cell fillData:_falseArray[indexPath.section][indexPath.row] status:2];
        }else {
            [cell hideAllView:YES];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShowTrailViewController *trailMapCtrl = [[ShowTrailViewController alloc] init];
    trailMapCtrl.saleId = _dataArray[indexPath.section][indexPath.row][@"saleId"];
    [self.navigationController pushViewController:trailMapCtrl animated:YES];
}

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
    [self prepareDataIsRefresh:NO];
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

@implementation HeadStaticView
{
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BACK_COLOR;
        
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseButton.frame = CGRectMake(15, 0, 40, kFrameH(self));
        [_chooseButton setTitle:@"全部" forState:UIControlStateNormal];
        _chooseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_chooseButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
        _chooseButton.titleLabel.font = GDBFont(14);
        [_chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chooseButton];
        [_chooseButton sizeToFit];
        
        UIImage *downArrowImg = [UIImage imageNamed:@"tree_ex"];
        _chooseButton.frame = CGRectMake(15, 0, kFrameW(_chooseButton)+kImgWidth(downArrowImg), kFrameH(self));
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:downArrowImg];
        imgView.center = CGPointMake(kFrameW(_chooseButton)-kImgWidth(downArrowImg)/2.0, kFrameH(_chooseButton)/2.0);
        [_chooseButton addSubview:imgView];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-80-15, 0, 80, kFrameH(self))];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = GDBFont(14);
        _countLabel.textColor = COMMON_FONT_BLACK_COLOR;
        [self addSubview:_countLabel];
        
    }
    return self;
}

- (void)chooseButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    _chooseButtonCB(button.selected);
}

- (void)fillCount:(NSInteger)count
{
    _countLabel.text = [NSString stringWithFormat:@"%ld人", count];
}

- (void)chooseButtonAction:(void(^)(BOOL selected))action;
{
    _chooseButtonCB = action;
}

@end

@implementation EveryLocationBAView



@end
