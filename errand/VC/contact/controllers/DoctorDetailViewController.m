//
//  DoctorDetailViewController.m
//  errand
//
//  Created by gravel on 15/12/15.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "DoctorModel.h"
#import "DoctorDetailTableViewCell.h"

@interface DoctorDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain)UIView *bgView;

@end

@implementation DoctorDetailViewController{
    UITableView *_tableView;
    float bottomHeight ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"doctorDetail", @"doctorDetail");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    bottomHeight = 60;
//    bottomHeight = [MyAdapter aDapter:60];
    [self createHeaderView];
    [self createBottomView];
    
}
- (void)createHeaderView{
    self.bgView = [[UIView alloc]init];
    self.bgView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 250);
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgView];
    [self createFixedView:_bgView
           andcompanyName:self.doctorModel.hospitalName
andDefaultStaffNameString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"doctorName", @"doctorName")]
andDefaultDepartmentString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"apartment", @"apartment")]
 andDefaultPositionString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"position", @"position")]
    andDefaultphoneString:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"telephone", @"telephone")]
       andStaffNameString:self.doctorModel.doctorName
      andDepartmentString:self.doctorModel.departmentString
        andPositionString:self.doctorModel.positionString
           andPhoneString:self.doctorModel.phoneString
       andViewType:kDoctorDetail];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:nil];
    segment.frame = CGRectMake((SCREEN_WIDTH -20 - 250)/2, 210, 250, 40);
    [segment insertSegmentWithTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"trends", @"trends")] atIndex:0 animated:NO];
    [segment insertSegmentWithTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"costRecord", @"costRecord")] atIndex:1 animated:NO];
     segment.selectedSegmentIndex = 0;
    segment.layer.masksToBounds = YES;
    segment.layer.borderWidth = 1;
    segment.layer.borderColor = [UIColor lightGrayColor].CGColor;
    segment.layer.cornerRadius = 20;
    segment.tintColor = [UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.bgView addSubview:segment];
    
    //segment 约束

    [self createTableView];
    
}

- (void)segmentClick:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0: //动态
            NSLog(@"%ld",(long)index);
            break;
        case 1: //费用记录
            NSLog(@"%ld",(long)index);
            break;
    }
    
}

- (void)createBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomHeight, SCREEN_WIDTH, bottomHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [self createBottomViewWithBottonView:bottomView andWithLeftNormalImageName:@"message_normal" andWithLeftSelectedImageName:@"message_selected" andWithRightNormalImageName:@"phone" andWithRightSelectedImageName:@"phone_selected"];

}



-(void)leftButtonClick{
    
    [self showMessageView:[NSArray arrayWithObjects:self.doctorModel.phoneString ,nil]];
}

-(void)rightButtonClick{
    [self openCall:self.doctorModel.phoneString];
}

- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64+10, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-10-bottomHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = self.bgView;
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DoctorDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.visitNameLabel.text = self.doctorModel.visitName;
    cell.sumLabel.text = self.doctorModel.sumString;
    cell.backgroundColor = [UIColor whiteColor];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    后期动态获取
    return 100;
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
