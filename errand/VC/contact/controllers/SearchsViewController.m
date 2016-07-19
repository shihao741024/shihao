//
//  SearchsViewController.m
//  errand
//
//  Created by 医路同行Mac1 on 16/6/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchsViewController.h"
#import "TaskEditTableViewCell.h"
#import "MMChoiceOneView.h"
#import "SearchResultsViewController.h"
#import "ContactssViewController.h"

@interface SearchsViewController ()<UITableViewDelegate,UITableViewDataSource,MMChoiceViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,WJJLabelDelegate>

@property (nonatomic, strong)NSArray *provinces;
@property (nonatomic, strong)NSArray *cities;

@end

@implementation SearchsViewController{
    UITableView  *_tableView;
    NSMutableArray *_dataArray;
    
    UITextField *_keywordsField;
    UITextField *_contentField;
    
    //搜索的关键字
    NSString *_keywords;
    NSString *_kind;
    NSString *_department;
    NSString *_hospitalrank;
    NSString *_province;
    NSString *_city;
    
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
    
    
}
- (void)createRightItem{
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = @"搜索医院";
    [self addBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"search", @"search") style:UIBarButtonItemStyleDone target:self action:@selector(searchClick)];
}
- (void)searchClick{
    
    _keywords = _keywordsField.text;
    
    _hospitalrank = _contentField.text;
    
    TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    _province = cell3.detailLabel.text;
    
    TaskEditTableViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    _city = cell4.detailLabel.text;
    
    
//    @property (nonatomic, copy)void (^feedBackHospitalSearchDataBlock)(NSString *keywords,NSString *hospitalrank,NSString *province,NSString *city);
    self.feedBackHospitalSearchDataBlock(_keywords,_hospitalrank,_province,_city);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createTextField{
    UITextField *keywordsField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    keywordsField.textColor = COMMON_FONT_BLACK_COLOR;
    keywordsField.clearButtonMode = UITextFieldViewModeAlways;
    keywordsField.font = [UIFont systemFontOfSize:14];
    keywordsField.placeholder = @"请输入医院名称关键字";
    _keywordsField = keywordsField;
    
    UITextField *contentField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    contentField.textColor = COMMON_FONT_BLACK_COLOR;
    contentField.clearButtonMode = UITextFieldViewModeAlways;
    contentField.font = [UIFont systemFontOfSize:14];
    contentField.placeholder = @"医院等级";
    _contentField = contentField;
    
}


- (void)initView{
    [self createCitys];
    [self createTextField];
    
    NSArray *dataArray = @[@"关键字:",@"医院等级:",@"省:",@"市:"];
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    
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
    
    //如果搜索的数组有值，那就加在视图上
    if (hasSearchArray == YES) {
        if (indexPath.row == 0) {
            [cell addSubview:_keywordsField];
            _keywordsField.text = _searchArray[0];
        }
        if (indexPath.row == 1) {
            [cell addSubview:_contentField];
            _contentField.text = _searchArray[1];
        }
        if (indexPath.row == 2) {
            [cell.detailLabel setTextWithString:_searchArray[2] andIndex:indexPath.row];
        }
        if (indexPath.row == 3) {
            [cell.detailLabel setTextWithString:_searchArray[3] andIndex:indexPath.row];
        }
    }else{
        if (indexPath.row == 0) {
            [cell addSubview:_keywordsField];
        }
        if (indexPath.row == 1) {
            [_contentField removeFromSuperview];
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
        case 2:{
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 2;
            choiceView.pickerView.delegate = self;
            choiceView.pickerView.dataSource = self;
            choiceView.delegate = self;
            [choiceView showWithBlock:nil];
        }break;
        case 3:{
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 3;
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
    if (picker.tag == 2){
        int row =(int) [picker selectedRowInComponent:0];
        _row1 = row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:_provinces[row][@"state"] andIndex:indexPath.row];
        _cities = [[_provinces objectAtIndex:_row1] objectForKey:@"cities"];
        
    }else {
        int row =(int) [picker selectedRowInComponent:0];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:_provinces[_row1][@"cities"][row][@"city"] andIndex:indexPath.row];
        
    }
}
// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return  1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 2){
        return [_provinces count];
    }else {
        return [_cities count];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 2) {
        return [[_provinces objectAtIndex:row] objectForKey:@"state"];
    }else {
        return [[_cities objectAtIndex:row] objectForKey:@"city"];
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
    _provinces = [[NSArray alloc] initWithArray:rootArray];
    //    cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
}

#pragma mark - WJJLabelDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
