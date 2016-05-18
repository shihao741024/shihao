//
//  StatisticsEdittingVC.m
//  errand
//
//  Created by wjjxx on 16/2/24.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "StatisticsEdittingVC.h"
#import "TaskEditTableViewCell.h"
#import "MMDateView.h"
#import "MMChoiceOneView.h"
#import "MMAlertView.h"
#import "SalesStatisticsBll.h"
#import "ProductionsViewController.h"
#import "ContactViewController.h"
#import "CommonBll.h"
#import "DistriModel.h"
#import "DistriTableView.h"
#import "DistributionView.h"
#import "CompetitionVC.h"
@interface StatisticsEdittingVC ()<UITableViewDataSource, UITableViewDelegate,MMDateViewDelegate,MMChoiceViewDelegate,UIPickerViewDelegate,UITextFieldDelegate,DistriTableViewDelegate,DistributionViewDelegate>
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong)UITextField *titleField;
@property (nonatomic, strong)UITextField *costField;
@property (nonatomic, strong)UITextField *moneyField;
@property (nonatomic, strong)UILabel *packageUnitLabel;;

@end

@implementation StatisticsEdittingVC {
    
    UITableView   *_tableView;
    
    UIView *_bgView;
    
    NSMutableArray *_heightArray;

    float _height;
    
    
    NSArray *_customerArray;
    
    NSNumber *_staffID;
    
    ProductionModel *_productionModel;
    
    ContactModel *_contactModel;
    
    DoctorsModel *_doctorsModel;
    
    NSMutableArray *_distriArray;
    
    NSMutableArray *_searchDistriArray;
    
    DistriTableView *_distriTableView;
    
    UITapGestureRecognizer *_tapRecognizer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self createTableView];
    [self createTextField];
    [self setNavRightBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_titleField];
    
    NSUserDefaults *costomerArray = [NSUserDefaults standardUserDefaults];
    
    if ([costomerArray objectForKey:@"costomerArray"]) {
        _customerArray = [NSArray arrayWithArray:[costomerArray objectForKey:@"costomerArray"]];
        //数组 产品 医院 医生
        if (_customerArray.count == 2) {
            TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            ProductionModel *model1 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[0]];
            cell.detailLabel.text =  cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",model1.name,model1.specification];
            _productionModel = model1;
            
            if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
                _packageUnitLabel.text = @"";
            }else {
                _packageUnitLabel.text = _productionModel.packageUnit;
            }
            
            TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            ContactModel *model2 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[1]];
            cell2.detailLabel.text = model2.hospitalName;
            _contactModel = model2;

        }else if (_customerArray.count == 3){
            //如果第一个元素是空字符 说明是竞品
            if ([_customerArray[0] isKindOfClass:[NSString class]]) {
                ContactModel *model2 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[1]];
                _contactModel = model2;
                
                TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                DoctorsModel *model3 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[2]];
                cell2.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",model3.name,_contactModel.hospitalName];
                _doctorsModel = model3;

            }else{
                TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                ProductionModel *model1 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[0]];
                cell.detailLabel.text =  cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",model1.name,model1.specification];
                _productionModel = model1;
                
//                if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
//                    _packageUnitLabel.text = @"";
//                }else {
//                    _packageUnitLabel.text = _productionModel.packageUnit;
//                }
                
                ContactModel *model2 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[1]];
                _contactModel = model2;
                
                TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                DoctorsModel *model3 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[2]];
                cell2.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",model3.name,_contactModel.hospitalName];
                _doctorsModel = model3;
            }
           
        }
         [costomerArray removeObjectForKey:@"costomerArray"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)createHeight{
    
    _heightArray = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++) {
        
            [_heightArray addObject:@50];
        
    }
}
// 设置“提交”按钮 和左侧返回按钮
- (void)setNavRightBtn {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    // 来判断是编辑还是上报
            if (_salesStatisticsModel.amountString) {
                
                if ((_salesStatisticsType == 0 )||(_salesStatisticsType == 2)) {
                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.detailLabel.text = _salesStatisticsModel.pillName;
                    
                    if (_salesStatisticsType == 2 ){
                        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell2.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",_salesStatisticsModel.name,_salesStatisticsModel.hospitalName];;
                    }else{
                        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell2.detailLabel.text = _salesStatisticsModel.hospitalName;
                    }
                   
                    
                    TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell3.detailLabel.text = _salesStatisticsModel.dateString;
                    
                    _costField.text = _salesStatisticsModel.amountString;
                    
                    if (![Function isNullOrNil:_salesStatisticsModel.price]) {
                        _moneyField.text = [NSString stringWithFormat:@"%@", _salesStatisticsModel.price];
                    }
                    if (![Function isBlankStrOrNull:_salesStatisticsModel.packageUnit]) {
                        _packageUnitLabel.text = _salesStatisticsModel.packageUnit;
                    }
                    
                    _titleField.text = _salesStatisticsModel.buyerString;

                }else if (_salesStatisticsType == 1){
                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.detailLabel.text = _salesStatisticsModel.pillName;
                    
                    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    cell2.detailLabel.text =  cell2.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",_salesStatisticsModel.name,_salesStatisticsModel.hospitalName];
;
                    
                    TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    cell3.detailLabel.text = _salesStatisticsModel.dateString;
                    
                    _costField.text = _salesStatisticsModel.amountString;
                    if (![Function isBlankStrOrNull:_salesStatisticsModel.packageUnit]) {
                        _packageUnitLabel.text = _salesStatisticsModel.packageUnit;
                    }
                }
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
    titleField.font = [UIFont systemFontOfSize:14];
    _titleField= titleField;
    
    UITextField *costField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 100, 50)];
    costField.textColor = COMMON_FONT_BLACK_COLOR;
    costField.font = [UIFont systemFontOfSize:14];
    _costField = costField;
    _costField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField *moneyField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 100, 50)];
    moneyField.textColor = COMMON_FONT_BLACK_COLOR;
    moneyField.font = [UIFont systemFontOfSize:14];
    _moneyField = moneyField;
    _moneyField.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *packageUnit = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40, 0, 40, 50)];
    packageUnit.font = GDBFont(14);
    packageUnit.textAlignment = NSTextAlignmentCenter;
    _packageUnitLabel = packageUnit;
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
        cell.tag = indexPath.item;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        //0 销售上报  1 传销上报  2 竞品上报
        if ((_salesStatisticsType == 0)||(_salesStatisticsType == 2)) {
            if (indexPath.item == 0) {
        
                cell.detailLabel.text = @"请选择产品";
            }
            if (indexPath.item == 1) {
                if (_salesStatisticsType == 0) {
                    cell.detailLabel.text = @"请选择医院";
                }else {
                    cell.detailLabel.text = @"请选择医生";
                }
                
                
            }
            if (indexPath.item == 3) {
                [cell addSubview:_costField];
                [cell addSubview:_packageUnitLabel];
            }
            if (indexPath.item == 4) {
                _titleField.placeholder = @"填写配送商业或者选择";
                _titleField.frame = CGRectMake(100, 0, SCREEN_WIDTH - 160, 50);
                [cell addSubview:_titleField];
                _titleField.delegate = self;
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
            if (indexPath.item == 5) {
                [cell addSubview:_moneyField];
            }
        }else if (_salesStatisticsType == 1){
            if (indexPath.item == 0) {
                cell.detailLabel.text = @"请选择产品";
            }
            if (indexPath.item == 1) {
                cell.detailLabel.text = @"请选择医生";
            }
            if (indexPath.item == 2) {
                [cell addSubview:_costField];
                [cell addSubview:_packageUnitLabel];
            }
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
    if (_salesStatisticsType == 0) {
        switch (indexPath.item) {
            case 0:
            {
                //如果之前已经选择过 并且医院也选择过 则把医院的数据清空   或者是编辑状态 也数据清空
                if ((_productionModel.productID&&_contactModel.hospitalID)||_salesStatisticsModel.productionID) {
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    productionsVC.type = 0;
                    [self.navigationController pushViewController:productionsVC animated:YES];
                    productionsVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                        _productionModel = productionModel;
                        _doctorsModel = nil;
                        
                        if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
                            _packageUnitLabel.text = @"";
                        }else {
                            _packageUnitLabel.text = _productionModel.packageUnit;
                        }
                        
                        //编辑状态的医院无效
                        _salesStatisticsModel.hospitalID = nil;
                        
                        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell2.detailLabel.text = @"请选择医院";
                    };
                   
                }else{
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    productionsVC.type = 0;
                    [self.navigationController pushViewController:productionsVC animated:YES];
                    productionsVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                        _productionModel = productionModel;
                        
                        if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
                            _packageUnitLabel.text = @"";
                        }else {
                            _packageUnitLabel.text = _productionModel.packageUnit;
                        }
                    };
                }
                
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
                }
                //当药品没有选择 但处于编辑状态下
                else if (_salesStatisticsModel.productionID){
                    ContactViewController *contactVC = [[ContactViewController alloc]init];
                    contactVC.type = 1;
                    _productionModel = [[ProductionModel alloc]init];
                    _productionModel.productID = _salesStatisticsModel.productionID;
                    _productionModel.specification = _salesStatisticsModel.specification;
                    _productionModel.name = _salesStatisticsModel.productName;
                    contactVC.productModel = _productionModel;
                    [self.navigationController pushViewController:contactVC animated:YES];
                    contactVC.feedBackContactModelBlock= ^(ContactModel *contactModel) {
                        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell.detailLabel.text = contactModel.hospitalName;
                        _contactModel = contactModel;
                    };
 
                }
                else{
                    //否则 先进入药品 再跳到医院
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    productionsVC.type = 1;
                    [self.navigationController pushViewController:productionsVC animated:YES];
                }
                
            }break;
            case 2:{
                [self.view endEditing:YES];
                MMDateView *dateView = [MMDateView new];
                dateView.datePicker.datePickerMode = UIDatePickerModeDate;
                dateView.centerLabel.text = @"上报时间";
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
                //如果之前已经选择过 并且医院也选择过 则把医院的数据清空   或者是编辑状态 也数据清空
                if ((_productionModel.productID&&_contactModel.hospitalID)||_salesStatisticsModel.productionID) {
                ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                [self.navigationController pushViewController:productionsVC animated:YES];
                productionsVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                    _productionModel = productionModel;
                    _contactModel = nil;
                    _doctorsModel = nil;
                    
                    if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
                        _packageUnitLabel.text = @"";
                    }else {
                        _packageUnitLabel.text = _productionModel.packageUnit;
                    }
                    
                    //编辑状态的医院无效
                    _salesStatisticsModel.hospitalID = nil;
                    
                    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    cell2.detailLabel.text = @"请选择医生";
                };
                   
                }else{
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    [self.navigationController pushViewController:productionsVC animated:YES];
                    productionsVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                        _productionModel = productionModel;
                        
                        if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
                            _packageUnitLabel.text = @"";
                        }else {
                            _packageUnitLabel.text = _productionModel.packageUnit;
                        }
                    };
                }
            }break;
            case 1:{
                //当药品已经选择了 先进入医院 最后跳到医生
                if (_productionModel.productID) {
                    ContactViewController *contactVC = [[ContactViewController alloc]init];
                    contactVC.type = 2;
                    if (self.navigationController.viewControllers.count == 5) {
                        contactVC.popIndex = 4;
                    }
                    
                    contactVC.productModel = _productionModel;
                    [self.navigationController pushViewController:contactVC animated:YES];
                   
                }
                //当药品没有选择 但处于编辑状态下
                else if (_salesStatisticsModel.productionID){
                    ContactViewController *contactVC = [[ContactViewController alloc]init];
                    contactVC.type = 2;
                    if (self.navigationController.viewControllers.count == 5) {
                        contactVC.popIndex = 4;
                    }
                    _productionModel = [[ProductionModel alloc]init];
                    _productionModel.productID = _salesStatisticsModel.productionID;
                    _productionModel.specification = _salesStatisticsModel.specification;
                    _productionModel.name = _salesStatisticsModel.productName;
                    contactVC.productModel = _productionModel;
                    [self.navigationController pushViewController:contactVC animated:YES];
                }
                else{
                    //否则 先进入药品 再跳到医院 最后跳到医生
                    ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
                    productionsVC.type = 2;
                    if (self.navigationController.viewControllers.count  == 5) {
                        productionsVC.popIndex = 4;
                    }
                    [self.navigationController pushViewController:productionsVC animated:YES];
                   
                }
            }break;
            case 3:{
                [self.view endEditing:YES];
                MMDateView *dateView = [MMDateView new];
                dateView.datePicker.datePickerMode = UIDatePickerModeDate;
                dateView.centerLabel.text = @"上报时间";
                dateView.delegate=self;
                dateView.datePicker.tag=4;
                [dateView showWithBlock:nil];
            }break;
            default:
                break;
        }
    }else{
        //竞品上报
        switch (indexPath.item) {
            case 0:
            {
                CompetitionVC *competitionVC = [[CompetitionVC alloc]init];
                [self.navigationController pushViewController:competitionVC animated:YES];
                competitionVC.feedBackProductionModelBlock = ^(ProductionModel *productionModel){
                    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@(%@)",productionModel.name,productionModel.specification];
                    _productionModel = productionModel;
                    
                    if ([Function isBlankStrOrNull:_productionModel.packageUnit]) {
                        _packageUnitLabel.text = @"";
                    }else {
                        _packageUnitLabel.text = _productionModel.packageUnit;
                    }

                };
            }break;
            case 1:{
//                进入医院 在进入医生
                ContactViewController *contactVC = [[ContactViewController alloc]init];
                contactVC.type = 5;
                
                if (self.navigationController.viewControllers.count == 5) {
                    contactVC.popIndex = 4;
                }
//                contactVC.productModel = _productionModel;
                [self.navigationController pushViewController:contactVC animated:YES];
            }break;
            case 2:{
                [self.view endEditing:YES];
                MMDateView *dateView = [MMDateView new];
                dateView.datePicker.datePickerMode = UIDatePickerModeDate;
                dateView.centerLabel.text = @"上报时间";
                dateView.delegate=self;
                dateView.datePicker.tag=3;
                [dateView showWithBlock:nil];
            }break;
            default:
                break;
        }
        
        
    }
}

#pragma mark - 实现textFieldChanged函数

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    if (_contactModel.provincial) {
        DistributionView *distributionView = [[DistributionView alloc]initWithFrame:CGRectZero provincial:_contactModel.provincial city:_contactModel.city];
        distributionView.delegate = self;
        [self.view addSubview:distributionView];
        
        
    }else if (_salesStatisticsModel.hospitalID){
        DistributionView *distributionView = [[DistributionView alloc]initWithFrame:CGRectZero provincial:_salesStatisticsModel.provincial city:_salesStatisticsModel.city];
        distributionView.delegate = self;
        [self.view addSubview:distributionView];
    }
    else{
        [Dialog simpleToast:@"请先选择医院"];
    }
    
}
#pragma mark --- DistributionViewDelegate
- (void)selectPss:(NSString *)pss{
    _titleField.text = pss;
}

#pragma mark - MMChoiceDateViewChoicedDelegate

-(void)MMChoiceDateViewChoiced:(UIDatePicker*)picker{
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
}

- (void)submitClick {
    
    //让键盘收起
    [_titleField resignFirstResponder];
    [_costField resignFirstResponder];
    [_moneyField resignFirstResponder];
    
    if (_salesStatisticsType == 0) {
        if (((_productionModel == nil)&&(_salesStatisticsModel == nil))||
            ((_contactModel == nil)&&(_salesStatisticsModel.hospitalID == nil))
            ||([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)
            ||[_costField.text isEqualToString:@""]) {
            
            [Dialog simpleToast:@"相关信息未完善"];
        }else{
            self.navigationItem.rightBarButtonItem.action = nil;
            [self showHintInView:self.view];
            SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
            //                来判断是编辑还是上报
           
            if (_salesStatisticsModel.amountString) {
                NSNumber * productID;
                NSString * specification;
                NSString * productName;
                NSNumber *hospitalID;
                NSString *hospitalName;
                NSString *provincial;
                NSString *city;
                NSString *price = _moneyField.text;
                
               
                if (_productionModel == nil) {
                     productID = _salesStatisticsModel.productionID;
                     specification = _salesStatisticsModel.specification;
                     productName = _salesStatisticsModel.productName;
                }else{
                    productID = _productionModel.productID;
                    specification = _productionModel.specification;
                    productName = _productionModel.name;
                }
                if (_contactModel == nil) {
                   hospitalID = _salesStatisticsModel.hospitalID;
                   hospitalName = _salesStatisticsModel.hospitalName;
                    provincial = _salesStatisticsModel.provincial;
                    city = _salesStatisticsModel.city;
                }else{
                    hospitalID = _contactModel.hospitalID;
                    hospitalName = _contactModel.hospitalName;
                    provincial = _contactModel.provincial;
                    city = _contactModel.city;
                }
                [salesBll editsalesStatisticsData:^(SalesStatisticsModel *model) {
                   
                    [self hideHud];
                    [self.navigationController  popViewControllerAnimated:YES];
                    
                    self.feedBackEditSalesStatisticsBlock(_indexPath,model);
                    
                }salesStatisticsID:_salesStatisticsModel.salesStatisticsID hospitalID:hospitalID hospitalName:hospitalName provincial:provincial city:city doctorID:@1 doctorName:@"" office:@"" productID:productID specification:specification productName:productName count:_costField.text pss:_titleField.text category:@0 upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] price:price packageUnit:_packageUnitLabel.text viewCtrl:self];
            }else{
                
                [salesBll addsalesStatisticsData:^(SalesStatisticsModel *model) {
                    [self hideHud];
                    [self.navigationController  popViewControllerAnimated:YES];
                    self.feedBackSalesStatisticsBlock(model);
                } ContactModel:_contactModel  doctorsModel:_doctorsModel productionModel:_productionModel count:_costField.text pss:_titleField.text category:[NSNumber numberWithInt:_salesStatisticsType] upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] price:_moneyField.text viewCtrl:self];
            }
            
        }
        
    }else if (_salesStatisticsType == 1){
        if (((_productionModel == nil)&&(_salesStatisticsModel == nil))||
            ((_contactModel == nil)&&(_salesStatisticsModel.hospitalID == nil))||
            ([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] == nil)||
            [_costField.text isEqualToString:@""]) {
            [Dialog simpleToast:@"相关信息未完善"];
        }else{
            self.navigationItem.rightBarButtonItem.action = nil;
            [self showHintInView:self.view];
            SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
            //来判断是编辑还是上报
            if (_salesStatisticsModel.amountString) {
                
                NSNumber * productID;
                NSString * specification;
                NSString * productName;
                NSNumber *hospitalID;
                NSString *hospitalName;
                NSNumber *doctorID;
                NSString *doctorName;
                NSString *provincial;
                NSString *city;
                 NSString *office;
                if (_productionModel == nil) {
                    productID = _salesStatisticsModel.productionID;
                    specification = _salesStatisticsModel.specification;
                    productName = _salesStatisticsModel.productName;
                }else{
                    productID = _productionModel.productID;
                    specification = _productionModel.specification;
                    productName = _productionModel.name;
                }
                if (_contactModel == nil) {
                    hospitalID = _salesStatisticsModel.hospitalID;
                    hospitalName = _salesStatisticsModel.hospitalName;
                    doctorID = _salesStatisticsModel.doctorID;
                    doctorName = _salesStatisticsModel.name;
                    provincial = _salesStatisticsModel.provincial;
                    city = _salesStatisticsModel.city;
                    office = _salesStatisticsModel.office;
                    
                }else{
                    hospitalID = _contactModel.hospitalID;
                    hospitalName = _contactModel.hospitalName;
                    doctorID = _doctorsModel.doctorID;
                    doctorName = _doctorsModel.name;
                    provincial = _contactModel.provincial;
                    city = _contactModel.city;
                    office = _doctorsModel.office;
                }
              [salesBll editsalesStatisticsData:^(SalesStatisticsModel *model) {
                
                  [self hideHud];
                  [self.navigationController  popViewControllerAnimated:YES];
                  self.feedBackEditSalesStatisticsBlock(_indexPath,model);

                  
              }salesStatisticsID:_salesStatisticsModel.salesStatisticsID hospitalID:hospitalID hospitalName:hospitalName provincial:provincial city:city  doctorID:doctorID doctorName:doctorName office:office productID:productID specification:specification productName:productName count:_costField.text pss:_titleField.text category:@1 upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] price:_moneyField.text packageUnit:_packageUnitLabel.text viewCtrl:self];
            }else{
                
                [salesBll addsalesStatisticsData:^(SalesStatisticsModel *model) {
                    [self hideHud];
                    [self.navigationController  popViewControllerAnimated:YES];
                    self.feedBackSalesStatisticsBlock(model);
                } ContactModel:_contactModel  doctorsModel:_doctorsModel productionModel:_productionModel count:_costField.text pss:@"" category:[NSNumber numberWithInt:_salesStatisticsType] upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] detailLabel] text] price:_moneyField.text viewCtrl:self];
            }
            
        }
        
        
    }else{
        if (((_productionModel == nil)&&(_salesStatisticsModel == nil))||
            ((_contactModel == nil)&&(_salesStatisticsModel.hospitalID == nil))
            ||([[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] == nil)
            ||[_costField.text isEqualToString:@""]) {
            [Dialog simpleToast:@"相关信息未完善"];
        }else{
            self.navigationItem.rightBarButtonItem.action = nil;
            [self showHintInView:self.view];
            SalesStatisticsBll *salesBll = [[SalesStatisticsBll alloc]init];
            // 来判断是编辑还是上报
            if (_salesStatisticsModel.amountString) {
                //
                NSNumber * productID;
                NSString * specification;
                NSString * productName;
                NSNumber *hospitalID;
                NSString *hospitalName;
                NSNumber *doctorID;
                NSString *doctorName;
                NSString *provincial;
                NSString *city;
                NSString *office;
                if (_productionModel == nil) {
                    productID = _salesStatisticsModel.productionID;
                    specification = _salesStatisticsModel.specification;
                    productName = _salesStatisticsModel.productName;
                }else{
                    productID = _productionModel.productID;
                    specification = _productionModel.specification;
                    productName = _productionModel.name;
                }
                if (_contactModel == nil) {
                    hospitalID = _salesStatisticsModel.hospitalID;
                    hospitalName = _salesStatisticsModel.hospitalName;
                    doctorID = _salesStatisticsModel.doctorID;
                    doctorName = _salesStatisticsModel.name;
                    provincial = _salesStatisticsModel.provincial;
                    city = _salesStatisticsModel.city;
                    office = _salesStatisticsModel.office;
                }else{
                    hospitalID = _contactModel.hospitalID;
                    hospitalName = _contactModel.hospitalName;
                    doctorID = _doctorsModel.doctorID;
                    doctorName = _doctorsModel.name;
                    provincial = _contactModel.provincial;
                    city = _contactModel.city;
                    office = _doctorsModel.office;
                }

                [salesBll editsalesStatisticsData:^(SalesStatisticsModel *model) {
                   
                    [self hideHud];
                    [self.navigationController  popViewControllerAnimated:YES];
                    self.feedBackEditSalesStatisticsBlock(_indexPath,model);

                } salesStatisticsID:_salesStatisticsModel.salesStatisticsID hospitalID:hospitalID hospitalName:hospitalName provincial:provincial city:city   doctorID:doctorID doctorName:doctorName office:office productID:productID specification:specification productName:productName count:_costField.text pss:_titleField.text category:@2 upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] price:_moneyField.text packageUnit:_packageUnitLabel.text  viewCtrl:self];
                
            }else{
                
                [salesBll addsalesStatisticsData:^(SalesStatisticsModel *model) {
                    [self hideHud];
                    [self.navigationController  popViewControllerAnimated:YES];
                    self.feedBackSalesStatisticsBlock(model);
                } ContactModel:_contactModel  doctorsModel:_doctorsModel productionModel:_productionModel count:_costField.text pss:_titleField.text category:[NSNumber numberWithInt:_salesStatisticsType] upDate:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailLabel] text] price:_moneyField.text viewCtrl:self];
            }
            
        }

    }
}

- (void)keyboardWillShow:(NSNotification *)info

{
    
    CGRect keyboardBounds = [[[info userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
    _height = keyboardBounds.origin.y;

}

- (void)keyboardWillHide:(NSNotification *)info

{
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (_distriTableView.frame.size.width != 0) {
        _distriTableView.frame = CGRectZero;
        [_tableView removeGestureRecognizer:_tapRecognizer];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_titleField resignFirstResponder];
    [_costField resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

