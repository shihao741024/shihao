//
//  SalesStatisticsSearchViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SalesStatisticsSearchViewController.h"
#import "TextFieldTableViewCell.h"
#import "ProductionsViewController.h"
#import "ProductionModel.h"
#import "ContactViewController.h"
#import "ContactModel.h"
#import "DistriSelectView.h"
#import "OptionSelectDistriViewController.h"
#import "MMDateView.h"
#import "DoctorsModel.h"
#import "CompetitionVC.h"
#import "DistributionView.h"


@interface SalesStatisticsSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MMDateViewDelegate, DistributionViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_placeholderArray;
    
    NSMutableArray *_fillInfoArray;
    ProductionModel *_productModel;
    ContactModel *_contactModel;
    
    NSArray *_allDistriArray;
    DistriSelectView *_distriSelectView;
    NSDictionary *_distriDic;
    
    DoctorsModel *_doctorModel;
//    NSString *_filePath;
    
}

@property (nonatomic, copy) void(^searchParameterCB)(NSDictionary *, NSDictionary *);

@end

@implementation SalesStatisticsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (_type == 0) {
        self.title = @"购进查询";
    }else if (_type == 1) {
        self.title = @"纯销查询";
    }else if (_type == 2) {
        self.title = @"竞销查询";
    }
    
//    [self createFilePath];
    [self createRightItemTitle:@"查询"];
    
    [self dataConfig];
    [self uiConfig];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [Function userDefaultsRemoveObjForKey:@"notResponder"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *costomerArray = [Function userDefaultsObjForKey:@"costomerArray"];
    if (costomerArray) {
        //数组 产品 医院
        if (_type == 0) {
            _productModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[0]];
            _contactModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[1]];
            
            [self fillProductInfo:_productModel];
            [self fillContactInfo:_contactModel];
            
        }else if (_type == 1) {
            _productModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[0]];
            _contactModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[1]];
            _doctorModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[2]];
            [self fillProductInfo:_productModel];
            [self fillContactInfo:_contactModel doctor:_doctorModel];
            
        }else if (_type == 2) {
            _contactModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[1]];
            _doctorModel = [NSKeyedUnarchiver unarchiveObjectWithData:costomerArray[2]];
            [self fillContactInfo:_contactModel doctor:_doctorModel];
        }
        
        [_tableView reloadData];
        [Function userDefaultsRemoveObjForKey:@"costomerArray"];
    }
}

//- (void)createFilePath
//{
//    _filePath = [kMyCaches stringByAppendingPathComponent:@"SaleStatisticsSearch"];
//    [Function fileManagerCreateWithPath:_filePath];
//}

- (void)rightItemTitleClick
{
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    if (_productModel) {
        [muDic setObject:@{@"id":_productModel.productID} forKey:@"production"];
        [saveDic setObject:_productModel forKey:@"production"];
    }
    if (_contactModel) {
        [muDic setObject:@{@"id":_contactModel.hospitalID} forKey:@"hospital"];
        [saveDic setObject:_contactModel forKey:@"hospital"];
    }
    if (_doctorModel) {
        [muDic setObject:@{@"id":_doctorModel.doctorID} forKey:@"doctor"];
        [saveDic setObject:_doctorModel forKey:@"doctor"];
    }
    
    NSInteger beginIndex = [_titleArray indexOfObject:@"上报开始时间："];
    NSInteger endIndex = [_titleArray indexOfObject:@"上报结束时间："];
    if (![_fillInfoArray[beginIndex] isEqualToString:@""]) {
        [muDic setObject:_fillInfoArray[beginIndex] forKey:@"beginDate"];
        [saveDic setObject:_fillInfoArray[beginIndex] forKey:@"beginDate"];
    }
    if (![_fillInfoArray[endIndex] isEqualToString:@""]) {
        [muDic setObject:_fillInfoArray[endIndex] forKey:@"endDate"];
        [saveDic setObject:_fillInfoArray[endIndex] forKey:@"endDate"];
    }
    
    if ((![_fillInfoArray[beginIndex] isEqualToString:@""]) && (![_fillInfoArray[endIndex] isEqualToString:@""])) {
        
        if ([_fillInfoArray[beginIndex] compare:_fillInfoArray[endIndex]] == NSOrderedDescending) {
            [Dialog simpleToast:@"开始时间不能超过结束时间"];
            return;
        }
        
    }

    NSInteger distriIndex = [_titleArray indexOfObject:@"配送商业："];
    if (distriIndex != NSNotFound) {
        if (![_fillInfoArray[distriIndex] isEqualToString:@""]) {
            [muDic setObject:_fillInfoArray[distriIndex] forKey:@"pss"];
            [saveDic setObject:_fillInfoArray[distriIndex] forKey:@"pss"];
        }
    }
    NSLog(@"SalesStatisticsSearchViewController=%@", muDic);
//    if (_type == 0) {
//        NSString *path = [_filePath stringByAppendingPathComponent:@"SaleStatisticsSearchType0"];
//        [Function archiveRootObjectWithPath:path data:saveDic];
//    }else if (_type == 1) {
//        NSString *path = [_filePath stringByAppendingPathComponent:@"SaleStatisticsSearchType1"];
//       [Function archiveRootObjectWithPath:path data:saveDic];
//    }else if (_type == 2) {
//        NSString *path = [_filePath stringByAppendingPathComponent:@"SaleStatisticsSearchType2"];
//        [Function archiveRootObjectWithPath:path data:saveDic];
//    }
    
    _searchParameterCB(muDic, saveDic);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backSearchParameterAction:(void (^)(NSDictionary *, NSDictionary *))action
{
    _searchParameterCB = action;
}

- (void)readSearchHistory:(NSDictionary *)saveDic
{
    _fillInfoArray = [NSMutableArray array];
    if ([saveDic objectForKey:@"production"]) {
        _productModel = saveDic[@"production"];
        NSString *str = [NSString stringWithFormat:@"%@(%@)", _productModel.name, _productModel.specification];
        [_fillInfoArray addObject:str];
    }else {
        [_fillInfoArray addObject:@""];
    }
    
    NSString *customer = @"";
    if ([saveDic objectForKey:@"doctor"]) {
        _doctorModel = saveDic[@"doctor"];
        customer = [customer stringByAppendingString:_doctorModel.name];
    }
    if ([saveDic objectForKey:@"hospital"]) {
        _contactModel = saveDic[@"hospital"];
        if ([customer isEqualToString:@""]) {
            customer = [customer stringByAppendingString:_contactModel.hospitalName];
        }else {
            customer = [customer stringByAppendingFormat:@" / %@", _contactModel.hospitalName];
        }
        [_fillInfoArray addObject:customer];
    }else {
        [_fillInfoArray addObject:@""];
    }
    
    if (_type != 1) {
        if ([saveDic objectForKey:@"pss"]) {
            [_fillInfoArray addObject:saveDic[@"pss"]];
        }else {
            [_fillInfoArray addObject:@""];
        }
    }
    
    if ([saveDic objectForKey:@"beginDate"]) {
        [_fillInfoArray addObject:saveDic[@"beginDate"]];
    }else {
        [_fillInfoArray addObject:@""];
    }
    if ([saveDic objectForKey:@"endDate"]) {
        [_fillInfoArray addObject:saveDic[@"endDate"]];
    }else {
        [_fillInfoArray addObject:@""];
    }
    
}

//- (NSDictionary *)searchCacheFileExist
//{
//    NSString *fileName = [NSString stringWithFormat:@"SaleStatisticsSearchType%ld", _type];
//    NSString *path = [_filePath stringByAppendingPathComponent:fileName];
//    NSDictionary *dic = [Function unarchiveObjectWithFile:path];
//    
//    return dic;
//}

- (void)dataConfig
{
//    NSDictionary *cacheFile = [self searchCacheFileExist];
    if (_type == 0) {
        _titleArray = @[@"产品名称：", @"选择客户：", @"配送商业：", @"上报开始时间：", @"上报结束时间："];
        _placeholderArray = @[@"请选择产品", @"请选择客户", @"填写配送商业或点击按钮", @"", @""];
        if (_saveDic) {
            [self readSearchHistory:_saveDic];
        }else {
            _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @""]];
        }
        
        [self getDistriInfo];
        
    }else if (_type == 1) {
        _titleArray = @[@"产品名称：", @"选择客户：", @"上报开始时间：", @"上报结束时间："];
        _placeholderArray = @[@"请选择产品", @"请选择客户", @"", @""];
        
        if (_saveDic) {
            [self readSearchHistory:_saveDic];
        }else {
            _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
        }
        
        
    }else if (_type == 2) {
        _titleArray = @[@"产品名称：", @"选择客户：", @"配送商业：", @"上报开始时间：", @"上报结束时间："];
        _placeholderArray = @[@"请选择产品", @"请选择客户", @"填写配送商业或点击按钮", @"", @""];
        if (_saveDic) {
            [self readSearchHistory:_saveDic];
        }else {
            _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @""]];
        }
        
        [self getDistriInfo];
    }
    
}

- (void)getDistriInfo
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/distri"];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        _allDistriArray = [NSArray arrayWithArray:responseObject];
    } errorCB:^(NSError *error) {
        
    }];
}


- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
- (void)addChooseButton:(UITableViewCell *)cell
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    button.frame = CGRectMake(kWidth-10-30, 0, 30, 44);
    [button addTarget:self action:@selector(chooseBusinessClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 21547;
    button.titleLabel.font = GDBFont(15);
    [cell.contentView addSubview:button];
}

- (void)chooseBusinessClick:(UIButton *)button
{
    [self.view endEditing:YES];
    if (_contactModel == nil) {
        [Dialog simpleToast:@"请先选择医院"];
    }else {
        /*
        NSInteger index = [_titleArray indexOfObject:@"配送商业："];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        OptionSelectDistriViewController *optionDistriCtrl = [[OptionSelectDistriViewController alloc] init];
        optionDistriCtrl.contactModel = _contactModel;
        [self.navigationController pushViewController:optionDistriCtrl animated:YES];
        
        [optionDistriCtrl selectedDistriDicAction:^(NSDictionary *distriDic) {
            _distriDic = distriDic;
            [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:_distriDic[@"vendor"]];
            [_tableView reloadData];
        }];
         */
        
        DistributionView *distributionView = [[DistributionView alloc]initWithFrame:CGRectZero provincial:_contactModel.provincial city:_contactModel.city];
        distributionView.delegate = self;
        [self.view addSubview:distributionView];
    }
}

- (void)selectPss:(NSString*)pss
{
    NSInteger index = [_titleArray indexOfObject:@"配送商业："];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    _distriDic = @{@"vendor": pss};
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:_distriDic[@"vendor"]];
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        [cell.textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.delegate = self;
        cell.textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        
        cell.titleLabel.frame = CGRectMake(15, 0, 105, 44);
        cell.lineView.hidden = YES;
        
        [self addChooseButton:cell];
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.textField.text = _fillInfoArray[indexPath.row];
    cell.textField.placeholder = _placeholderArray[indexPath.row];
    
    UIView *view = [cell.contentView viewWithTag:21547];
    if ([_titleArray[indexPath.row] isEqualToString:@"配送商业："]) {
        view.hidden = NO;
        cell.textField.frame = CGRectMake(120, 0, kWidth-120-10-30, 44);
    }else {
        view.hidden = YES;
        cell.textField.frame = CGRectMake(120, 0, kWidth-120, 44);
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)fillProductInfo:(ProductionModel *)model
{
    NSInteger index = [_titleArray indexOfObject:@"产品名称："];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSString *str = [NSString stringWithFormat:@"%@(%@)", model.name, model.specification];
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:str];
    
}

- (void)fillContactInfo:(ContactModel *)model
{
    NSInteger index = [_titleArray indexOfObject:@"选择客户："];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:model.hospitalName];
    
}

- (void)fillContactInfo:(ContactModel *)contactModel doctor:(DoctorsModel *)doctorModel
{
    NSInteger index = [_titleArray indexOfObject:@"选择客户："];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSString *textStr = [NSString stringWithFormat:@"%@ / %@", doctorModel.name, contactModel.hospitalName];
    
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:textStr];
}

- (void)showSelectDate:(NSIndexPath *)indexPath searchTime:(NSString *)searchTime
{
    MMDateView *dateView = [MMDateView new];
    dateView.delegate=self;
    dateView.datePicker.tag=5;
    dateView.customIndexPath = indexPath;
    dateView.searchTime = searchTime;
    dateView.datePicker.datePickerMode = UIDatePickerModeDate;
    [dateView showWithBlock:nil];
    
    if ([searchTime isEqualToString:@"start"]) {
        dateView.centerLabel.text = @"上报开始时间";
    }else {
        dateView.centerLabel.text = @"上报结束时间";
    }
    
}

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker
{
    MMDateView *dateView = (MMDateView *)picker.superview;
    NSIndexPath *indexPath = dateView.customIndexPath;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:picker.date];
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:dateStr];
    [_tableView reloadData];
}

- (void)showProductionsCtrl:(NSIndexPath *)indexPath
{
    if (_type == 2) {
        CompetitionVC *competitionVC = [[CompetitionVC alloc]init];
        [self.navigationController pushViewController:competitionVC animated:YES];
        [competitionVC setFeedBackProductionModelBlock:^(ProductionModel *model) {
            _productModel = model;
            [self fillProductInfo:model];
            [_tableView reloadData];
        }];
    }else {
        ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
        productionsVC.type = 0;
        [self.navigationController pushViewController:productionsVC animated:YES];
        [productionsVC setFeedBackProductionModelBlock:^(ProductionModel *model) {
            _productModel = model;
            [self fillProductInfo:model];
            [_tableView reloadData];
        }];
    }
}

- (void)showDistriSelectView:(NSString *)text
{
    NSInteger index = [_titleArray indexOfObject:@"配送商业："];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (_distriSelectView == nil) {
        _distriSelectView = [[DistriSelectView alloc] initWithFrame:CGRectMake(120, 44*(indexPath.row+1), 190, 30*5) titleArray:nil];
        [_tableView addSubview:_distriSelectView];
        
        [_distriSelectView selectedIndexPathAction:^(NSIndexPath *selectIndexPath) {
            _distriDic = _distriSelectView.titleArray[selectIndexPath.row];
            _distriSelectView.hidden = YES;
            [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:_distriDic[@"vendor"]];
            [_tableView reloadData];
        }];
    }
    
    if ([text isEqualToString:@""]) {
        _distriSelectView.hidden = YES;
    }else {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in _allDistriArray) {
            NSRange range = [dic[@"vendor"] rangeOfString:text];
            if (range.location != NSNotFound) {
                [array addObject:dic];
            }
        }
        
        if (array.count == 0) {
            _distriSelectView.hidden = YES;
        }else {
            _distriSelectView.hidden = NO;
        }
        [_distriSelectView realoadDataWithArray:array];
    }
    
}

- (void)showHospitalCtrl:(NSIndexPath *)indexPath
{
    if (_type == 2) {
        ContactViewController *contactVC = [[ContactViewController alloc]init];
        contactVC.type = 5;
        [self.navigationController pushViewController:contactVC animated:YES];
    }else {
        if (_productModel) {
            
            ContactViewController *contactVC = [[ContactViewController alloc]init];
            if (_type == 0) {
                contactVC.type = 3;
            }else if (_type == 1) {
                contactVC.type = 4;
            }
            contactVC.productModel = _productModel;
            [self.navigationController pushViewController:contactVC animated:YES];
            
        }else {
            
            ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
            if (_type == 0) {
                productionsVC.type = 1;
            }else if (_type == 1) {
                productionsVC.type = 2;
            }
            [self.navigationController pushViewController:productionsVC animated:YES];
        }
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldTextChanged:(UITextField *)textField
{
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    
    if ([_titleArray[indexPath.row] isEqualToString:@"配送商业："]) {
        [self showDistriSelectView:textField.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    if ([Function userDefaultsObjForKey:@"notResponder"]) {
        [Function userDefaultsRemoveObjForKey:@"notResponder"];
        return NO;
    }
    
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    if ([_titleArray[indexPath.row] isEqualToString:@"产品名称："]) {
        [self showProductionsCtrl:indexPath];
        return NO;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"选择客户："]) {
        [self showHospitalCtrl:indexPath];
        return NO;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"上报开始时间："]) {
        [self showSelectDate:indexPath searchTime:@"start"];
        return NO;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"上报结束时间："]) {
        [self showSelectDate:indexPath searchTime:@"end"];
        return NO;
    }else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    CGPoint point = [cell convertPoint:cell.textField.center toView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"cell.frame.origin.y%f",point.y);
    
    float currentY = kHeight - (point.y+22);
    if (currentY < 290) {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, 64-((285-currentY)), kWidth, kFrameH(_tableView));
        }];
    }
    
    if ([_titleArray[indexPath.row] isEqualToString:@"配送商业："]) {
        [self showDistriSelectView:textField.text];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
    }];
    
    _distriSelectView.hidden = YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{   [Function userDefaultsSetObj:@"1" forKey:@"notResponder"];
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    if ([_titleArray[indexPath.row] isEqualToString:@"产品名称："]) {
        _productModel = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"选择客户："]) {
        _contactModel = nil;
        _doctorModel = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"配送商业："]) {
        _distriDic = nil;
    }else if ([_titleArray[indexPath.row] isEqualToString:@"上报开始时间："]) {
        
    }else if ([_titleArray[indexPath.row] isEqualToString:@"上报结束时间："]) {
        
    }else {
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
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
