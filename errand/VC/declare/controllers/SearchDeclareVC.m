//
//  SearchDeclareVC.m
//  errand
//
//  Created by wjjxx on 16/3/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "SearchDeclareVC.h"
#import "TaskEditTableViewCell.h"
#import "MMDateView.h"
#import "MMChoiceOneView.h"
#import "DeclareNameView.h"
#import "ProductionsViewController.h"
#import "ContactModel.h"
#import "DoctorsModel.h"
#import "ProductionModel.h"
#import "ContactViewController.h"
#import "ContactsViewController.h"
#import "ContactssViewController.h"

@interface SearchDeclareVC ()<UITableViewDelegate,UITableViewDataSource,MMDateViewDelegate,MMChoiceViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,WJJLabelDelegate,DeclareNameViewDelegate>

@property (nonatomic, strong)UITextField *titleField;
@property (nonatomic, strong)UITextField *useWayField;

@end

@implementation SearchDeclareVC{
    UITableView  *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray * _heightArray;
    
    UITextField *_contentField;

    //    审核状态
    NSArray *_statusArray;
    NSNumber *status;
    
    //成本客户需要的三个模型
    NSArray *_customerArray;
    NSNumber *_productionID;
     NSNumber *_contactID;
    NSNumber *_doctorsID;
    BOOL hasSearchArray;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *costomerArray = [NSUserDefaults standardUserDefaults];
    
    if ([costomerArray objectForKey:@"costomerArray"]) {
        _customerArray = [NSArray arrayWithArray:[costomerArray objectForKey:@"costomerArray"]];
        
        //NSArray *costomerArray = @[productdata,contactData,doctorsData];
        //数组 产品 医院 医生
        if (_customerArray.count == 3) {
            
//            id one = _customerArray[0];
//            if ([Function isBlankStrOrNull:one]) {
//                [costomerArray removeObjectForKey:@"costomerArray"];
//                return;
//            }
            
            ProductionModel *model1 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[0]];
            _productionID = model1.productID;
            TaskEditTableViewCell *productCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [productCell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@(%@)", model1.name, model1.specification] andIndex:1];
            
            TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            DoctorsModel *model2 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[2]];
            _doctorsID = model2.doctorID;
            [cell2.detailLabel setTextWithString:model2.name andIndex:1];
            
            ContactModel *model3 = [NSKeyedUnarchiver unarchiveObjectWithData:_customerArray[1]];
            _contactID = model3.hospitalID;
        }
        [costomerArray removeObjectForKey:@"costomerArray"];
    }
    

    if (_searchArray.count > 0) {
        
        hasSearchArray = YES;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *costomerArray = [NSUserDefaults standardUserDefaults];
    [costomerArray removeObjectForKey:@"costomerArray"];
    [self createRightItem];
    [self initView];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveHospitalName:) name:@"feedbackHospitalModel" object:nil ];
    // Do any additional setup after loading the view.
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(fillInfoData) userInfo:nil repeats:NO];
}

- (void)fillInfoData
{
    if (_saveDic != nil) {
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.detailLabel setTextWithString:_saveDic[@"title"] andIndex:0];
        
        TaskEditTableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell1.detailLabel setTextWithString:_saveDic[@"productStr"] andIndex:1];
        
        TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell2.detailLabel setTextWithString:_saveDic[@"customer"] andIndex:2];
        
        TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        [cell3.detailLabel setTextWithString:_saveDic[@"statusStr"] andIndex:5];
        
        _contentField.text = _saveDic[@"contentField"];
        
        _useWayField.text = _saveDic[@"useWayField"];
        _titleField.text = _saveDic[@"titleField"];
        status = _saveDic[@"status"];
        
        _productionID = _saveDic[@"productionID"];
        _contactID = _saveDic[@"contactID"];
        _doctorsID = _saveDic[@"doctorsID"];
        
    }
//    (title,customer,_useWayField.text,_contentField.text,_titleField.text,statusStr,status,_productionID,_contactID,_doctorsID, saveDic);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)reciveHospitalName:(NSNotification*)notification{
    
    ContactModel *model = notification.object[0];
    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell2.detailLabel setTextWithString:model.hospitalName andIndex:1];
    _contactID = model.hospitalID;
    
//    ProductionModel *model2 = notification.object[1];
//    _productionID = model2.productID;
    
    _doctorsID = ImpossibleNSNumber;
    
}
- (void)createRightItem{
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = NSLocalizedString(@"high-search", @"high-search");
    [self addBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"search", @"search") style:UIBarButtonItemStyleDone target:self action:@selector(searchClick)];
}
- (void)searchClick{
    
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *title = cell.detailLabel.text;
    
    TaskEditTableViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *productStr = cell1.detailLabel.text;
    
    TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *customer = cell2.detailLabel.text;
  
    TaskEditTableViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *statusStr = cell3.detailLabel.text;
    
//    NSString *title,NSString *customerName,NSString *useWay,NSString *aim,NSString *remark,NSString *statusStr,NSNumber* status,NSNumber *productID,NSNumber *hospitalID,NSNumber *doctorID
    
    NSMutableDictionary *saveDic = [self addParameterInDic:title customer:customer statusStr:statusStr productStr:productStr];
    
    self.feedBackDeclareSearchDataBlock(title,customer,_useWayField.text,_contentField.text,_titleField.text,statusStr,status,_productionID,_contactID,_doctorsID, productStr,saveDic);
    
//    Name:[[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailLabel] text] Hospital:_contactModel.hospitalID doctor:_doctorsModel == nil ?  ImpossibleNSNumber :_doctorsModel.doctorID           production:_productionModel.productID description:_useWayField.text cost:_costField.text goal:_titleField.text remark:_contentTextView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (NSMutableDictionary *)addParameterInDic:(NSString *)title customer:(NSString *)customer statusStr:(NSString *)statusStr productStr:(NSString *)productStr
{
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    [saveDic setObject:title forKey:@"title"];
    [saveDic setObject:customer forKey:@"customer"];
    [saveDic setObject:_useWayField.text forKey:@"useWayField"];
    
    [saveDic setObject:_contentField.text forKey:@"contentField"];
    [saveDic setObject:_titleField.text forKey:@"titleField"];
    [saveDic setObject:statusStr forKey:@"statusStr"];
    
    [saveDic setObject:status forKey:@"status"];
    [saveDic setObject:_productionID forKey:@"productionID"];
    [saveDic setObject:_contactID forKey:@"contactID"];
    
    [saveDic setObject:_doctorsID forKey:@"doctorsID"];
    [saveDic setObject:[NSNumber numberWithInteger:_type] forKey:@"type"];
    [saveDic setObject:productStr forKey:@"productStr"];
    
    return saveDic;
}

- (void)createTextField{
    //备注
    UITextField *titleField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    titleField.textColor = COMMON_FONT_BLACK_COLOR;
    titleField.clearButtonMode = UITextFieldViewModeAlways;
    titleField.font = [UIFont systemFontOfSize:14];
    _titleField= titleField;
    //使用方式
    UITextField *useWayField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    useWayField.textColor = COMMON_FONT_BLACK_COLOR;
    useWayField.clearButtonMode = UITextFieldViewModeAlways;
    useWayField.font = [UIFont systemFontOfSize:14];
    _useWayField = useWayField;
    
    //费用目的
    UITextField *contentField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 110, 50)];
    contentField.textColor = COMMON_FONT_BLACK_COLOR;
    contentField.clearButtonMode = UITextFieldViewModeAlways;
    contentField.font = [UIFont systemFontOfSize:14];
    _contentField = contentField;
}
- (void)initView{
    
    
    [self createTextField];
    
    _statusArray = @[@"待审核",@"审批中",@"已驳回",@"已批准"];
    
    //区分没有这两个搜索条件的时候
    status = ImpossibleNSNumber;
    _productionID = ImpossibleNSNumber;
    _contactID = ImpossibleNSNumber;
    _doctorsID = ImpossibleNSNumber;
    
    NSArray *dataArray = @[NSLocalizedString(@"PRO_Name", @"PRO_Name"),@"产品规格:",NSLocalizedString(@"COST_Client", @"COST_Client"), NSLocalizedString(@"USE_Way",@"USE_Way"),NSLocalizedString(@"BUDGET_Aim",@"BUDGET_Aim"),NSLocalizedString(@"check_status:", @"check_status:")];
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
//    (NSString *title,NSString *customerName,NSString *useWay,NSString *aim,NSString *remark,NSString *statusStr,NSNumber* status,NSNumber *productID,NSNumber *hospitalID,NSNumber *doctorID)
    //如果搜索的数组有值，那就加在视图上
    if (hasSearchArray == YES) {
        if (indexPath.row == 0) {
            [cell.detailLabel setTextWithString:_searchArray[0] andIndex:indexPath.row];
        }
        if (indexPath.row == 1) {
            [cell.detailLabel setTextWithString:_searchArray[10] andIndex:indexPath.row];
        }
        if (indexPath.row == 2) {
            if (![_productionID  isEqual: ImpossibleNSNumber]) {
                 [cell.detailLabel setTextWithString:_searchArray[1] andIndex:indexPath.row];
                _productionID = _searchArray[7];
                _contactID = _searchArray[8];
                _doctorsID = _searchArray[9];

            }else{
                cell.detailLabel.text = @"请选择医院或医生";
                cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
            }
           
        }
        if (indexPath.row == 3) {
           [cell addSubview:_useWayField];
            
            _useWayField.text = _searchArray[2];
            
        }
        if (indexPath.row == 4) {
            
            [cell addSubview:_contentField];
            _contentField.text = _searchArray[3];
            
        }
//        if (indexPath.row == 4) {
//            
//            [cell addSubview:_titleField];
//            _titleField.text = _searchArray[4];
//            
//        }
        if (indexPath.row == 5) {
            [cell.detailLabel setTextWithString:_searchArray[5] andIndex:indexPath.row];
             status = _searchArray[6];
        }
      
    }
    else{
//        if (indexPath.row == 0) {
//            cell.detailLabel.text = @"请选择项目名称";
//        }
        if (indexPath.row == 2) {
            cell.detailLabel.text = @"请选择医院或医生";
            cell.detailLabel.textColor = COMMON_FONT_GRAY_COLOR;
        }
        if (indexPath.row == 3) {
            [cell addSubview:_useWayField];
        }
        if (indexPath.row == 4) {
            [cell addSubview:_contentField];
        }
//        if (indexPath.row == 4) {
//            [cell addSubview:_titleField];
//        }
        
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
        case 0:{
            DeclareNameView *view = [[DeclareNameView alloc]init];
            view.delegate = self;
            [self.view addSubview:view];

        }break;
        case 1:{
            ProductionsViewController *productionsVC = [[ProductionsViewController alloc]init];
            productionsVC.type = 0;
            productionsVC.allProduct = YES;
            [self.navigationController pushViewController:productionsVC animated:YES];
            
            [productionsVC setFeedBackProductionModelBlock:^(ProductionModel *model) {
                
                _productionID = model.productID;
                TaskEditTableViewCell *productCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [productCell.detailLabel setTextWithString:[NSString stringWithFormat:@"%@(%@)", model.name, model.specification] andIndex:1];
            }];
            
        }break;
        case 2:{
            ContactssViewController *productionsVC = [[ContactssViewController alloc]init];
            productionsVC.type = 6;
            productionsVC.allProduct = YES;
            [self.navigationController pushViewController:productionsVC animated:YES];
            
            [productionsVC setFeedBackHospitalAndDoctor:^(ContactModel *contactModel, DoctorsModel *doctorModel) {
                
                
                TaskEditTableViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                [cell2.detailLabel setTextWithString:doctorModel.name andIndex:1];
                _contactID = contactModel.hospitalID;
                
                //    ProductionModel *model2 = notification.object[1];
                //    _productionID = model2.productID;
                
                _doctorsID = doctorModel.doctorID;
            }];
            
        }break;
        case 5:{
            [self.view endEditing:YES];
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
 if (picker.tag == 6){
        int row =(int) [picker selectedRowInComponent:0];
        //    99终审 90审核并上报  0 待审核 -1审核不通过 @[@"待审核",@"审批中",@"已驳回",@"已批准"];
        if (row == 0) {
            status = @0;
        }else if (row == 1){
            status = @90;
        }else if (row == 2){
            status = @-1;
        }else if (row == 3){
            status = @99;
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
        TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.detailLabel setTextWithString:_statusArray[row] andIndex:indexPath.row];
    }
    
}
// 返回1表明该控件只包含1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
   
    return 1;
}
//一列中有三行
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
   
        return _statusArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _statusArray[row];
   
}

#pragma mark ---  DeclareNameViewdelegate
- (void)selectDeclareName:(NSString *)name{
    
    TaskEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.detailLabel setTextWithString:name andIndex:0];
    
}

#pragma mark - WJJLabelDelegate
- (void)changeDataSourceWithIndex:(NSInteger)index {
    
    if (index == 2) {
        
        _productionID = ImpossibleNSNumber;
        _contactID = ImpossibleNSNumber;
        _doctorsID = ImpossibleNSNumber;
        
    }
   if (index == 5){
        status = ImpossibleNSNumber;
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
