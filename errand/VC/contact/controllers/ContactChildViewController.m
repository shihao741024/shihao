//
//  ContactChildViewController.m
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "ContactChildViewController.h"
#import "StaffTableViewCell.h"
#import "DoctorModel.h"
#import "ContactBll.h"
#import "DoctorDetailViewController.h"
@interface ContactChildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)UIView *headerView;
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *companyLabel;

//默认的
@property (nonatomic, retain) UILabel *defaultStaffNameLabel;
@property (nonatomic, retain) UILabel *defaultdepartmentLabel;
@property (nonatomic, retain) UILabel *defaultpositionLabel;
@property (nonatomic, retain) UILabel *defaultphoneLabel;
//内容变化的
@property (nonatomic, retain) UILabel *staffNameLabel;
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, retain) UILabel *departmentLabel;
@property (nonatomic, retain) UILabel *positionLabel;
@property (nonatomic, retain) UILabel *phoneLabel;


@end

@implementation ContactChildViewController{
    UITableView *_tableView;
    NSMutableArray *_dataArrray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"hospitalDetail", @"hospitalDetail");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createData];
   
}
- (void)createData{

    _dataArrray = [NSMutableArray array];
    [self showHintInView:self.view];
    ContactBll *contactBll = [[ContactBll alloc]init];
    [contactBll getHospitalDetail:^(HospitalDetailModel *model) {
        _contactModel = model;
         [self createHeaderView];
    } hospitalID:_hospitalID viewCtrl:self];
  [contactBll getHospitalDoctor:^(NSArray *arr) {
       [self hideHud];
      
  } hospitalID:_hospitalID viewCtrl:self];
}
- (void)createHeaderView{
    CGSize staffNamesize = [self sizeWithString:self.contactModel.introduceString font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    
     CGSize positionsize = [self sizeWithString:self.contactModel.addressString font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    
    self.headerView = [[UIView alloc]init];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH , 180 + ((staffNamesize.height+2)>20?(staffNamesize.height+2):20) + ((positionsize.height+2)>20? (positionsize.height+2):20));
    self.headerView.backgroundColor = COMMON_BACK_COLOR;
    self.bgView = [[UIView alloc]init];
    
    self.bgView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 170 + ((staffNamesize.height+2)>20?(staffNamesize.height+2):20 )+ ((positionsize.height+2)>20?(positionsize.height+2):20));
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.bgView];
    [self createFixedView:_bgView
           andcompanyName:self.contactModel.hospitalName
andDefaultStaffNameString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"introduction", @"introduction")]
andDefaultDepartmentString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"level", @"level")]
 andDefaultPositionString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"address", @"address")]
    andDefaultphoneString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"telephone", @"telephone")]
       andStaffNameString:self.contactModel.introduceString
      andDepartmentString:self.contactModel.gradeString
        andPositionString:self.contactModel.addressString
           andPhoneString:self.contactModel.phoneString
            andViewType:kContact];
   
    [self createTableView];
    
}
- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.tableHeaderView = self.headerView;
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArrray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[StaffTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    DoctorModel *model;
    
    model = _dataArrray[indexPath.row];
    [cell.stateBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    cell.nameLabel.text = model.doctorName;
    cell.callPhoneBlock = ^(){
        [self openCall:model.phoneString];
    };
    cell.phoneNumLabel.text = model.phoneString;
    cell.backgroundColor = COMMON_BACK_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorDetailViewController *doctorDetail = [[DoctorDetailViewController alloc]init];
    doctorDetail.doctorModel = _dataArrray[indexPath.row];

    [self.navigationController pushViewController:doctorDetail animated:YES];
}
#pragma mark --- lable
- (UILabel *)createDefaultLabel:(NSString *)defaultString{
    UILabel *label = [[UILabel alloc]init];
    label.text = defaultString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:label];
    return label;
}
- (UILabel *)createLabel:(NSString *)string{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = string;
    [self.bgView addSubview:label];
    return label;
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
