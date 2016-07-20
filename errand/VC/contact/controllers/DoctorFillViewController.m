//
//  DoctorFillViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DoctorFillViewController.h"
#import "TextFieldTableViewCell.h"
#import "MMDateView.h"

@interface DoctorFillViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MMDateViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_titleArray;
    NSMutableArray *_fillInfoArray;
    
    NSDictionary *_resultDic;
    NSIndexPath *_dateIndexPath;
}


@property (nonatomic, copy) void(^updateInfoSuccessCB)();

@end

@implementation DoctorFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生信息完善";
    [self addBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createRightItemTitle:@"提交"];
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
}

- (void)dataConfig
{
    _titleArray = nil;
    _fillInfoArray = nil;
    
    _titleArray = [NSMutableArray arrayWithArray:@[@"出生年月：", @"邮箱：", @"家庭住址：", @"毕业学院：", @"身份证：", @"深灰任职：", @"研究领域：", @"文献：", @"特长：", @"行业认资：", @"行政职务："]];
    
    _fillInfoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""]];
    
}

- (void)rightItemTitleClick
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (![Function isBlankStrOrNull:_fillInfoArray[0]]) {
        [dic setObject:_fillInfoArray[0] forKey:@"birthday"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[1]]) {
        [dic setObject:_fillInfoArray[1] forKey:@"email"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[2]]) {
        [dic setObject:_fillInfoArray[2] forKey:@"address"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[3]]) {
        [dic setObject:_fillInfoArray[3] forKey:@"school"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[4]]) {
        [dic setObject:_fillInfoArray[4] forKey:@"card"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[5]]) {
        [dic setObject:_fillInfoArray[5] forKey:@"social"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[6]]) {
        [dic setObject:_fillInfoArray[6] forKey:@"researchField"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[7]]) {
        [dic setObject:_fillInfoArray[7] forKey:@"literature"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[8]]) {
        [dic setObject:_fillInfoArray[8] forKey:@"specialty"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[9]]) {
        [dic setObject:_fillInfoArray[9] forKey:@"qualification"];
    }
    if (![Function isBlankStrOrNull:_fillInfoArray[10]]) {
        [dic setObject:_fillInfoArray[10] forKey:@"position"];
    }
    
    if (![_fillInfoArray[1] isEqualToString:@""]) {
        if (![Function validateEmail:_fillInfoArray[1]]) {
            [Dialog simpleToast:@"邮箱格式不正确"];
            return;
        }
    }
    
    if (![_fillInfoArray[4] isEqualToString:@""]) {
        if (![Function validateIDCard:_fillInfoArray[4]]) {
            [Dialog simpleToast:@"身份证格式不正确"];
            return;
        }
    }
    
    
    [self updateInfoWithDic:dic];
    
}

- (void)updateInfoWithDic:(NSDictionary *)dic
{
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/doctors/complete/%@", _doctorID];
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        _updateInfoSuccessCB();
        [self.navigationController popViewControllerAnimated:YES];
        
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)updateInfoSuccessAction:(void (^)())action
{
    _updateInfoSuccessCB = action;
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.separatorStyle = 0;
    
}

- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/doctors/%@",_doctorID];
    [self showHintInView:self.view];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        [self hideHud];
        [self configResult:responseObject];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)configResult:(id)responseObject
{
    _resultDic = responseObject;
    
    
    //可以在客户端更改
    
    if (_resultDic[@"birthday"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:0 withObject:_resultDic[@"birthday"]];
    }
    if (_resultDic[@"email"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:1 withObject:_resultDic[@"email"]];
    }
    if (_resultDic[@"address"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:2 withObject:_resultDic[@"address"]];
    }
    if (_resultDic[@"school"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:3 withObject:_resultDic[@"school"]];
    }
    if (_resultDic[@"card"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:4 withObject:_resultDic[@"card"]];
    }
    if (_resultDic[@"social"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:5 withObject:_resultDic[@"social"]];
    }
    if (_resultDic[@"researchField"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:6 withObject:_resultDic[@"researchField"]];
    }
    if (_resultDic[@"literature"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:7 withObject:_resultDic[@"literature"]];
    }
    if (_resultDic[@"specialty"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:8 withObject:_resultDic[@"specialty"]];
    }
    if (_resultDic[@"qualification"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:9 withObject:_resultDic[@"qualification"]];
    }
    if (_resultDic[@"position"] != [NSNull null]) {
        [_fillInfoArray replaceObjectAtIndex:10 withObject:_resultDic[@"position"]];
    }
   
    
    
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.textField.text = _fillInfoArray[indexPath.row];
    
    
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

- (void)showSelectDate:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    MMDateView *dateView = [MMDateView new];
    dateView.delegate=self;
    dateView.datePicker.tag=5;
    dateView.datePicker.datePickerMode = UIDatePickerModeDate;
    [dateView showWithBlock:nil];
    _dateIndexPath = indexPath;
    
}

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:picker.date];
    
    [_fillInfoArray replaceObjectAtIndex:_dateIndexPath.row withObject:dateStr];
    [_tableView reloadData];
}

- (void)textFieldTextChanged:(UITextField *)textField
{
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    [_fillInfoArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        [self showSelectDate:indexPath];
        return NO;
    }else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    TextFieldTableViewCell *cell = iOSVersion >= 8.0 ? (TextFieldTableViewCell *)textField.superview.superview: (TextFieldTableViewCell *)textField.superview.superview.superview;
    
    
    CGPoint point = [cell convertPoint:cell.textField.center toView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"cell.frame.origin.y%f",point.y);
    
    float currentY = kHeight - (point.y+22);
    if (currentY < 290) {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, 64-((285-currentY)), kWidth, kFrameH(_tableView));
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64);
    }];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
