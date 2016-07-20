//
//  TaskEdittingViewController.m
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskEdittingViewController.h"
#import "TaskEditTableViewCell.h"
#import "MMDateView.h"
#import "TaskBll.h"
#import "MMChoiceOneView.h"
#import "MMAlertView.h"
#import "DeclareBll.h"
#import "SalesStatisticsBll.h"
#import "ProductionsViewController.h"
#import "CustomerVisitBll.h"
#import "SelectStaffView.h"
#import "ContactViewController.h"
#import "CommonBll.h"
#import "DistriModel.h"
#import "DistriTableView.h"
#import "DistributionView.h"
#import "SelectDepartmentVC.h"
#import "SelectStaffViewController.h"
#import "DeclareNameView.h"
@interface TaskEdittingViewController () <UITableViewDataSource, UITableViewDelegate,MMDateViewDelegate,MMChoiceViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,StaffViewDelegate,UITextFieldDelegate,DistriTableViewDelegate,DistributionViewDelegate,DeclareNameViewDelegate, WJJLabelDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong)UITextField *titleField;
@property (nonatomic, strong)UITextView  *contentTextView;
@property (nonatomic, strong)UITextField *useWayField;
@property (nonatomic, strong)UITextField *costField;
@end

@implementation TaskEdittingViewController {
    
    UITableView                  *_tableView;

    UIView *_bgView;
    
    NSMutableArray *_heightArray;
    
    int priorityType;
    
    NSArray *_priorityArray;
    float _height;
    BOOL textViewSelected;
    
    NSArray *_customerArray;
    
    NSNumber *_staffID;
    
    ProductionModel *_productionModel;
    
    ContactModel *_contactModel;
    
    DoctorsModel *_doctorsModel;
    
    NSMutableArray *_distriArray;
    
    NSMutableArray *_searchDistriArray;
    
    DistriTableView *_distriTableView;
    
    UITapGestureRecognizer *_tapRecognizer;
    
    NSString *_staffName;
    NSString *_telephone;
    NSArray *_tos;
    NSArray *_selectStaffArray;
    
}
@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self createTableView];
    [self createTextField];
    [self setNavRightBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveHospitalName:) name:@"feedbackHospitalModel" object:nil ];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(editFillInfoData) userInfo:nil repeats:NO];
}

- (void)editFillInfoData
{
    if (_editModel) {
        if (type == 1) {
            DeclareDetailModel *declareModel = (DeclareDetailModel *)_editModel;
            TaskEditTableViewCell *nameCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            nameCell.detailLabel.text = declareModel.declareName;
            
            
            if ([Function isNullOrNil:declareModel.productionDic]) {
                _productionModel = nil;
            }else {
                _productionModel = [[ProductionModel alloc] initWithDic:declareModel.productionDic];
            }
            
            TaskEditTableViewCell *productCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            productCell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)", _productionModel.name, _productionModel.specification];
            if (_productionModel) {
                [productCell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@(%@)", _productionModel.name, _productionModel.specification] andIndex:1];
            }
            
            
            TaskEditTableViewCell *doctorCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            if ([Function isNullOrNil:declareModel.doctorDic]) {
                _doctorsModel = nil;
                if ([Function isNullOrNil:declareModel.hospitalDic]) {
                    _contactModel = nil;
                }else {
                    _contactModel = [[ContactModel alloc] initWithDic:declareModel.hospitalDic];
                    [doctorCell.detailLabel setTextWithString:_contactModel.hospitalName andIndex:2];
                }
                
                
            }else {
                _doctorsModel = [[DoctorsModel alloc] initWithDic:declareModel.doctorDic];
//                doctorCell.detailLabel.text = _doctorsModel.name;
                [doctorCell.detailLabel setTextWithString:_doctorsModel.name andIndex:2];
            }
            
            _useWayField.text = declareModel.wayString;
            _costField.text = declareModel.moneyString;
            _titleField.text = declareModel.remarkString;
            
            _contentTextView.text = declareModel.remark;
        }
        
    }
}

- (void)changeDataSourceWithIndex:(NSInteger)index
{
    if (index == 1 || index == 2) {
        TaskEditTableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell1.detailLabel.text = @"请选择产品";
//        cell1.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
        cell2.detailLabel.text = @"请选择医院／医生";
//        cell2.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
        
        cell1.detailLabel.clearButton.hidden = YES;
        cell2.detailLabel.clearButton.hidden = YES;
        
        _contactModel = nil;
        _doctorsModel = nil;
        _productionModel = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *costomerArray = [NSUserDefaults standardUserDefaults];
 
    if ([costomerArray objectForKey:@"costomerArray"]) {
        _customerArray = [NSArray arrayWithArray:[costomerArray objectForKey:@"costomerArray"]];
        switch (type) {
            case 1:
            {
//                NSArray *costomerArray = @[productdata,contactData,doctorsData];
                    //数组 产品 医院 医生
                    if (_customerArray.count == 3) {
                        TaskEditTableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        ProductionModel *model1 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[0]];
                        [cell1.detailLabel setTextWithString:[NSString stringWithFormat:@"%@(%@)",model1.name,model1.specification] andIndex:1];
//                         cell1.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",model1.name,model1.specification];
                        _productionModel = model1;
                        
                        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        _doctorsModel = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[2]];
                        [cell2.detailLabel setTextWithString:_doctorsModel.name andIndex:2];
//                        cell2.detailLabel.text = _doctorsModel.name;
                        
                        ContactModel *model2 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[1]];
                        _contactModel = model2;
                        
                    }
            }
                break;
            case 3:
            {
                TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.detailLabel.text = _customerArray[1];
                
                TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell2.detailLabel.text = _customerArray[4];
            }
                break;
            case 4:{
                TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                cell2.detailLabel.text = [_customerArray objectAtIndex:4];
            }
            default:
                break;
        }
         [costomerArray removeObjectForKey:@"costomerArray"];
    }
    
    if ([costomerArray objectForKey:@"staffInfo"]) {
        NSArray *staffInfo = [NSArray arrayWithArray:[costomerArray objectForKey:@"staffInfo"]];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.detailLabel.text = staffInfo[0];
        _staffID = staffInfo[1];
        _staffName = staffInfo[0];
        _telephone = staffInfo[2];
        [costomerArray removeObjectForKey:@"staffInfo"];
    }
    
  
}


- (void)reciveHospitalName:(NSNotification*)notification{
//    _doctorsID = ImpossibleNSNumber;
    _doctorsModel = nil;
    
    _productionModel = notification.object[1];
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@(%@)",_productionModel.name,_productionModel.specification] andIndex:1];
//    cell.detailLabel.text =[NSString stringWithFormat:@"%@(%@)",_productionModel.name,_productionModel.specification];
    
    ContactModel *model = notification.object[0];
    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    cell2.detailLabel.text = model.hospitalName;
    [cell2.detailLabel setTextWithString:model.hospitalName andIndex:2];
    _contactModel = model;
    
}
- (void)createHeight{

       _priorityArray = @[@"普通", @"紧急"];
    _heightArray = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++) {
        if (i ==_dataArray.count - 1) {
            //如果是销售统计
            if (type == 3) {
                [_heightArray addObject:@50];

            }else{
                 [_heightArray addObject:@100];
            }
           
        }else{
           
            [_heightArray addObject:@50];
        }
        
    }
}
// 设置“提交”按钮 和左侧返回按钮
- (void)setNavRightBtn {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    switch (type) {
        case 0:
             self.title=NSLocalizedString(@"taskEditting", @"taskEditting");
            break;
        case 1:
             self.title=NSLocalizedString(@"declareEditting", @"declareEditting");
            break;
            case 2:
             self.title=NSLocalizedString(@"missionEditting", @"missionEditting");
            break;
        case 3:
        {
            
            if (_salesStatisticsModel.amountString) {
                
                TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.detailLabel.text = _salesStatisticsModel.pillName;
                
                TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell2.detailLabel.text = _salesStatisticsModel.hospitalName;
                
                _costField.text = _salesStatisticsModel.amountString;
                _contentTextView.text = _salesStatisticsModel.buyerString;
            }
        } break;
        case 4:
            self.title=NSLocalizedString(@"customerVisitEditting", @"customerVisitEditting");
            break;
        default:
            break;
    }
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"commit", @"commit") style:UIBarButtonItemStyleDone target:self action:@selector(submitClick)];
    
   }

- (void)createTableView {
    [self createHeight];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
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

- (void)createTextField{
        UITextField *titleField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 100, 50)];
        titleField.textColor = COMMON_FONT_BLACK_COLOR;
    titleField.clearButtonMode = UITextFieldViewModeAlways;
        titleField.font = [UIFont systemFontOfSize:14];
        _titleField= titleField;
    
     _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH - 100, 90)];
    _contentTextView.delegate = self;
    _contentTextView.font = [UIFont systemFontOfSize:14];
    
    UITextField *useWayField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 100, 50)];
    useWayField.textColor = COMMON_FONT_BLACK_COLOR;
    useWayField.clearButtonMode = UITextFieldViewModeAlways;
    useWayField.font = [UIFont systemFontOfSize:14];
    _useWayField = useWayField;
    
    UITextField *costField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 100, 50)];
    costField.textColor = COMMON_FONT_BLACK_COLOR;
    costField.font = [UIFont systemFontOfSize:14];
    _costField.clearButtonMode = UITextFieldViewModeAlways;
    _costField = costField;
     _costField.keyboardType = UIKeyboardTypeDecimalPad;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_heightArray[indexPath.row]intValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TaskEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.detailLabel.delegate = self;
        cell.tag = indexPath.item;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        switch (type ) {
            case 0:
            {
                if (indexPath.item == 0) {
                     [cell addSubview:_titleField];
                }
                if (indexPath.item == 4) {
                     [cell addSubview:_contentTextView];
                }
            }
                break;
            case 1:{
                if (indexPath.item == 1) {
                    cell.detailLabel.text = @"请选择项目";
//                    cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
                }
                if (indexPath.item == 1) {
                    cell.detailLabel.text = @"请选择产品";
//                    cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
                }
                if (indexPath.item == 2) {
                    cell.detailLabel.text = @"请选择医院／医生";
//                    cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
                }

                if (indexPath.item == 6) {
                    [cell addSubview:_contentTextView];
                }
                if (indexPath.item == 3) {
                    [cell addSubview:_useWayField];
                }
                if (indexPath.item == 4) {
                    [cell addSubview:_costField];
                }
                if (indexPath.item == 5) {
                    [cell addSubview:_titleField];
                }
            }break;
                //销售统计模块
            case 3:{
                //0 销售上报  1 传销上报  2 竞品上报
                if (_salesStatisticsType == 0) {
                    if (indexPath.item == 0) {
                        cell.detailLabel.text = @"请选择产品";
                        cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
                    }
                    if (indexPath.item == 1) {
                        cell.detailLabel.text = @"请选择医院";
                        cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
                       
                    }
                    if (indexPath.item == 3) {
                        [cell addSubview:_costField];
                    }
                    if (indexPath.item == 4) {
                        _titleField.placeholder = @"填写配送商业或者选择";
                        _titleField.frame = CGRectMake(100, 0, SCREEN_WIDTH - 160, 50);
                        [cell addSubview:_titleField];
                        _titleField.delegate = self;
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_titleField];
                        UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60,10, 55, 30)];
                        [chooseButton setTitle:@"选择" forState:UIControlStateNormal];
                        [chooseButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
                        chooseButton.backgroundColor = COMMON_BLUE_COLOR;
                        chooseButton.layer.cornerRadius = 15;
                        chooseButton.clipsToBounds = YES;
                        [chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell addSubview:chooseButton];
                        [chooseButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    }
                }else if (_salesStatisticsType == 1){
                    if (indexPath.item == 4) {
                        [cell addSubview:_costField];
                    }
                }
                }break;
            case 4:{
                
                if (indexPath.item == 0) {
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@我",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
                    cell.detailLabel.textColor = COMMON_FONT_BLACK_COLOR;
                }
                if (indexPath.item == 3) {
                    //单选按钮
                    UIButton *planButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 70, 50)];
                    [planButton setTitle:@"计划" forState:UIControlStateNormal];
                    [planButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
                    [planButton setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
                    [planButton setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
                    [planButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    planButton.tag = 100;
                    planButton.selected = YES;
                    [cell addSubview:planButton];
                    [planButton addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(100+90, 0, 70, 50)];
                    [tempButton setTitle:@"临时" forState:UIControlStateNormal];
                    [tempButton setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
                    [tempButton setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
                    [tempButton setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
                    [tempButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    tempButton.tag = 101;
                    [cell addSubview:tempButton];
                    [tempButton addTarget:self action:@selector(radioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (indexPath.item == 4) {
                    [cell addSubview:_contentTextView];
                }
            }break;
            default:
                break;
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.nameLabel.text = _dataArray[indexPath.item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //根据进来的类型 进行相应的点击事件
    switch (type ) {
            //0  任务交办
        case 0:
        {
            switch (indexPath.item) {
//                   选择下属员工
                case 2:{
                    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
                    vc.type = 2;
                    vc.staffModelArray = (NSMutableArray *)_selectStaffArray;
                    vc.subordinateLayout = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc setSelectstaffArrayBlock:^(NSMutableArray *array) {
                        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        NSMutableArray *nameArray= [NSMutableArray array];
                        NSMutableArray *tos = [NSMutableArray array];
                        for (StaffModel *model in array) {
                            [nameArray addObject:model.staffName];
                            NSDictionary *dic = @{@"id":[NSNumber numberWithInt:[model.ID intValue]],@"name":model.staffName,@"telephone":model.phoneNumber};
                            [tos addObject:dic];
                            
                        }
                        cell.detailLabel.text = [nameArray componentsJoinedByString:@" "];
                        _tos = tos;
                        _selectStaffArray = array;
                    }];
                    
//                    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
//                    vc.type = 3;
//                    [self.navigationController pushViewController:vc animated:YES];
//                    vc.selectstaffBlock = ^(StaffModel *model){
//                        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                        cell.detailLabel.text = model.staffName;
//                        _staffID = [NSNumber numberWithInt:[model.ID intValue]];
//                        _staffName = model.staffName;
//                        _telephone = model.phoneNumber;
//                    };
                    
                    break;
                }
                case 4: {
                    
                }
                    break;
                    
                case 1: {
                    [self.view endEditing:YES];
                    MMChoiceOneView *choiceView = [[MMChoiceOneView alloc]init];
                    choiceView.pickerView.tag = 1;
                    choiceView.pickerView.delegate = self;
                    choiceView.pickerView.dataSource = self;
                    choiceView.delegate = self;
                    [choiceView showWithBlock:nil];
                }
                    break;
                    
                case 3: {
                    [self.view endEditing:YES];
                    MMDateView *dateView = [MMDateView new];
                    dateView.centerLabel.text = @"完成期限";
                    dateView.delegate=self;
                    dateView.datePicker.tag=2;
                    [dateView showWithBlock:nil];
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            //         1  费用申报
        case 1:{
            switch (indexPath.item) {
                case 0:{
                    DeclareNameView *view = [[DeclareNameView alloc]init];
                    view.delegate = self;
                    [self.view addSubview:view];
                }break;
                case 1:
                case 2:{
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    productionsVC.type = 3;
                    if (_editModel) {
                        productionsVC.popIndex = 3;
                    }
                    
                    [self.navigationController pushViewController:productionsVC animated:YES];
                }break;
                case 3:
                case 4:
                case 5:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }break;
            //销售上报
        case 3:{
            if (_salesStatisticsType == 0) {
                switch (indexPath.item) {
                    case 0:
                    {
                        ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                        [self.navigationController pushViewController:productionsVC animated:YES];
                        productionsVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                            TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                            cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                            _productionModel = productionModel;
                        };
                        
                    }break;
                    case 1:{
                        //当药品已经选择了 才能选择医院
                        if (_productionModel.productID) {
                            ContactViewController *contactVC = [[ContactViewController alloc]init];
                            contactVC.type = 1;
                            contactVC.productModel = _productionModel;
                            [self.navigationController pushViewController:contactVC animated:YES];
                            contactVC.feedBackContactModelBlock= ^(ContactModel *contactModel) {
                                TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                                cell.detailLabel.text = contactModel.hospitalName;
                                _contactModel = contactModel;
                            };
                        }else{
                            [Dialog simpleToast:@"请先选择产品"];
                        }
                        
                    }break;
                    case 2:{
                        [self.view endEditing:YES];
                        MMDateView *dateView = [MMDateView new];
                        dateView.datePicker.datePickerMode = UIDatePickerModeDate;
                        dateView.delegate=self;
                        dateView.datePicker.tag=3;
                        [dateView showWithBlock:nil];
                    }break;
                    default:
                        break;
                }
            }else if (_salesStatisticsType == 1){
                switch (indexPath.item) {
                    case 0:
                    {
                        ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                        [self.navigationController pushViewController:productionsVC animated:YES];
                        productionsVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                            TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                            cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                            _productionModel = productionModel;
                        };
                        
                    }break;
                    case 1:{
                        //当药品已经选择了 才能选择医院
                        if (_productionModel.productID) {
                            ContactViewController *contactVC = [[ContactViewController alloc]init];
                            contactVC.type = 1;
                            contactVC.productModel = _productionModel;
                            [self.navigationController pushViewController:contactVC animated:YES];
                            contactVC.feedBackContactModelBlock= ^(ContactModel *contactModel) {
                                TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                                cell.detailLabel.text = contactModel.hospitalName;
                                _contactModel = contactModel;
                            };
                        }else{
                            [Dialog simpleToast:@"请先选择产品"];
                        }
                    }break;
                    case 2:{
                        //当药品/医院已经选择了 才能选择医生
                        if (_productionModel.productID) {
                            if (_contactModel.hospitalID) {
                                ContactViewController *contactVC = [[ContactViewController alloc]init];
                                contactVC.type = 2;
                                contactVC.productModel = _productionModel;
                                contactVC.contactModel = _contactModel;
                                [self.navigationController pushViewController:contactVC animated:YES];
                                contactVC.feedBackDoctorsModelBlock = ^(DoctorsModel *doctorsModel){
                                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                                    cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",doctorsModel.name,doctorsModel.office];
                                    _doctorsModel = doctorsModel;
                                };
                            }else{
                                [Dialog simpleToast:@"请先选择医院"];
                            }
                            
                        }else{
                            [Dialog simpleToast:@"请先选择产品"];
                        }
                        
                    }break;
                    case 3:{
                        [self.view endEditing:YES];
                        MMDateView *dateView = [MMDateView new];
                        dateView.datePicker.datePickerMode = UIDatePickerModeDate;
                        dateView.delegate=self;
                        dateView.datePicker.tag=4;
                        [dateView showWithBlock:nil];
                    }break;
                    default:
                        break;
                }
            }else{
                //竞品上报
            }
        }break;
            //         4 客户拜访
        case 4:{
            switch (indexPath.item) {
                    
                case 1:{
                    //
                    [self.view endEditing:YES];
                    MMDateView *dateView = [MMDateView new];
                    dateView.delegate=self;
                    dateView.datePicker.tag=5;
                    dateView.datePicker.datePickerMode = UIDatePickerModeDate;
                    [dateView showWithBlock:nil];
                    
                    
                }break;
                    
                case 3:{
                    
                    
                }break;
                    
                case 2:
                {
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    [self.navigationController pushViewController:productionsVC animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }break;
            
        default:
            break;
    }
}

#pragma mark ---  DeclareNameViewdelegate
- (void)selectDeclareName:(NSString *)name{
    
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailLabel.text = name;
    
}
//单选按钮
- (void)radioBtnClick:(UIButton*)button{
    for (int i = 100; i < 102; i++) {
        if (button.tag == i) {
            button.selected = YES;
        }else{
            UIButton *elsebutton = (UIButton*)[self.view viewWithTag:i];
            elsebutton.selected = NO;
        }
    }
    
}
#pragma mark - 实现textFieldChanged函数
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
   
}
- (void)textFieldChanged:(UITextField*)sender
{
    //自动匹配 请求过一次 就不请求
    if (_distriArray == nil) {
        _distriArray = [NSMutableArray array];
        _searchDistriArray = [NSMutableArray array];
        CommonBll *commonBll = [[CommonBll alloc]init];
        [commonBll getdistriData:^(NSArray *arr) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_distriArray addObject:obj];
            }];
            for (DistriModel *model in _distriArray) {
                
                if ([model.vendor rangeOfString:_titleField.text].location != NSNotFound) {
                    [_searchDistriArray addObject:model];
                }
            }
            
            //搜索的数组不为0 才创建
            if (_searchDistriArray.count != 0) {
                _distriTableView = [[DistriTableView alloc] initWithFrame:CGRectMake(100, 64 +10 , 200, 50*4 - 10 - _tableView.contentOffset.y) style:UITableViewStylePlain distriArray:_searchDistriArray];
                _distriTableView.distriDelegate = self;
                [self.view addSubview:_distriTableView];
                
                
                //加一个tap手势
                _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTap)];
                _tableView.userInteractionEnabled = YES;
                [_tableView addGestureRecognizer:_tapRecognizer];
            }
           
        } viewCtrl:self];
    }else{
        //数据已经请求过  表单也已经创建过
        [_searchDistriArray removeAllObjects];
        for (DistriModel *model in _distriArray) {
            if ([model.vendor rangeOfString:_titleField.text].location != NSNotFound) {
                [_searchDistriArray addObject:model];
            }
        }
        
            //表单已经没有创建过，搜索的数据不为0，则创建
            if (_distriTableView == nil && _searchDistriArray.count !=0) {
                _distriTableView = [[DistriTableView alloc] initWithFrame:CGRectMake(100, 64 +10 , 200, 50*4 - 10 - _tableView.contentOffset.y) style:UITableViewStylePlain distriArray:_searchDistriArray];
                _distriTableView.distriDelegate = self;
                [self.view addSubview:_distriTableView];
                //加一个tap手势
                _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTap)];
                _tableView.userInteractionEnabled = YES;
                [_tableView addGestureRecognizer:_tapRecognizer];
            }
        //表单已经创建过，搜索的数据为0，则让它的frame为0
            else if ( _distriTableView != nil && _searchDistriArray.count ==0 ){
                 _distriTableView.frame = CGRectZero;
                 [_tableView removeGestureRecognizer:_tapRecognizer];
            }
        //表单已经创建过，搜索的数据不为0，则改变刷新
            else if (_distriTableView != nil && _searchDistriArray.count !=0){
                _distriTableView.frame = CGRectMake(100, 64 + 10 , 200, 50*4 - 10 - _tableView.contentOffset.y);
                [_distriTableView tableviewReloadWithArray:_searchDistriArray];
                //加一个tap手势
                 [_tableView removeGestureRecognizer:_tapRecognizer];
                _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewTap)];
                _tableView.userInteractionEnabled = YES;
                [_tableView addGestureRecognizer:_tapRecognizer];
            }
        
    }
    
    
}

- (void)tableViewTap{
    
    _distriTableView.frame = CGRectZero;
    
    [_tableView removeGestureRecognizer:_tapRecognizer];
    
}
- (void)cellClick:(NSString *)pss{
    _titleField.text = pss;
    _distriTableView.frame = CGRectZero;
   
    
}

#pragma mark - 选择配送商按钮
- (void)chooseButtonClick{
   
//    if (_contactModel.provincial) {
//        DistributionView *distributionView = [[DistributionView alloc]initWithFrame:CGRectZero contactModel:_contactModel];
//        distributionView.delegate = self;
//        [self.view addSubview:distributionView];
//
//    }else if (_salesStatisticsModel.salesStatisticsID){
//        DistributionView *distributionView = [[DistributionView alloc]initWithFrame:CGRectZero contactModel:_contactModel];
//        distributionView.delegate = self;
//        [self.view addSubview:distributionView];
//    }
//    else{
//        [Dialog simpleToast:@"请先选择医院"];
//    }
    
}
#pragma mark --- DistributionViewDelegate
- (void)selectPss:(NSString *)pss{
    _titleField.text = pss;
}
#pragma mark --- StaffViewDelegate
- (void)selectStaffWithName:(NSString *)name andTelephone:(NSString *)telephone andID:(NSNumber *)id{
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.detailLabel.text = name;
    _staffID = id;
}

#pragma mark --- UIPickerView
-(void)MMChoiceViewChoiced:(UIPickerView*)picker{
    if (picker.tag == 1) {
        int row =(int) [picker selectedRowInComponent:0];
        priorityType = row;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text = _priorityArray[row];
    }
}
// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if (pickerView.tag == 1) {
        return  1;
    }
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return  _priorityArray.count;
    }
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return  _priorityArray[row];
    }
    return  @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    
}

#pragma mark - MMChoiceDateViewChoicedDelegate

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker{
    if(picker.tag==2){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        
         NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
      
         cell.detailLabel.text = strDate;
    }
    if(picker.tag==3){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text = strDate;
    }
    if(picker.tag==4){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text = strDate;
    }
    if (picker.tag == 5) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:picker.date];
        NSUserDefaults *VisitDate = [NSUserDefaults standardUserDefaults];
        [VisitDate setObject:strDate forKey:@"visitDate"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.detailLabel.text = strDate;
    }
    
}

- (void)submitClick {
    [_titleField resignFirstResponder];
    [_useWayField resignFirstResponder];
    [_costField resignFirstResponder];
    [_contentTextView resignFirstResponder];
    
    switch (type) {
         //  任务交办
        case 0:{
            if (([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)||
                ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] == nil)||
                ([_contentTextView.text isEqualToString:@""])||
                (([_titleField.text  isEqualToString:@""])||_titleField.text.length==0)||
                ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] == nil) || _tos == nil) {
                 [Dialog simpleToast:@"不能有空信息"];
            }else{
                //获取数据
                self.navigationItem.rightBarButtonItem.action = nil;
                [self showHintInView:self.view];
                TaskBll *taskBll = [[TaskBll alloc]init];
                [taskBll addTaskData:^(NSArray<TaskModel *> *modelArray) {
                    [self hideHud];
                    [Dialog simpleToast:@"新建任务成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    self.feedBackBlockTaskModels(modelArray);
                    
                } to:_staffID name:_staffName telephone:_telephone priority:priorityType content:_contentTextView.text title:_titleField.text planCompleteDate:[NSString stringWithFormat:@"%@%@",[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text],@":00"] viewCtrl:self tos:_tos];
                
//                [taskBll addTaskData:^(TaskModel *model) {
//                    [self hideHud];
//                    [Dialog simpleToast:@"新建任务成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    //由于数据类型不同 先不用
//                    self.feedBackBlock(model);
//                }to:_staffID name:_staffName telephone:_telephone priority:priorityType content:_contentTextView.text title:_titleField.text planCompleteDate:[NSString stringWithFormat:@"%@%@",[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text],@":00"] viewCtrl:self tos:_tos];
                
            }
                  }break;
            //费用申报
        case 1:{
           
            if (([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailLabel] text] == nil)||
                [_useWayField.text isEqualToString:@""]||
                [_costField.text isEqualToString:@""]||[_titleField.text isEqualToString:@""]) {
//                ||
//                ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] == nil)
//                ||([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)
                
                [Dialog simpleToast:@"不能有空信息"];
            }else{
                self.navigationItem.rightBarButtonItem.action = nil;
                [self showHintInView:self.view];
                
                NSNumber *declareID = nil;
                if (_editModel) {
                    DeclareDetailModel *declareDetailModel = (DeclareDetailModel *)_editModel;
                    declareID = declareDetailModel.declareID;
                }

                DeclareBll *declareBll = [[DeclareBll alloc]init];
                [declareBll addDeclareData:^(DeclareModel *model) {
                    [self hideHud];
                    if (_editModel) {
                        [Dialog simpleToast:@"编辑成功"];
                        NSArray *vcs = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:vcs[vcs.count-3] animated:YES];
                        _editFinishRefreshCB();
                    }else {
                        [Dialog simpleToast:@"费用上报成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        self.feedBackDeclareBlock(model);
                    }
//                 NSLog(@"%@", _doctorsModel == nil ?  ImpossibleNSNumber :_doctorsModel.doctorID);
                } Name:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailLabel] text]
                                  Hospital:_contactModel == nil ? ImpossibleNSNumber :_contactModel.hospitalID
                                    doctor:_doctorsModel == nil ? ImpossibleNSNumber :_doctorsModel.doctorID
                                production:_productionModel == nil ? ImpossibleNSNumber :_productionModel.productID
                               description:_useWayField.text cost:_costField.text goal:_titleField.text remark:_contentTextView.text  viewCtrl:self declareID:declareID];
            }
        }break;
            //销售统计
        case 3:{
            //让键盘收起
            [_titleField resignFirstResponder];
            [_costField resignFirstResponder];
            if (_salesStatisticsType == 0) {
                if ((_productionModel.name == nil)||
                     (_contactModel.hospitalName == nil)
                     ||([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)
                    ||[_costField.text isEqualToString:@""]||
                     [_titleField.text isEqualToString:@""]) {
                    [Dialog simpleToast:@"不能有空信息"];
                }else{
                    self.navigationItem.rightBarButtonItem.action = nil;
                    [self showHintInView:self.view];
                    SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
                    //                来判断是编辑还是上报
                    if (_salesStatisticsModel.amountString) {
//                        [salesBll editsalesStatisticsData:^(SalesStatisticsModel *model) {
//                            [self hideHud];
//                            [self.navigationController  popViewControllerAnimated:YES];
//                            
//                        } salesStatisticsID:_salesStatisticsModel.salesStatisticsID
//                                                 Hospital:_salesStatisticsModel.hospitalID doctor:_salesStatisticsModel.doctorID production:_salesStatisticsModel.productionID count:_salesStatisticsModel.amountString pss:_salesStatisticsModel.buyerString];
                        
                    }else{
                        
                        [salesBll addsalesStatisticsData:^(SalesStatisticsModel *model) {
                            [self hideHud];
                            [self.navigationController  popViewControllerAnimated:YES];
                            self.feedBackSalesStatisticsBlock(model);
                        } ContactModel:_contactModel  doctorsModel:_doctorsModel productionModel:_productionModel count:_costField.text pss:_titleField.text category:[NSNumber numberWithInt:_salesStatisticsType] upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] price:nil viewCtrl:self];
                    }
                    
                }
                
            }else if (_salesStatisticsType == 1){
                if (([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailLabel] text] == nil)||([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] == nil)||([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)||[_costField.text isEqualToString:@""]) {
                    [Dialog simpleToast:@"不能有空信息"];
                }else{
                    self.navigationItem.rightBarButtonItem.action = nil;
                    [self showHintInView:self.view];
                    SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
                    //                来判断是编辑还是上报
                    if (_salesStatisticsModel.amountString) {
//                        [salesBll editsalesStatisticsData:^(SalesStatisticsModel *model) {
//                            [self hideHud];
//                            [self.navigationController  popViewControllerAnimated:YES];
//                            
//                        } salesStatisticsID:_salesStatisticsModel.salesStatisticsID
//                                                 Hospital:_salesStatisticsModel.hospitalID doctor:_salesStatisticsModel.doctorID production:_salesStatisticsModel.productionID count:_salesStatisticsModel.amountString pss:_salesStatisticsModel.buyerString];
//                        
                    }else{
                        
                        [salesBll addsalesStatisticsData:^(SalesStatisticsModel *model) {
                            [self hideHud];
                            [self.navigationController  popViewControllerAnimated:YES];
                            self.feedBackSalesStatisticsBlock(model);
                        } ContactModel:_contactModel  doctorsModel:_doctorsModel productionModel:_productionModel count:_costField.text pss:@"" category:[NSNumber numberWithInt:_salesStatisticsType] upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] price:nil viewCtrl:self];
                    }
                    
                }
 
                
            }else{
                
            }
        }break;
        case 4:{
            //拜访管理
            NSNumber * category;
            for (int i = 100; i < 102; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                if (button.selected == YES) {
                    if ([button.titleLabel.text isEqualToString:@"计划"]) {
                        category = @0;
                    }else{
                        category = @1;
                    }
                    break;
                }
            }
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            NSString *todayStr = [dateformatter stringFromDate:[NSDate date]];
            
            if (([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)||
                ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] == nil)||
                ([_contentTextView.text isEqualToString:@""])) {
                 [Dialog simpleToast:@"不能有空信息"];
            }else if ([category  isEqual: @0]){
                if ([[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] compare:todayStr] != 1) {
                     [Dialog simpleToast:@"计划拜访日期必须大于今日日期"];
                }else{
                    self.navigationItem.rightBarButtonItem.action = nil;
                    [self showHintInView:self.view];
                    CustomerVisitBll *customerVisitBll = [[CustomerVisitBll alloc]init];
                    [customerVisitBll addCustomerVisitData:^(CustomerVisitModel *model) {
                        [self hideHud];
                        [self.navigationController popViewControllerAnimated:YES];
                        [Dialog simpleToast:@"新建拜访成功"];
                    } Hospital:_customerArray[2] doctor:_customerArray[3] production:_customerArray[0] visitDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] content:_contentTextView.text category:category viewCtrl:self];
                }
            }else if ([category  isEqual: @1]){
                if ([[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] compare:todayStr] != 0) {

                     [Dialog simpleToast:@"临时拜访日期必须等于今日日期"];
                }else{
                    self.navigationItem.rightBarButtonItem.action = nil;
                    [self showHintInView:self.view];
                    CustomerVisitBll *customerVisitBll = [[CustomerVisitBll alloc]init];
                    [customerVisitBll addCustomerVisitData:^(CustomerVisitModel *model) {
                        [self hideHud];
                        [self.navigationController popViewControllerAnimated:YES];
                        [Dialog simpleToast:@"新建拜访成功"];
                    } Hospital:_customerArray[2] doctor:_customerArray[3] production:_customerArray[0] visitDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] detailLabel] text] content:_contentTextView.text category:category viewCtrl:self];
                }
            }

        }break;
        default:
            break;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textViewSelected = YES;
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)info

{
    
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
    _height = keyboardBounds.origin.y;
    if (textViewSelected) {
        if (keyboardBounds.size.height > 0) {
            float height1 = _tableView.frame.origin.y + _tableView.frame.size.height;
            
            if (height1 > _height) {
                _tableView.contentOffset = CGPointMake(0, height1 - _height-150);
                textViewSelected = NO;
                
            }
            
        }
        
    }
    
//     _distriTableView.frame = CGRectMake(100, 64, 200, 50*4);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    if (type == 4) {
//        NSUserDefaults *VisitDate = [NSUserDefaults standardUserDefaults];
//        [VisitDate setObject:textView.text forKey:@"content"];
//    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (type == 4) {
        NSUserDefaults *VisitDate = [NSUserDefaults standardUserDefaults];
        [VisitDate setObject:textView.text forKey:@"content"];
    }
}

- (void)keyboardWillHide:(NSNotification *)info

{
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (_distriTableView.frame.size.width != 0) {
        _distriTableView.frame = CGRectZero;
        [_tableView removeGestureRecognizer:_tapRecognizer];
    }
//    _distriTableView.frame = CGRectMake(100, 64, 200, 50*4 - _tableView.contentOffset.y);
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"feedbackHospitalModel" object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_titleField resignFirstResponder];
    [_contentTextView resignFirstResponder];
    //    [_travelWayField resignFirstResponder];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
