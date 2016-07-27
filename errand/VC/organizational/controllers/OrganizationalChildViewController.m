//
//  WjjViewController.m
//  errand
//
//  Created by gravel on 15/12/14.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "OrganizationalChildViewController.h"
#import "OrganizationChildTableViewCell.h"

@interface OrganizationalChildViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titleArray;
    UITableView *_tableView;
    NSArray *_dataArray;
}
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UIButton *messageButton;
@property (nonatomic, retain) UIButton *phoneButton;

@end

@implementation OrganizationalChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"staffDetail", @"staffDetail");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
//    [self createView];
    
    [self dataConfig];
    [self uiConfig];
}

- (void)dataConfig
{
    NSLog(@"OrganizationalChildViewController%@", _staffModel.originalDic);
    _titleArray = @[@"员工姓名：", @"所属部门：", @"联系电话：", @"微信：", @"邮箱："];
    NSString *staffName = [self strIsNull:_staffModel.staffName];
    NSString *departmentName = [self strIsNull:_staffModel.departmentName];
    NSString *phoneNumber = [self strIsNull:_staffModel.phoneNumber];
    NSString *weixin = [self strIsNull:_staffModel.weixin];
    NSString *email = [self strIsNull:_staffModel.email];
    _dataArray = @[staffName, departmentName,phoneNumber,weixin,email];
}

-(NSString *)strIsNull:(NSString *)str{
    if ([str isEqual:[NSNull null]] || str == nil) {
        return @"";
    }
    return str;
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64+10, kWidth-20, kHeight-64-20) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.layer.cornerRadius = 15;
    _tableView.clipsToBounds = YES;
    _tableView.bounces = NO;
    
    CGFloat theW = (kWidth-140)/3.0;
    UIButton *msgButton = [self createButton:@"message_normal"];
    msgButton.frame = CGRectMake(theW, kHeight-50-70, 70, 70);
    [msgButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phoneButton = [self createButton:@"phone"];
    phoneButton.frame = CGRectMake(theW*2+70, kHeight-50-70, 70, 70);
    [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    OrganizationChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[OrganizationChildTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    [cell fillDataTitle:_titleArray[indexPath.row] content:_dataArray[indexPath.row]];
    
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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return kFrameH(cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/*
- (void)createView{
    UIView *superView = self.view;
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 15;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(74);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
    } ];
    [self createFixedView:_bgView
           andcompanyName:self.staffModel.companyName
                                 andDefaultStaffNameString:NSLocalizedString(@"staffName:", @"staffName:")
andDefaultDepartmentString:NSLocalizedString(@"apartment:", @"apartment:")
 andDefaultPositionString:NSLocalizedString(@"position:", @"position:")
    andDefaultphoneString:NSLocalizedString(@"telephone:", @"telephone:")
       andStaffNameString:self.staffModel.staffName
      andDepartmentString:self.staffModel.departmentName
        andPositionString:self.staffModel.positionName
           andPhoneString:self.staffModel.phoneNumber
            andViewType:kOrganization];

    float lengthData = (self.view.frame.size.width-20)/5;
//    NSLog(@"%f",lengthData);
    self.messageButton = [self createButton:@"message_normal"];
        [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(lengthData);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-lengthData-10);
        make.width.equalTo(lengthData);
        make.height.equalTo(lengthData);
        [self.messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }];
//
    self.phoneButton = [self createButton:@"phone"];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-lengthData);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-lengthData-10);
        make.width.equalTo(lengthData);
        make.height.equalTo(lengthData);
    }];
   
    [self.phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];

}
 */
- (UILabel *)createDefaultLabel:(NSString *)defaultString{
    UILabel *label = [[UILabel alloc]init];
    label.text = defaultString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    return label;
}
- (UILabel *)createLabel:(NSString *)string{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = string;
    [self.view addSubview:label];
    return label;
}
- (UIButton *)createButton:(NSString*)string {
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [self.view addSubview:button];
    return button;
}
-(void)messageButtonClick{
   
    [self showMessageView:[NSArray arrayWithObjects:self.staffModel.phoneNumber ,nil]];
}

-(void)phoneButtonClick{
     [self openCall:self.staffModel.phoneNumber];
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
