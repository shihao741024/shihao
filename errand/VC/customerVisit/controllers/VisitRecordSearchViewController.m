//
//  VisitRecordSearchViewController.m
//  errand
//
//  Created by pro on 16/4/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "VisitRecordSearchViewController.h"
#import "FillVisitLabelTableViewCell.h"
#import "MMDateView.h"
#import "ProductionsViewController.h"
#import "SelectStaffViewController.h"
#import "ContactViewController.h"
#import "MMChoiceOneView.h"
#import "DoctorsViewController.h"

@interface VisitRecordSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MMDateViewDelegate, MMChoiceViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_placeholderArray;
    
    NSMutableArray *_fillInfoArray;
    NSIndexPath *_currentIndexPath;
    NSArray *_visitTypeArray;
    NSArray *_visitTypeFlag;
    
    ProductionModel *_productModel;
    ContactModel *_contactModel;
    NSArray *_visitPeopleArray;
    
    DoctorsModel *_doctorsModel;
}

@property (nonatomic, copy) void(^searchParameterCB)(NSDictionary *);

@end

@implementation VisitRecordSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = @"拜访查询";
    [self createRightItemTitle:@"查询"];
    
    [self dataConfig];
    [self uiConfig];
    
}

#pragma mark - WJJLabelDelegate
- (void)changeDataSourceWithIndex:(NSInteger)index {
    
    
}

- (void)backSearchParameterAction:(void(^)(NSDictionary *saveDic))action
{
    _searchParameterCB = action;
}

- (void)rightItemTitleClick
{

    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    if (_visitPeopleArray) {
        [muDic setObject:_visitPeopleArray forKey:@"staffDicArray"];
    }
    if (_productModel) {
        [muDic setObject:_productModel forKey:@"productModel"];
    }
    if (_contactModel) {
        [muDic setObject:_contactModel forKey:@"contactModel"];
    }
    if (_doctorsModel) {
        [muDic setObject:_doctorsModel forKey:@"doctorsModel"];
    }
    NSString *startDate = _fillInfoArray[[_titleArray indexOfObject:@"起始日期："]];
    NSString *endDate = _fillInfoArray[[_titleArray indexOfObject:@"结束日期："]];
    
    if ((![startDate isEqualToString:@""]) && (![endDate isEqualToString:@""])) {
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [Dialog simpleToast:@"起始日期不能超过结束日期"];
            return;
        }
    }
    [muDic setObject:startDate forKey:@"startDate"];
    [muDic setObject:endDate forKey:@"endDate"];
    NSInteger typeIndex = [_titleArray indexOfObject:@"类型："];
    NSString *typeStr = [_fillInfoArray objectAtIndex:typeIndex];
    if (![typeStr isEqualToString:@""]) {
        
        NSInteger strIndex = [_visitTypeArray indexOfObject:typeStr];
       [muDic setObject:[_visitTypeFlag objectAtIndex:strIndex] forKey:@"typeStr"];
        
    }else {
        [muDic setObject:@"" forKey:@"typeStr"];
    }
    _searchParameterCB(muDic);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)dataConfig
{
    _titleArray = @[@"拜访人：", @"产品：", @"医院：", @"医生：", @"起始日期：", @"结束日期：", @"类型："];
    _placeholderArray = @[@"请选择拜访人", @"请选择产品", @"请选择医院", @"请选择医生", @"请选择起始日期", @"请选择结束日期", @"请选择类型"];
    _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @"", @""]];
    _visitTypeFlag = @[@"3", @"0", @"1", @"2", @"-1"];
    //                    4     3       0         1       2         -1
    _visitTypeArray = @[@"失访", @"待拜访", @"拜访中", @"已拜访", @"已过期"];
    
    if (_saveDic) {
        [self fillInfoData];
    }
}

- (void)fillInfoData
{
    NSArray *staffDicArray = _saveDic[@"staffDicArray"];
    _visitPeopleArray = staffDicArray;
    if (_visitPeopleArray) {
        NSMutableArray *nameArray = [NSMutableArray array];
        for (NSDictionary *staffDic in staffDicArray) {
            NSString *name = staffDic[@"name"];
            [nameArray addObject:name];
        }
        
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"拜访人："] withObject:[nameArray componentsJoinedByString:@" "]];
    }
    _productModel = _saveDic[@"productModel"];
    if (_productModel) {
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"产品："] withObject:[NSString stringWithFormat:@"%@(%@)", _productModel.name, _productModel.specification]];
    }
    _contactModel = _saveDic[@"contactModel"];
    if (_contactModel) {
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"医院："] withObject:_contactModel.hospitalName];
    }
    _doctorsModel = _saveDic[@"doctorsModel"];
    if (_doctorsModel) {
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"医生："] withObject:_doctorsModel.name];
    }
    NSString *startDate = _saveDic[@"startDate"];
    if (![startDate isEqualToString:@""]) {
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"起始日期："] withObject:startDate];
    }
    NSString *endDate = _saveDic[@"endDate"];
    if (![endDate isEqualToString:@""]) {
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"结束日期："] withObject:endDate];
    }
    NSString *typeStr = _saveDic[@"typeStr"];
    
    if (![typeStr isEqualToString:@""]) {
        NSInteger strIndex = [_visitTypeFlag indexOfObject:typeStr];
        [_fillInfoArray replaceObjectAtIndex:[_titleArray indexOfObject:@"类型："] withObject:[_visitTypeArray objectAtIndex:strIndex]];
    }
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kTableViewColor;
    [self.view addSubview:_tableView];
    
    
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
#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"labelCellid";
    FillVisitLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FillVisitLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
//    [cell fillContent:_fillInfoArray[indexPath.row] placeholder:_placeholderArray[indexPath.row]];
    [cell searchVisitRecordFillContent:_fillInfoArray[indexPath.row] placeholder:_placeholderArray[indexPath.row]];
    
    [cell clearButtonClickAction:^(FillVisitLabelTableViewCell *currentCell) {
        NSIndexPath *currentIndexPath = [tableView indexPathForCell:currentCell];
        [_fillInfoArray replaceObjectAtIndex:currentIndexPath.row withObject:@""];
        [self clearProperty:indexPath];
    }];
    
    [cell contentLabelTapAction:^(FillVisitLabelTableViewCell *currentCell) {
        NSIndexPath *currentIndexPath = [tableView indexPathForCell:currentCell];
        [self handleTapOperation:currentIndexPath];
    }];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)clearProperty:(NSIndexPath *)indexPath
{
    if ([_titleArray[indexPath.row] isEqualToString:@"拜访人："]) {
        _visitPeopleArray = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"产品："]) {
        _productModel = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"医院："]) {
        _contactModel = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"医生："]) {
        _doctorsModel = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"起始日期："]) {
        
    }else if ([_titleArray[indexPath.row] isEqualToString:@"结束日期："]) {
        
    }else if ([_titleArray[indexPath.row] isEqualToString:@"类型："]) {
        
    }
}

- (void)handleTapOperation:(NSIndexPath *)indexPath
{
//    @[@"拜访人：", @"产品：", @"医院：", @"医生：", @"起始日期：", @"结束日期：", @"类型："];
    [self.view endEditing:YES];
    _currentIndexPath = indexPath;
    if ([_titleArray[indexPath.row] isEqualToString:@"拜访人："]) {
        [self selectVisitPeople:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"产品："]) {
        [self showProductionsCtrl:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"医院："]) {
        [self selectHospitalCtrl:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"医生："]) {
        [self selectDoctor:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"起始日期："]) {
        [self showSelectDate:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"结束日期："]) {
        [self showSelectDate:indexPath];
    }else if ([_titleArray[indexPath.row] isEqualToString:@"类型："]) {
        [self showVisitType:indexPath];
    }
    
}

- (void)selectVisitPeople:(NSIndexPath *)indexPath
{
    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.extendedLayoutIncludesOpaqueBars = NO;
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    vc.searchVisitRecord = YES;
    vc.staffDicArray = (NSMutableArray *)_visitPeopleArray;
    
    [vc setSearchVisitRecordStaffCB:^(NSArray *staffDicArray) {
        _visitPeopleArray = staffDicArray;
        
        NSMutableArray *nameArray = [NSMutableArray array];
        for (NSDictionary *staffDic in staffDicArray) {
            NSString *name = staffDic[@"name"];
            [nameArray addObject:name];
            
        }
        [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:[nameArray componentsJoinedByString:@" "]];
        [_tableView reloadData];
    }];
    
}

- (void)showProductionsCtrl:(NSIndexPath *)indexPath;
{
    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
    productionsVC.type = 0;
    [self.navigationController pushViewController:productionsVC animated:YES];
    [productionsVC setFeedBackProductionModelBlock:^(ProductionModel *model) {
        _productModel = model;
        [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:[NSString stringWithFormat:@"%@(%@)", model.name, model.specification]];
        [_tableView reloadData];
    }];
}

- (void)selectHospitalCtrl:(NSIndexPath *)indexPath
{
    ContactViewController *contactVC = [[ContactViewController alloc]init];
    contactVC.type = 7;
    [self.navigationController pushViewController:contactVC animated:YES];
    
    contactVC.feedBackContactModelBlock= ^(ContactModel *contactModel) {
        _contactModel = contactModel;
        [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:contactModel.hospitalName];
        [_tableView reloadData];
    };
}

- (void)selectDoctor:(NSIndexPath *)indexPath
{
    if (_contactModel) {
        DoctorsViewController *doctorVC = [[DoctorsViewController alloc]init];
        doctorVC.contactModel = _contactModel;
        doctorVC.type = 8;
        doctorVC.popIndex = 2;
        [self.navigationController pushViewController:doctorVC animated:YES];
        
        [doctorVC searchDoctorInHospitalSelectAction:^(DoctorsModel *model) {
            _doctorsModel = model;
            [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:_doctorsModel.name];
            [_tableView reloadData];
        }];
    }else {
        ContactViewController *contactVC = [[ContactViewController alloc]init];
        contactVC.type = 8;
        [self.navigationController pushViewController:contactVC animated:YES];
        
        [contactVC setFeedBackDoctorsModelBlock:^(DoctorsModel *model) {
            _doctorsModel = model;
            [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:_doctorsModel.name];
            [_tableView reloadData];
        }];
    }
    
}

- (void)showSelectDate:(NSIndexPath *)indexPath
{
    MMDateView *dateView = [MMDateView new];
    dateView.delegate=self;
    dateView.datePicker.tag=indexPath.row+100;
    dateView.datePicker.datePickerMode = UIDatePickerModeDate;
    [dateView showWithBlock:nil];
    
    if (indexPath.row == 4) {
        dateView.centerLabel.text = @"起始日期";
    }else {
        dateView.centerLabel.text = @"结束日期";
    }
    
}

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:picker.date];
    
    [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:dateStr];
    [_tableView reloadData];
}

- (void)showVisitType:(NSIndexPath *)indexPath
{
    MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
    choiceView.pickerView.tag = 1;
    choiceView.pickerView.delegate = self;
    choiceView.pickerView.dataSource = self;
    choiceView.delegate = self;
    [choiceView showWithBlock:nil];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
//    for (NSString *title in _visitTypeArray) {
//        [actionSheet addButtonWithTitle:title];
//    }
//    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:_visitTypeArray[buttonIndex-1]];
        [_tableView reloadData];
    }
    
}

#pragma mark --- UIPickerView
-(void)MMChoiceViewChoiced:(UIPickerView*)picker{
    int row =(int)[picker selectedRowInComponent:0];
    
    [_fillInfoArray replaceObjectAtIndex:_currentIndexPath.row withObject:_visitTypeArray[row]];
    [_tableView reloadData];
}

// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    return  _visitTypeArray.count;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  _visitTypeArray[row];
    
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

@implementation SearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查询结果";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
}

- (void)prepareData
{
    
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/visitplans/list"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_staffDicArray != nil) {
        NSMutableArray *ids = [NSMutableArray array];
        for (NSDictionary *dic in _staffDicArray) {
            [ids addObject:dic[@"ID"]];
        }
        [dic setObject:ids forKey:@"ids"];
    }
    if (_productmodel != nil) {
        [dic setObject:@{@"id": _productmodel.productID} forKey:@"production"];
    }
    if (_contactModel != nil) {
        [dic setObject:@{@"id": _contactModel.hospitalID} forKey:@"hospital"];
    }
    if (_doctorsModel != nil) {
        [dic setObject:@{@"id": _doctorsModel.doctorID} forKey:@"doctor"];
    }
    if (![_startDate isEqualToString:@""]) {
        [dic setObject:_startDate forKey:@"startDate"];
    }
    if (![_endDate isEqualToString:@""]) {
        [dic setObject:_endDate forKey:@"endDate"];
    }
    if (![_typeStr isEqualToString:@""]) {
        [dic setObject:_typeStr forKey:@"status"];
    }
    NSLog(@"查询提交字段%@", dic);
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        
        NSMutableArray *content = [NSMutableArray arrayWithArray:responseObject[@"content"]];
        self.dataArray = content;
        [self.tableView reloadData];
        
        if (content.count == 0) {
            [Dialog simpleToast:NoMoreData];
        }
        
        [self hideHud];
    } errorCB:^(NSError *error) {
        
        [self hideHud];
    }];
    
}

- (void)addRefreshAndLoadView
{
    
}

@end
