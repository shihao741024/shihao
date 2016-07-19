//
//  SearchMissionVC.m
//  errand
//
//  Created by wjjxx on 16/3/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchMissionVC.h"
#import "TaskEditTableViewCell.h"
#import "MMDateView.h"
#import "MMChoiceOneView.h"

@interface SearchMissionVC ()<UITableViewDelegate,UITableViewDataSource,MMDateViewDelegate,MMChoiceViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,WJJLabelDelegate>

@end

@implementation SearchMissionVC{
    UITableView  *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray * _heightArray;
   
    
    // 第一层数组，用于存储所有省会级城市字典，应该有31元素，字典内包括省市级城市名及下辖城市数组
    NSArray *provinces, *cities, *areas;
    NSString *_fromStr;
    float _height;
    
    UITextField *_contentField;
    //出行方式
    NSArray *_categoryArray;
    int category;
//    审核状态
    NSArray *_statusArray;
    int status;
    
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
    
    TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *start = cell3.detailLabel.text;
    
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *dest = cell.detailLabel.text;
    
    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *startDate = cell2.detailLabel.text;
    
    TaskEditTableViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *endDate = cell4.detailLabel.text;
    
    if ((![startDate isEqualToString:@""]) && (![endDate isEqualToString:@""])) {
        if ([startDate compare:endDate] == NSOrderedDescending) {
            [Dialog simpleToast:@"开始时间不能超过结束时间"];
            return;
        }
    }
    
    TaskEditTableViewCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *travelStr = cell5.detailLabel.text;

    TaskEditTableViewCell *cell6 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *statusStr = cell6.detailLabel.text;
//  @property (nonatomic, copy)void (^feedBackMissionSearchDataBlock)(NSString *start,NSString *dest,NSString *content,NSString *startDate,NSString *endDate,NSNumber *traveType,NSNumber *status, NSString *traveTypeStr,NSString *statusStr);
    self.feedBackMissionSearchDataBlock(start,dest,_contentField.text,startDate,endDate,[NSNumber numberWithInt:category],[NSNumber numberWithInt:status],travelStr,statusStr);
    [self.navigationController popViewControllerAnimated:YES];
   
    
}
- (void)createTextField{
    
    UITextField *contentField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    contentField.textColor = COMMON_FONT_BLACK_COLOR;
    contentField.clearButtonMode = UITextFieldViewModeAlways;
    contentField.font = [UIFont systemFontOfSize:14];
    contentField.placeholder = @"请输入出差内容关键字";
    _contentField = contentField;
}
- (void)initView{
    
    [self createCitys];
    
    [self createTextField];
    
    _categoryArray = @[@"汽车",@"火车",@"飞机"];
    _statusArray = @[@"待审核",@"审批中",@"已驳回",@"已批准"];
    
    //区分没有这两个搜索条件的时候
    category = ImpossibleNumber;
    status = ImpossibleNumber;
    
    if (_type == 0) {
        NSArray *dataArray = @[NSLocalizedString(@"startPoint:", @"startPoint:"), NSLocalizedString(@"estination:", @"estination:"),NSLocalizedString(@"contentOfBusiness:", @"contentOfBusiness:"), NSLocalizedString(@"startTime:", @"startTime:"), NSLocalizedString(@"endTime:", @"endTime:"), NSLocalizedString(@"wayForBusiness:", @"wayForBusiness:"),NSLocalizedString(@"check_status:", @"check_status:")];
        
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }else{
        NSArray *dataArray = @[NSLocalizedString(@"title", @"title"), NSLocalizedString(@"content", @"content"), NSLocalizedString(@"releaser", @"releaser"),NSLocalizedString(@"startTime", @"startTime"), @"结束时间", NSLocalizedString(@"category", @"category")];
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    
    
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
    //  @property (nonatomic, copy)void (^feedBackMissionSearchDataBlock)(NSString *start,NSString *dest,NSString *content,NSString *startDate,NSString *endDate,NSNumber *traveType,NSNumber *status, NSString *traveTypeStr,NSString *statusStr);

    //如果搜索的数组有值，那就加在视图上
    if (hasSearchArray == YES) {
        if (indexPath.row == 0) {
            [cell.detailLabel setTextWithString:_searchArray[0] andIndex:indexPath.row];
        }
        if (indexPath.row == 1) {
            [cell.detailLabel setTextWithString:_searchArray[1] andIndex:indexPath.row];
        }
        if (indexPath.row == 2) {
            [cell addSubview:_contentField];

            _contentField.text = _searchArray[2];
           
        }
        if (indexPath.row == 3) {
            
            [cell.detailLabel setTextWithString:_searchArray[3] andIndex:indexPath.row];
            
        }
        if (indexPath.row == 4) {
            [cell.detailLabel setTextWithString:_searchArray[4] andIndex:indexPath.row];
            
        }
        if (indexPath.row == 5) {
            [cell.detailLabel setTextWithString:_searchArray[7] andIndex:indexPath.row];
            
            category = [_searchArray[5] intValue];
        }
        if (indexPath.row == 6) {
            
            [cell.detailLabel setTextWithString:_searchArray[8] andIndex:indexPath.row];
            status = [_searchArray[6] intValue];
        }
    }
    else{
        
        if (indexPath.row == 2) {
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
    
    [self.view endEditing:YES];
    switch (indexPath.item) {
        case 0:{
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 4;
            choiceView.pickerView.delegate = self;
            choiceView.pickerView.dataSource = self;
            choiceView.delegate = self;
            [choiceView showWithBlock:nil];
        }break;
        case 1:{
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 5;
            choiceView.pickerView.delegate = self;
            choiceView.pickerView.dataSource = self;
            choiceView.delegate = self;
            [choiceView showWithBlock:nil];
            
        }break;
        case 3:
        {
            [self.view endEditing:YES];
            MMDateView *dateView = [MMDateView new];
            dateView.centerLabel.text = @"开始时间";
            dateView.delegate=self;
            dateView.datePicker.tag=1;
            dateView.datePicker.datePickerMode = UIDatePickerModeDate;
            [dateView showWithBlock:nil];
            
        }break;
        case 4:{
            [self.view endEditing:YES];
            MMDateView *dateView = [MMDateView new];
            dateView.centerLabel.text = @"结束时间";
            dateView.delegate=self;
            dateView.datePicker.tag=2;
            dateView.datePicker.datePickerMode = UIDatePickerModeDate;
            [dateView showWithBlock:nil];
        }break;
        case 5:{
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 3;
            choiceView.pickerView.delegate = self;
            choiceView.pickerView.dataSource = self;
            choiceView.delegate = self;
            [choiceView showWithBlock:nil];
            
        }break;
        case 6:
        {
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 6;
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
    if (picker.tag == 3) {
        int row =(int) [picker selectedRowInComponent:0];
        category = row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:_categoryArray[row] andIndex:indexPath.row];
        
    }else if (picker.tag == 6){
        int row =(int) [picker selectedRowInComponent:0];
        //    99终审 90审核并上报  0 待审核 -1审核不通过 @[@"待审核",@"审批中",@"已驳回",@"已批准"];
        if (row == 0) {
            status = 0;
        }else if (row == 1){
            status = 90;
        }else if (row == 2){
            status = -1;
        }else if (row == 3){
            status = 99;
        }
    
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:_statusArray[row] andIndex:indexPath.row];
    }
    else if (picker.tag == 4){
        int row1 =(int) [picker selectedRowInComponent:0];
        int row2 =(int) [picker selectedRowInComponent:1];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (row1 > 3) {
            [cell.detailLabel setTextWithString:provinces[row1][@"cities"][row2][@"city"] andIndex:indexPath.row];
            
        }else{
             [cell.detailLabel setTextWithString:provinces[row1][@"state"] andIndex:indexPath.row];
        }
        _fromStr = cell.detailLabel.text;
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        [picker selectRow:0 inComponent:1 animated:YES];
        [picker reloadComponent:1];
    }else{
        int row1 =(int) [picker selectedRowInComponent:0];
        int row2 =(int) [picker selectedRowInComponent:1];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (row1 > 3) {
            [cell.detailLabel setTextWithString:provinces[row1][@"cities"][row2][@"city"] andIndex:indexPath.row];

        }else{
            [cell.detailLabel setTextWithString:provinces[row1][@"state"] andIndex:indexPath.row];

        }
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        [picker selectRow:0 inComponent:1 animated:YES];
        [picker reloadComponent:1];
    }
    
}
// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if (pickerView.tag == 3) {
        return  1;
    }else if (pickerView.tag == 6){
        return 1;
    }
    else {
        return 2;
    }
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 3) {
        return  _categoryArray.count;
    }else if (pickerView.tag == 6){
        return _statusArray.count;
    }
    else {
        switch (component) {
            case 0:
                return [provinces count];
                break;
            case 1:
                return [cities count];
                break;
                
            default:
                break;
        }
    }
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 3) {
        return  _categoryArray[row];
    }else if (pickerView.tag == 6){
        return _statusArray[row];
    }
    else {
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"city"];
                break;
                
            default:
                return  @"";
                break;
        }
    }
    return  _categoryArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 4||pickerView.tag == 5) {
        switch (component) {
            case 0:{
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView reloadComponent:1];
                
                break;
            }
                
            default:
                break;
        }
        
    }
}

#pragma mark - MMChoiceDateViewChoicedDelegate

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker{
    
    if(picker.tag==1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        NSString *weekStr = [self weekdayStringFromDate:picker.date];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
          [cell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@%@%@",strDate,@"  ",weekStr] andIndex:indexPath.row];
    }
    if(picker.tag==2){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        NSString *weekStr = [self weekdayStringFromDate:picker.date];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
         [cell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@%@%@",strDate,@"  ",weekStr] andIndex:indexPath.row];
    }
    
}

- (void)createCitys{
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    // 第一层数组，用于存储所有省会级城市字典，应该有31元素，字典内包括省市级城市名及下辖城市数组
    NSMutableArray *rootArray = [NSMutableArray array];
    // 文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
    // 转换成data
    NSData *fileData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:nil];
    // 再将data转换成字典
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    // 取出所有省市级城市名
    NSArray *stateArray = dic[@"name0"];
    // 取出所有省市级城市名对应code
    NSArray *stateCodeArray = dic[@"code0"];
    
    // 第一层解析，获得省市级城市名及其下辖城市数组
    for (int i = 0; i < stateArray.count; i++) {
        
        // 第一层字典，用于存放省市级城市名及下辖城市数组
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        // 第二层数组，用于存放每个省市级城市名以及其下辖城市字典
        NSMutableArray *citiesArray = [NSMutableArray array];
        // 第二层中地级城市名
        NSArray *secondArray = dic[[NSString stringWithFormat:@"name%@", stateCodeArray[i]]];
        // 第二层中地级城市名对应code
        NSArray *secondCodeArray = dic[[NSString stringWithFormat:@"code%@", stateCodeArray[i]] ];
        // 遍历地级城市名
        for (int j = 0; j < secondArray.count; j++) {
            // 第二字典，用于存储地级市名以及地级市下辖县区数据
            NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
            
            // 下辖城市数组
            NSMutableArray *areasArray = [NSMutableArray array];
            // 根据code值找到对应的下辖城市数组
            NSString *name = [NSString stringWithFormat:@"name%@", secondCodeArray[j]];
            if ([dic[name] count] > 0) {
                [areasArray addObjectsFromArray:dic[name]];
            }
            // 将下辖城市数组存入字典
            [cityDict setObject:areasArray forKey:@"areas"];
            // 将地级城市名存入字典
            [cityDict setObject:secondArray[j] forKey:@"city"];
            
            [citiesArray addObject:cityDict];
        }
        // 将省市级城市下辖城市名数组存入字典，完成第一层数据封装
        [dict setObject:citiesArray forKey:@"cities"];
        // 将省市级城市名存入字典
        [dict setObject:stateArray[i] forKey:@"state"];
        // 将省市级字典存入根数组
        [rootArray addObject:dict];
    }
    //        NSLog(@"%@",rootArray);
    //    NSLog(@"%lu",(unsigned long)rootArray.count);
    provinces = [[NSArray alloc] initWithArray:rootArray];
    cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
}


#pragma mark - WJJLabelDelegate
- (void)changeDataSourceWithIndex:(NSInteger)index {
    
    if (index == 5){
        category = ImpossibleNumber;
    }else if (index == 6){
        status = ImpossibleNumber;
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
