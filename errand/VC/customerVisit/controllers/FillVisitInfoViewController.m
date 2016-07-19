//
//  FillVisitInfoViewController.m
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "FillVisitInfoViewController.h"
#import "FillVisitTextViewTableViewCell.h"
#import "FillVisitLabelTableViewCell.h"
#import "MMDateView.h"
#import "ProductionsViewController.h"
#import "SelectStaffViewController.h"
#import "ContactModel.h"
#import "DoctorsModel.h"

@interface FillVisitInfoViewController ()<UITableViewDelegate, UITableViewDataSource, MMDateViewDelegate, UITextViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_placeholderArray;
    NSMutableArray *_fillInfoArray;
    
    UILabel *_footLabel;
    UITableView *_tableView;
    UIView *_footerView;
    
    NSNumber *_carryPeopleID;
    NSIndexPath *_dateIndexPath;
    NSIndexPath *_productIndexPath;
    
    ProductionModel *_productModel;
    ContactModel *_contactModel;
    DoctorsModel *_doctorModel;
    NSString *_dateStr;
}

@property (nonatomic, copy) void(^uploadFinish)(NSString *dateStr);

@end

@implementation FillVisitInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    [self dataConfig];
    
}

- (void)dataConfig
{
    if (_type == 0) {
        _titleArray = @[@"拜访客户：", @"协访人：", @"拜访日期：", @"拜访内容："];
        _placeholderArray = @[@"请选择客户", @"请选择协访人", @"请选择时间", @"拜访内容"];
        _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
    }else {
        _titleArray = @[@"拜访客户：", @"协访人：", @"拜访内容："];
        _placeholderArray = @[@"请选择客户", @"请选择协访人", @"拜访内容"];
        _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @""]];
    }
    
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    _footerView.backgroundColor = [UIColor whiteColor];
//    _tableView.tableFooterView = _footerView;
    
    _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kWidth-15, 44)];
    _footLabel.font = GDBFont(15);
    [_footerView addSubview:_footLabel];
    
    //设置cell分割线靠左
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
- (void)handleTapOperation:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if ([_titleArray[indexPath.row] isEqualToString:@"拜访客户："]) {
        [self showProductionsCtrl:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"协访人："]) {
        [self selectCarryPeople:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"拜访日期："]) {
        [self showSelectDate:indexPath];
    }
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_titleArray[indexPath.row] isEqualToString:@"拜访内容："]) {
        static NSString *cellid = @"textViewCellid";
        FillVisitTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[FillVisitTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            cell.textView.delegate = self;
        }
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.textView.text = _fillInfoArray[indexPath.row];
        return cell;
        
    }else {
        static NSString *cellid = @"labelCellid";
        FillVisitLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[FillVisitLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        cell.titleLabel.text = _titleArray[indexPath.row];
        [cell fillContent:_fillInfoArray[indexPath.row] placeholder:_placeholderArray[indexPath.row]];
        
        [cell clearButtonClickAction:^(FillVisitLabelTableViewCell *currentCell) {
            NSIndexPath *currentIndexPath = [tableView indexPathForCell:currentCell];
            [_fillInfoArray replaceObjectAtIndex:currentIndexPath.row withObject:@""];
            _carryPeopleID = nil;
        }];
        
        [cell contentLabelTapAction:^(FillVisitLabelTableViewCell *currentCell) {
            NSIndexPath *currentIndexPath = [tableView indexPathForCell:currentCell];
            [self handleTapOperation:currentIndexPath];
        }];
        
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
    if ([_titleArray[indexPath.row] isEqualToString:@"拜访内容："]) {
        return 150;
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)showSelectDate:(NSIndexPath *)indexPath
{
    MMDateView *dateView = [MMDateView new];
    dateView.centerLabel.text = @"拜访日期";
    dateView.delegate=self;
    dateView.datePicker.tag=5;
    dateView.datePicker.datePickerMode = UIDatePickerModeDate;
    [dateView showWithBlock:nil];
    _dateIndexPath = indexPath;
    
}

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (_type == 0) {
        
        NSString *todayDateStr = [dateFormatter stringFromDate:[NSDate date]];
        NSString *selectStr = [dateFormatter stringFromDate:picker.date];
        if ([todayDateStr compare:selectStr] == NSOrderedAscending) {
            _dateStr = selectStr;
            [_fillInfoArray replaceObjectAtIndex:_dateIndexPath.row withObject:[_dateStr substringToIndex:10]];
            [_tableView reloadData];
        }else {
            [Dialog simpleToast:@"所选时间必须大于今天的时间"];
        }
        
    }else {
        _dateStr = [dateFormatter stringFromDate:picker.date];
        
        [_fillInfoArray replaceObjectAtIndex:_dateIndexPath.row withObject:_dateStr];
        [_tableView reloadData];
    }
}

- (void)selectCarryPeople:(NSIndexPath *)indexPath
{
    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.extendedLayoutIncludesOpaqueBars = NO;
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    vc.selectCarryPeople = YES;
    [vc setSelectstaffBlock:^(StaffModel *model) {
        _carryPeopleID = (NSNumber *)model.ID;
        [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:model.staffName];
        [_tableView reloadData];
    }];
    
    [vc setSeletNodeStaffBlock:^(NSString *name, NSNumber *ID) {
        _carryPeopleID = ID;
        [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:name];
        [_tableView reloadData];
    }];
}

- (void)showProductionsCtrl:(NSIndexPath *)indexPath;
{
    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
    productionsVC.type = 2;
    [self.navigationController pushViewController:productionsVC animated:YES];
    [productionsVC setFeedBackProductionModelBlock:^(ProductionModel *model) {
        
    }];
    _productIndexPath = indexPath;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProductionData:) name:addVisitSelectCustomerNotification object:nil];
}

- (void)handleProductionData:(NSNotification *)not
{
    NSArray *array = [Function userDefaultsObjForKey:@"costomerArray"];
    _productModel = [NSKeyedUnarchiver unarchiveObjectWithData:array[0]];
    _contactModel = [NSKeyedUnarchiver unarchiveObjectWithData:array[1]];
    _doctorModel = [NSKeyedUnarchiver unarchiveObjectWithData:array[2]];
    
    [_fillInfoArray replaceObjectAtIndex:_productIndexPath.row withObject:_doctorModel.name];
    [_tableView reloadData];
    
    [self getVisitNumber:_doctorModel];
}

- (void)getVisitNumber:(DoctorsModel *)model
{
    NSDictionary *dic = @{@"doctor": @{@"id": model.doctorID}};
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/visitplans/lte30"];
    
    [Function responseNotJsonRequest:urlStr infoDic:dic resultCB:^(id result) {
        _tableView.tableFooterView = _footerView;
        _footLabel.text = [NSString stringWithFormat:@"最近30天拜访次数：%@次", result];
    } errorCB:^(NSError *error) {
        
    }];
    
}

- (void)uploadData
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    if (_doctorModel == nil) {
        [Dialog simpleToast:@"请选择拜访客户"];
        return;
    }
    [muDic setObject:@{@"id": _doctorModel.doctorID} forKey:@"doctor"];
    [muDic setObject:@{@"id": _contactModel.hospitalID} forKey:@"hospital"];
    [muDic setObject:@{@"id": _productModel.productID} forKey:@"production"];
    
    if (_type == 0) {
        if (_dateStr == nil) {
            [Dialog simpleToast:@"请选择拜访时间"];
            return;
        }
        [muDic setObject:_dateStr forKey:@"visitDate"];
    }else {
        _dateStr = [Function stringFromDate:[NSDate date]];
        [muDic setObject:[_dateStr substringToIndex:10] forKey:@"visitDate"];
    }
    
    
    [muDic setObject:[_fillInfoArray lastObject] forKey:@"content"];
    [muDic setObject:[NSString stringWithFormat:@"%ld", _type] forKey:@"category"];
    
    if (_carryPeopleID != nil) {
        [muDic setObject:@{@"id": _carryPeopleID} forKey:@"assist"];
    }
    NSLog(@"%@", muDic);
    
    NSString *urlStr = [BASEURL stringByAppendingString:pathSaleVisitplansCreate];
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:muDic resultCB:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [self hideHud];
        [Dialog simpleToast:@"提交成功"];
        _uploadFinish(_dateStr);
        [self.navigationController popViewControllerAnimated:YES];
        
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    [_fillInfoArray replaceObjectAtIndex:_fillInfoArray.count-1 withObject:textView.text];
}

- (void)uploadDataFinishAction:(void(^)(NSString *dateStr))action
{
    _uploadFinish = action;
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
