//
//  MissionEdittingViewController.m
//  errand
//
//  Created by gravel on 16/1/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MissionEdittingViewController.h"
#import "MissionEdittingTableViewCell.h"
#import "MissionBll.h"
#import "MissionModel.h"
#import "MMDateView.h"
#import "MMChoiceOneView.h"
#import "MMAlertView.h"
@interface MissionEdittingViewController ()<UITableViewDataSource,UITableViewDelegate,MMDateViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MMChoiceViewDelegate,UITextViewDelegate>

@property (nonatomic, strong)UITextView  *textField;
@end

@implementation MissionEdittingViewController{
     UITableView  *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray * _heightArray;
    NSArray *_travelWayArray;
    int travelWayType;
    // 第一层数组，用于存储所有省会级城市字典，应该有31元素，字典内包括省市级城市名及下辖城市数组
    NSArray *provinces, *cities, *areas;
    NSString *_fromStr;
    float _height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self setNavRightBtn];
    _travelWayArray = @[@"汽车",@"火车",@"飞机"];
    _fromStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentcity"];
    [self createCitys];
    // Do any additional setup after loading the view.
}
- (void)setNavRightBtn {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    if (_missionModel) {
        self.title=NSLocalizedString(@"missionEditting", @"missionEditting");
    }else{
       self.title=NSLocalizedString(@"missionEdition", @"missionEdition");
    }
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"commit", @"commit") style:UIBarButtonItemStyleDone target:self action:@selector(submitClick)];
    
    // 左侧返回按钮
    [self addBackButton];
}

- (void)submitClick {
    [_textField resignFirstResponder];
    //获取数据
    if (([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] ==nil)||
         ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] ==nil)||
          ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] ==nil)||
           ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] detailLabel] text] ==nil)||
        ([_textField.text isEqualToString:@""])) {

        [Dialog simpleToast:@"不能有空信息"];

    }else if ([[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text]  compare:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text]] == 1 ){

         [Dialog simpleToast:@"开始日期不能大于结束日期"];
        
    }else{
        self.navigationItem.rightBarButtonItem.action = nil;
        [self showHintInView:self.view];
        __block MissionEdittingViewController *tempSelf = self;
        MissionBll *missBLL = [[MissionBll alloc]init];
        //模型存在 是编辑
        if (_missionModel) {
            [missBLL editMissionData:^(MissionModel *model) {
               
                [self hideHud];
                
                if (_type != 2) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:_indexPath forKey:@"indexPath"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"editMissionData" object:model userInfo:dict];

                }
                
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
                
            } missionID:_missionModel.missionID start:_fromStr  dest:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text]
                travelMode:travelWayType
                content:_textField.text  startDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] endDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] viewCtrl:self];
            
        }else{
            //添加出差管理
            [missBLL addMissionData:^(int result,MissionModel *model) {
                [self hideHud];
                if ([tempSelf.missionCommitDelegate respondsToSelector:@selector(feedBackWithMissionModel:)]) {
                    [tempSelf.missionCommitDelegate feedBackWithMissionModel:model];
                }
                
                [tempSelf.navigationController popViewControllerAnimated:YES];
                
            } start:_fromStr  dest:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text]
                         travelMode:travelWayType
                            content:_textField.text  startDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] endDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] viewCtrl:self];
        }
    }
}


- (void)createTextField{
    _textField = [[UITextView alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH - 100,90)];
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textColor = COMMON_FONT_BLACK_COLOR;

}
- (void)createHeight{
    _heightArray = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++) {
        if (i ==_dataArray.count - 1) {
            [_heightArray addObject:@100];
        }else{
             [_heightArray addObject:@50];
        }
        
    }
    
}
- (void)createTableView {
    [self createTextField];
    [self createHeight];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_heightArray[indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MissionEdittingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MissionEdittingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.tag = indexPath.item;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.nameLabel.text = _dataArray[indexPath.item];
    if (_missionModel) {
       
        if (indexPath.row == 0) {
            _fromStr  = _missionModel.from;
            cell.detailLabel.text = _missionModel.from;
            
        }
        if (indexPath.row == 1) {
             cell.detailLabel.text = _missionModel.to;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        if (indexPath.row == 2) {
            NSDate *date = [formatter dateFromString:_missionModel.startDate];
            NSString *weekStr = [self weekdayStringFromDate:date];
             cell.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",_missionModel.startDate,@"  ",weekStr];;
        }
        if (indexPath.row == 3) {
            NSDate *date = [formatter dateFromString:_missionModel.endDate];
            NSString *weekStr = [self weekdayStringFromDate:date];
            cell.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",_missionModel.endDate,@"  ",weekStr];;
        }
        if (indexPath.row == 4) {
             cell.detailLabel.text = _travelWayArray[_missionModel.travelType];
            travelWayType = _missionModel.travelType;
        }
        if (indexPath.row == 5) {
            [cell addSubview:_textField];
             _textField.text = _missionModel.remark;
        }
        
    }else{
        if (indexPath.row == 0) {
            cell.detailLabel.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"currentcity"];
        }
        if (indexPath.row == 5) {
            [cell addSubview:_textField];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        case 2:
        {
            [self.view endEditing:YES];
            MMDateView *dateView = [MMDateView new];
            dateView.centerLabel.text = @"开始时间";
            dateView.delegate=self;
            dateView.datePicker.tag=1;
            dateView.datePicker.datePickerMode = UIDatePickerModeDate;
            [dateView showWithBlock:nil];
            
        }break;
        case 3:{
            [self.view endEditing:YES];
            MMDateView *dateView = [MMDateView new];
            dateView.centerLabel.text = @"结束时间";
            dateView.delegate=self;
            dateView.datePicker.tag=2;
            dateView.datePicker.datePickerMode = UIDatePickerModeDate;
            [dateView showWithBlock:nil];
        }break;
        case 4:{
            MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
            choiceView.pickerView.tag = 3;
            choiceView.pickerView.delegate = self;
            choiceView.pickerView.dataSource = self;
            choiceView.delegate = self;
            [choiceView showWithBlock:nil];
            
        }break;
        case 5:
        {
          
        }break;
            
        default:
            break;
    }
    
}

#pragma mark --- UIPickerView
-(void)MMChoiceViewChoiced:(UIPickerView*)picker{
    if (picker.tag == 3) {
        int row =(int) [picker selectedRowInComponent:0];
        travelWayType = row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        MissionEdittingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text = _travelWayArray[row];
    }else if (picker.tag == 4){
        int row1 =(int) [picker selectedRowInComponent:0];
        int row2 =(int) [picker selectedRowInComponent:1];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        MissionEdittingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (row1 > 3) {
            cell.detailLabel.text = provinces[row1][@"cities"][row2][@"city"];
        }else{
            cell.detailLabel.text = provinces[row1][@"state"];
        }
        _fromStr = cell.detailLabel.text;
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        [picker selectRow:0 inComponent:1 animated:YES];
        [picker reloadComponent:1];
    }else{
        int row1 =(int) [picker selectedRowInComponent:0];
        int row2 =(int) [picker selectedRowInComponent:1];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        MissionEdittingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (row1 > 3) {
            cell.detailLabel.text = provinces[row1][@"cities"][row2][@"city"];
        }else{
            cell.detailLabel.text = provinces[row1][@"state"];
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
    }else {
        return 2;
    }
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 3) {
        return  3;
    }else {
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
         return  _travelWayArray[row];
    }else {
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
    return  _travelWayArray[row];
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
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        MissionEdittingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",strDate,@"  ",weekStr];
    }
    if(picker.tag==2){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        NSString *weekStr = [self weekdayStringFromDate:picker.date];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        MissionEdittingTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text =[NSString stringWithFormat:@"%@%@%@",strDate,@"  ",weekStr];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)info

{
    
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, 0, keyboardBounds.size.height, 0);
    _height = keyboardBounds.origin.y;
   
    if (keyboardBounds.size.height > 0) {
        float height1 = _tableView.frame.origin.y + 350;
      
        if (height1 > _height) {
            _tableView.contentOffset = CGPointMake(0, height1 - _height);
            
        }

    }
   
}

- (void)keyboardWillHide:(NSNotification *)info

{
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, 0, 0, 0);
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

        provinces = [[NSArray alloc] initWithArray:rootArray];
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];

 
}

- (void)viewWillDisappear:(BOOL)animated{
   
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   [_textField resignFirstResponder];

    
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
