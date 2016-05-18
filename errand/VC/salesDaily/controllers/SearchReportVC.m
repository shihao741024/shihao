//
//  SearchReportVC.m
//  errand
//
//  Created by gravel on 16/3/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchReportVC.h"
#import "TaskEditTableViewCell.h"
#import "MMDateView.h"
#import "MMChoiceOneView.h"
#import "SelectDepartmentVC.h"
#import "SelectStaffViewController.h"
#import "StaffModel.h"
#import "Node.h"

@interface SearchReportVC ()<UITableViewDelegate,UITableViewDataSource,MMDateViewDelegate,MMChoiceViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, WJJLabelDelegate>

@end

@implementation SearchReportVC{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    //加在cell上的控件
    UITextField *_keywordField;
    UIButton *_clearBeginDateBtn;
    UIButton *_clearEndDateBtn;
    UIButton *_categoryBtn;
    
    NSArray *_categoryArray;
    int category;
    //选中的部门
    NSMutableArray *_departmentSelectArray;
    NSMutableArray *_staffSelectArray;
    
    //选中部门id的数组
    NSMutableArray *_oids;
    //选中员工id的数组
    NSMutableArray *_ids;
    
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
    
    NSNotification *notice = [NSNotification notificationWithName:@"notice" object:@"1111"];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    _staffSelectArray = [NSMutableArray array];
    
    [self createRightItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)clear:(UIButton *)clearBtn{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reciveNotice:) name:@"notice" object:nil];
    
}

- (void)reciveNotice:(NSNotification *)notification{
    
    NSLog(@"收到消息啦!!!");
    
}
- (void)createRightItem{
    
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = NSLocalizedString(@"high-search", @"high-search");
    [self addBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"search", @"search") style:UIBarButtonItemStyleDone target:self action:@selector(searchClick)];
}
- (void)searchClick{
   
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NSString *beginDate = cell.detailLabel.text;
        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        NSString *endDate = cell2.detailLabel.text;
    
    if ((![beginDate isEqualToString:@""]) && (![endDate isEqualToString:@""])) {
        if ([beginDate compare:endDate] == NSOrderedDescending) {
            [Dialog simpleToast:@"开始时间不能超过结束时间"];
            return;
        }
    }
    
        TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *department = cell3.detailLabel.text;
        
        TaskEditTableViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        NSString *publisher = cell4.detailLabel.text;
        
        TaskEditTableViewCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        NSString *kindStr = cell5.detailLabel.text;
        
        [self.navigationController popViewControllerAnimated:YES];
        self.feedBackHallSearchDataBlock([NSNumber numberWithInt:category],beginDate,endDate,_keywordField.text,_oids,_ids,publisher,kindStr,_staffSelectArray);
   

}
- (void)createTextField{
    
    UITextField *titleField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    titleField.textColor = COMMON_FONT_BLACK_COLOR;
    titleField.clearButtonMode = UITextFieldViewModeAlways;
    titleField.font = [UIFont systemFontOfSize:14];
    _keywordField= titleField;
    
}

- (void)clearBtn:(UIButton*)clearBtn{
    if (clearBtn.tag == 0) {
        _keywordField.text = @"";
    }else if (clearBtn.tag == 1){
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailLabel.text = @"";
        [_oids removeAllObjects];
    }else if (clearBtn.tag == 2){
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.detailLabel.text = @"";
        [_ids removeAllObjects];
    }else if (clearBtn.tag == 3){
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.detailLabel.text = @"";
    }else if (clearBtn.tag == 4){
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        cell.detailLabel.text = @"";
    }else if (clearBtn.tag == 5){
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        cell.detailLabel.text = @"";
        category = -1;
    }
}

- (void)initView{
    
    //数组初始化
        _oids = [NSMutableArray array];
        _ids = [NSMutableArray array];
        category = -1;
     _categoryArray = @[NSLocalizedString(@"dailyRecord",@"dailyRecord"),NSLocalizedString(@"weekRecord",@"weekRecord"),NSLocalizedString(@"monthRecord",@"monthRecord"),NSLocalizedString(@"share",@"share"), @"拜访"];
    
    NSArray *dataArray = @[NSLocalizedString(@"keyword", @"keyword"), NSLocalizedString(@"publisher", @"publisher"),NSLocalizedString(@"startTime", @"startTime"), @"结束时间:", @"类型:"];
     _dataArray = [NSMutableArray arrayWithArray:dataArray];
    _departmentSelectArray = [NSMutableArray array];
    
      [self createTextField];
    
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
        cell.detailLabel.delegate = self;
    }
    
//   _searchArray = @[0category,1beginDate,2endDate,3content,4oids,5ids,6publisher,7kindStr,8staffModelArray];
    //如果搜索的数组有值，那就加在视图上
    if (hasSearchArray == YES) {
        if (indexPath.row == 0) {
            [cell addSubview:_keywordField];
            _keywordField.text = _searchArray[3];
        }
        if (indexPath.row == 1) {
            [cell.detailLabel setTextWithString:_searchArray[6] andIndex:indexPath.item];
            _oids = _searchArray[4];
            _staffSelectArray = _searchArray[8];
        }
        if (indexPath.row == 2) {
            [cell.detailLabel setTextWithString:_searchArray[1] andIndex:indexPath.item];
//            [cell.detailLabel setTextWithString:_searchArray[7] andIndex:indexPath.item];
            _ids = _searchArray[5];
        }
        if (indexPath.row == 3) {
             [cell.detailLabel setTextWithString:_searchArray[2] andIndex:indexPath.item];

        }
        if (indexPath.row == 4) {
            [cell.detailLabel setTextWithString:_searchArray[7] andIndex:indexPath.item];
            category = [_searchArray[0] intValue];

        }
//        if (indexPath.row == 5) {
//            [cell.detailLabel setTextWithString:_searchArray[8] andIndex:indexPath.item];
//            category = [_searchArray[0] intValue];
//
//        }
    }
    else{
        if (indexPath.row == 0) {
            [cell addSubview:_keywordField];
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
    [self.view endEditing:YES];
    switch (indexPath.item) {
        case 0: {
            //跳转到选择部门的页面
            SelectDepartmentVC *vc = [[SelectDepartmentVC alloc]init];
            vc.type = 1;
            vc.departmentSelectArray = [NSMutableArray arrayWithArray:_departmentSelectArray];
            [self.navigationController pushViewController:vc animated:YES];

            vc.departmentSelectArrayBlock = ^(NSMutableArray *selectArray){
                
                 TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                
                _departmentSelectArray = selectArray;
                
                _oids = [NSMutableArray array];
                
                for (Node *node in _departmentSelectArray) {
                    [_oids addObject:[NSNumber numberWithInt:node.nodeId]];
                }
                
                if (_departmentSelectArray.count == 0) {
                    [cell.detailLabel setTextWithString:@"" andIndex:indexPath.item];
                }else if (_departmentSelectArray.count == 1) {
                    [cell.detailLabel setTextWithString:[selectArray[0] name] andIndex:indexPath.item];

                }else{
                    [cell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@等%lu人",[selectArray[0] name],(unsigned long)selectArray.count] andIndex:indexPath.item];
                }
               
            };

        }
            break;
        case 1:{
            //跳转到选择员工的页面
            SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
            vc.type = 0;
            vc.reportSearchPublish = YES;
            vc.staffModelArray = _staffSelectArray;
            [self.navigationController pushViewController:vc animated:YES];
            
            vc.selectstaffArrayBlock = ^(NSMutableArray *staffSelectArray){
                TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                
                _staffSelectArray = staffSelectArray;
                
                _ids = [NSMutableArray array];
                for (StaffModel *staffModel in _staffSelectArray) {
                    [_ids addObject:[NSNumber numberWithInt:[staffModel.ID intValue]]];
                }

                if (_staffSelectArray.count == 0) {
                    cell.detailLabel.text = @"";
                }else if (_staffSelectArray.count == 1) {
                    [cell.detailLabel setTextWithString:[_staffSelectArray[0] staffName] andIndex:indexPath.item];
                    
                }else{
                    [cell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@等%lu人",[_staffSelectArray[0] staffName],(unsigned long)_staffSelectArray.count] andIndex:indexPath.item];
                }

            };
            break;
        }
            
        case 2: {
            //开始时间
            MMDateView *dateView = [MMDateView new];
            dateView.datePicker.datePickerMode =  UIDatePickerModeDate;
            dateView.centerLabel.text = @"开始时间";
            dateView.delegate=self;
            dateView.datePicker.tag=1;
            [dateView showWithBlock:nil];
            
        }
            break;

        case 3: {
            //结束时间
            MMDateView *dateView = [MMDateView new];
             dateView.datePicker.datePickerMode =  UIDatePickerModeDate;
            dateView.centerLabel.text = @"结束时间";
            dateView.delegate=self;
            dateView.datePicker.tag=2;
            [dateView showWithBlock:nil];
        }
            break;
            
        case 4:{
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
        category = row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:_categoryArray[row] andIndex:indexPath.item];
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
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:strDate andIndex:indexPath.item];
    }
    if (picker.tag == 2) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        NSUserDefaults *VisitDate = [NSUserDefaults standardUserDefaults];
        [VisitDate setObject:strDate forKey:@"visitDate"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:strDate andIndex:indexPath.item];
    }
    
}

#pragma mark - WJJLabelDelegate
- (void)changeDataSourceWithIndex:(NSInteger)index {
    
    if (index == 1) {
        
        [_departmentSelectArray removeAllObjects];
        [_oids removeAllObjects];
        
        [_staffSelectArray removeAllObjects];
        [_ids removeAllObjects];
        
    }else if (index == 2){
        
        [_staffSelectArray removeAllObjects];
        [_ids removeAllObjects];
    }else if (index == 5){
        category = -1;
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
