//
//  SearchTaskVC.m
//  errand
//
//  Created by gravel on 16/3/15.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchTaskVC.h"
#import "TaskEditTableViewCell.h"
#import "MMDateView.h"
#import "MMChoiceOneView.h"
#import "SelectDepartmentVC.h"
#import "SelectStaffViewController.h"
#import "StaffModel.h"
#import "Node.h"
#import "FirstOrganizationalVC.h"

@interface SearchTaskVC ()<UITableViewDelegate,UITableViewDataSource,MMDateViewDelegate,MMChoiceViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,WJJLabelDelegate>

@end

@implementation SearchTaskVC{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UITextField *_keywordField;
    UITextField *_contentField;
    NSArray *_categoryArray;
    int category;
    //选中的部门
    NSMutableArray *_departmentSelectArray;
    NSMutableArray *_staffSelectArray;
    
    NSNumber *_staffID;
    
     BOOL hasSearchArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_searchArray.count > 0) {
        
        hasSearchArray = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)createRightItem{
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = NSLocalizedString(@"high-search", @"high-search");
    [self addBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"search", @"search") style:UIBarButtonItemStyleDone target:self action:@selector(searchClick)];
}
- (void)searchClick{
   
    TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *staffName = cell3.detailLabel.text;
    
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *beginDate = cell.detailLabel.text;
    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *endDate = cell2.detailLabel.text;
    
    if ((![beginDate isEqualToString:@""]) && (![endDate isEqualToString:@""])) {
        if ([beginDate compare:endDate] == NSOrderedDescending) {
            [Dialog simpleToast:@"开始时间不能超过结束时间"];
            return;
        }
    }
    
    TaskEditTableViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *kindStr = cell4.detailLabel.text;
    
    [self.navigationController popViewControllerAnimated:YES];
    self.feedBackTaskSearchDataBlock([NSNumber numberWithInt:category],beginDate,endDate,_contentField.text,_keywordField.text,_staffID,staffName,kindStr);
    
}
- (void)createTextField{
    UITextField *titleField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    titleField.textColor = COMMON_FONT_BLACK_COLOR;
    titleField.clearButtonMode = UITextFieldViewModeAlways;
    titleField.font = [UIFont systemFontOfSize:14];
    titleField.placeholder = @"请输入标题关键字";
    _keywordField= titleField;
    
    UITextField *contentField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    contentField.textColor = COMMON_FONT_BLACK_COLOR;
    contentField.clearButtonMode = UITextFieldViewModeAlways;
    contentField.font = [UIFont systemFontOfSize:14];
    contentField.placeholder = @"请输入内容关键字";
    _contentField = contentField;
}
- (void)initView{
    
    [self createTextField];
    
    _categoryArray = @[@"待接收",@"已接收",@"已拒绝",@"已完成",@"已过期",@"已取消"];
    //区分没有这两个搜索条件的时候
    category = ImpossibleNumber;
    _staffID = [NSNumber numberWithInt:ImpossibleNumber];
    if (_type == 0) {
        NSArray *dataArray = @[NSLocalizedString(@"title", @"title"), NSLocalizedString(@"content", @"content"), NSLocalizedString(@"receiver", @"receiver"),NSLocalizedString(@"startTime", @"startTime"), @"结束时间", @"类型:"];
         _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }else{
        NSArray *dataArray = @[NSLocalizedString(@"title", @"title"), NSLocalizedString(@"content", @"content"), NSLocalizedString(@"releaser", @"releaser"),NSLocalizedString(@"startTime", @"startTime"), @"结束时间", @"类型:"];
         _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    
   
    _departmentSelectArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TaskEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.detailLabel.delegate = self;
//    (^feedBackTaskSearchDataBlock)( 1 NSNumber *category, 2 NSString *beginDate, 3 NSString *endDate, 4 NSString *content, 5 NSString *title, 6 NSNumber *to, 7 NSString *staffName, 8 NSString *kindStr);
    //如果搜索的数组有值，那就加在视图上
    if (hasSearchArray == YES) {
        if (indexPath.row == 0) {
            [cell addSubview:_keywordField];
            _keywordField.text = _searchArray[4];
        }
        if (indexPath.row == 1) {
            [cell addSubview:_contentField];
            _contentField.text = _searchArray[3];
        }
        if (indexPath.row == 2) {
            [cell.detailLabel setTextWithString:_searchArray[6] andIndex:indexPath.row];
            _staffID = _searchArray[5];
        }
        if (indexPath.row == 3) {
             [cell.detailLabel setTextWithString:_searchArray[1] andIndex:indexPath.row];
            
        }
        if (indexPath.row == 4) {
             [cell.detailLabel setTextWithString:_searchArray[2] andIndex:indexPath.row];
           
        }
        if (indexPath.row == 5) {
             [cell.detailLabel setTextWithString:_searchArray[7] andIndex:indexPath.row];
            
            category = [_searchArray[0] intValue];
        }
    }
    else{
        if (indexPath.row == 0) {
            [cell addSubview:_keywordField];
        }
        if (indexPath.row == 1) {
            [cell addSubview:_contentField];
        }
    }
    
    cell.nameLabel.text = _dataArray[indexPath.row];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.item) {
        
        case 2:{
            if (_type == 0) {
                SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
                vc.type = 0;
                vc.taskSearchPeople = YES;
                vc.subordinateLayout = YES;
                [self.navigationController pushViewController:vc animated:YES];
                vc.selectstaffBlock = ^(StaffModel *model){
                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                     [cell.detailLabel setTextWithString:model.staffName andIndex:indexPath.row];
                   
                    _staffID = [NSNumber numberWithInt:[model.ID intValue]];
                };
            }else{
                
                SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
                vc.type = 0;
                vc.taskSearchPeople = YES;
                vc.subordinateLayout = YES;
                [self.navigationController pushViewController:vc animated:YES];
                vc.selectstaffBlock = ^(StaffModel *model){
                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    [cell.detailLabel setTextWithString:model.staffName andIndex:indexPath.row];
                    
                    _staffID = [NSNumber numberWithInt:[model.ID intValue]];
                };
//                FirstOrganizationalVC *organizationVC = [[FirstOrganizationalVC alloc]init];
//                organizationVC.type =2;
//                [self.navigationController pushViewController:organizationVC animated:YES];
//                organizationVC.feedBackStaffInfoBlock = ^(NSString *staffName,NSNumber *staffID){
//                    
//                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                   [cell.detailLabel setTextWithString:staffName andIndex:indexPath.row];
//                    _staffID = [NSNumber numberWithInt:[staffID intValue]];
//                };
            }
            
            break;
        }
    
        case 3: {
            [self.view endEditing:YES];
            MMDateView *dateView = [MMDateView new];
            dateView.datePicker.datePickerMode =  UIDatePickerModeDate;
            dateView.centerLabel.text = @"开始时间";
            dateView.delegate=self;
            dateView.datePicker.tag=1;
            [dateView showWithBlock:nil];
            
        }
            break;
            
        case 4: {
            [self.view endEditing:YES];
            MMDateView *dateView = [MMDateView new];
            dateView.datePicker.datePickerMode =  UIDatePickerModeDate;
            dateView.centerLabel.text = @"结束时间";
            dateView.delegate=self;
            dateView.datePicker.tag=2;
            [dateView showWithBlock:nil];
        }
            break;
            
        case 5:{
            [self.view endEditing:YES];
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 1;
            choiceView.pickerView.delegate = self;
            choiceView.pickerView.dataSource = self;
            choiceView.delegate = self;
            [choiceView showWithBlock:nil];
        }break;
        default:
            break;
    }
    
}
#pragma mark --- UIPickerView
-(void)MMChoiceViewChoiced:(UIPickerView*)picker{
    int row =(int) [picker selectedRowInComponent:0];
    //    0 待接收 1 已接受  3拒绝 99已完成 -1 过期 -2取消
    if (row == 2) {
        category = 3;
    }else if (row == 3){
         category = 99;
    }else if (row == 4){
        category = -1;
    }else if (row == 5){
        category = -2;
    }else{
        category = row;
    }
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell.detailLabel setTextWithString:_categoryArray[row] andIndex:indexPath.row];
}
// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    return  _categoryArray.count;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  _categoryArray[row];
    
}
#pragma mark - MMChoiceDateViewChoicedDelegate

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker{
    
    if(picker.tag==1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:strDate andIndex:indexPath.row];
    }
    if (picker.tag == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        NSUserDefaults *VisitDate = [NSUserDefaults standardUserDefaults];
        [VisitDate setObject:strDate forKey:@"visitDate"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:strDate andIndex:indexPath.row];
    }
}

#pragma mark - WJJLabelDelegate
- (void)changeDataSourceWithIndex:(NSInteger)index {
    
    if (index == 2){
        _staffID = [NSNumber numberWithInt:ImpossibleNumber];
    }else if (index == 5){
        category = ImpossibleNumber;
        
    }
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
