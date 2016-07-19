//
//  BaseNoTabViewController.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "BaseNoTabViewController.h"
#import "RDVTabBarController.h"
#import "ProcessView.h"
@interface BaseNoTabViewController ()

@property (nonatomic, retain) UILabel *companyLabel;
//默认的
@property (nonatomic, retain) UILabel *defaultStaffNameLabel;
@property (nonatomic, retain) UILabel *defaultdepartmentLabel;
@property (nonatomic, retain) UILabel *defaultpositionLabel;
@property (nonatomic, retain) UILabel *defaultphoneLabel;
//内容变化的
@property (nonatomic, retain) UILabel *staffNameLabel;
@property (nonatomic, retain) UILabel *departmentLabel;
@property (nonatomic, retain) UILabel *positionLabel;
@property (nonatomic, retain) UILabel *phoneLabel;
@property (nonatomic, retain) UILabel *stateLabel;

@property (nonatomic, retain)UIButton *leftButton;
@property (nonatomic, retain)UIButton *rightButton;
@end

@implementation BaseNoTabViewController{
     float bottomHeight ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

/**
 *  传入参数，加载在传入的view视图上
 *
 *  @param bgView                  bgView description
 *  @param companyName             companyName description
 *  @param defaultStaffNameString  defaultStaffNameString description
 *  @param defaultDepartmentString defaultDepartmentString description
 *  @param defaultPositionString   defaultPositionString description
 *  @param defaultphoneString      defaultphoneString description
 *  @param staffNameString         staffNameString description
 *  @param departmentString        departmentString description
 *  @param positionString          positionString description
 *  @param phoneString             phoneString description
 *
 *  @return lable 用于员工详情页的 状态标签
 */
- (UILabel *)createFixedView:(UIView*)bgView andcompanyName:(NSString *)companyName
     andDefaultStaffNameString:(NSString *)defaultStaffNameString
    andDefaultDepartmentString:(NSString *)defaultDepartmentString
      andDefaultPositionString:(NSString *)defaultPositionString
         andDefaultphoneString:(NSString *)defaultphoneString
            andStaffNameString:(NSString *)staffNameString
           andDepartmentString:(NSString *)departmentString
             andPositionString:(NSString *)positionString
                andPhoneString:(NSString *)phoneString
                 andViewType:(ViewType)type
{
    self.companyLabel = [self createDefaultLabel:companyName];
    [bgView addSubview:self.companyLabel];
    self.defaultStaffNameLabel = [self createDefaultLabel:defaultStaffNameString];
    [bgView addSubview:self.defaultStaffNameLabel];
    self.defaultdepartmentLabel = [self createDefaultLabel:defaultDepartmentString];
    [bgView addSubview:self.defaultdepartmentLabel];
    self.defaultpositionLabel = [self createDefaultLabel:defaultPositionString];
    [bgView addSubview:self.defaultpositionLabel];
    self.defaultphoneLabel = [self createDefaultLabel:defaultphoneString];
    [bgView addSubview:self.defaultphoneLabel];
   
    self.staffNameLabel = [self createLabel:staffNameString];
    [bgView addSubview:self.staffNameLabel];
    self.phoneLabel = [self createLabel:phoneString];
    [bgView addSubview:self.phoneLabel];
    self.departmentLabel = [self createLabel:departmentString];
    [bgView addSubview:self.departmentLabel];
    self.positionLabel = [self createLabel:positionString];
    [bgView addSubview:self.positionLabel];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(15);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.mas_width);
        make.height.equalTo(@30);
    }];
    
    [self.defaultStaffNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [self.defaultdepartmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.staffNameLabel.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [self.defaultpositionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [self.defaultphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    if (type == kContact) {
        self.staffNameLabel.numberOfLines = 0;
        self.staffNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize staffNamesize = [self sizeWithString:staffNameString font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(bgView.width-100-20, MAXFLOAT)];
        [self.staffNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
            make.left.equalTo(self.defaultStaffNameLabel.mas_right).offset(10);
            make.width.equalTo(bgView.width-100-20);
            if (staffNamesize.height +2 > 20) {
                make.height.equalTo(staffNamesize.height + 2);
            }else{
                 make.height.equalTo(20);
            }
        }];
    }else if (type == kOrganization){
        CGRect titleRect = [staffNameString boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        [self.staffNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
            make.left.equalTo(self.defaultStaffNameLabel.mas_right).offset(10);
            make.width.equalTo(titleRect.size.width+10);
            make.height.equalTo(@20);
        }];
      
        self.stateLabel = [self createLabel:@"zaizhi"];
        self.stateLabel.backgroundColor = [UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.textColor = [UIColor whiteColor];
        [self.stateLabel setFont:[UIFont systemFontOfSize:15]];
        self.stateLabel.layer.masksToBounds = YES;
        self.stateLabel.layer.cornerRadius = 8;
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
            make.left.equalTo(self.staffNameLabel.mas_right).offset(10);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
            
        }];
        
    }else{
        
        
        
        
    }
    
    [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.staffNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.defaultStaffNameLabel.mas_right).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        
    }];
    
    self.positionLabel.numberOfLines = 0;
    self.positionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize positionsize = [self sizeWithString:positionString font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(bgView.width-100-20, MAXFLOAT)];
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.defaultStaffNameLabel.mas_right).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        if (positionsize.height + 2 > 20 ) {
             make.height.equalTo(positionsize.height+2);
        }else{
            make.height.equalTo(20);
        }
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel.mas_bottom).offset(10);
        make.left.equalTo(self.defaultStaffNameLabel.mas_right).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    return self.staffNameLabel;
}
- (UILabel *)createDefaultLabel:(NSString *)defaultString{
    UILabel *label = [[UILabel alloc]init];
    label.text = defaultString;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = COMMON_FONT_GRAY_COLOR;
//    [self.view addSubview:label];
    return label;
}

/**
 *  传入参数，用于医生详情等页面的下部门视图的创建
 *
 *  @param string         string description
 *  @param selectedString selectedString description
 */
- (void)createBottomViewWithBottonView:(UIView*)bottomView
            andWithLeftNormalImageName:(NSString*)leftString
          andWithLeftSelectedImageName:(NSString*)leftSelectedString
           andWithRightNormalImageName:(NSString*)rightString
         andWithRightSelectedImageName:(NSString*)rightSelectedString{
    
       
    self.leftButton = [self createButtonWithNormalImageName:leftString andWithSelectedImageName:leftSelectedString];
    [bottomView addSubview:self.leftButton];
    self.rightButton = [self createButtonWithNormalImageName:rightString andWithSelectedImageName:rightSelectedString];
    [bottomView addSubview:self.rightButton];
    
    float lengthData;
    if (SCREEN_WIDTH > 375) {
        lengthData  = (self.view.frame.size.width-20)/8;
    }else{
        lengthData = (self.view.frame.size.width-20)/7;}
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(lengthData);
        make.width.equalTo(lengthData);
        make.height.equalTo(lengthData);
        make.centerY.equalTo(bottomView);
        [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-lengthData);
        make.width.equalTo(lengthData);
        make.height.equalTo(lengthData);
        make.centerY.equalTo(bottomView);
    }];
    
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
 
}

-(void)leftButtonClick{
    
    
}

-(void)rightButtonClick{
    

}
- (UIButton *)createButtonWithNormalImageName:(NSString*)string andWithSelectedImageName:(NSString*)selectedString{
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedString] forState:UIControlStateHighlighted];
    return button;
}
- (UILabel *)createLabel:(NSString *)string{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = string;
//    [self.view addSubview:label];
    return label;
}
/**
 *  用于费用详情页
 *
 *  @param bgView    bgView description
 *  @param type      type description
 *  @param taskModel taskModel description
 */

- (void)createTaskDetailMainViewWithBgView:(UIScrollView*)bgView
                               andWithType:(int)type
                          andWithDeclareModel:(DeclareDetailModel*)declareModel{
    UIImageView *stateImageView = [[UIImageView alloc]init];
    stateImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"status%@",declareModel.currentStatus]];
    [bgView addSubview:stateImageView];
    UILabel *startDate= [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentRight andText:declareModel.createDate];
    [bgView addSubview:startDate];
    UILabel *bossLabel;
        bossLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:declareModel.username];

    [bgView addSubview:bossLabel];
    UILabel *giveTaskLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:@"费用申报"];
    [bgView addSubview:giveTaskLabel];
    
    UILabel *staffLabel;

        staffLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:[NSString stringWithFormat:@"%.2f元", [declareModel.moneyString floatValue]]];
    
    [bgView addSubview:staffLabel];
    UILabel *hopeLabel = [self createLabelWithFont:15 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentCenter andText:@"用于"];
    [bgView addSubview:hopeLabel];
    
    UILabel *endDate = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:declareModel.remarkString];
    [bgView addSubview:endDate];
    
    UILabel *finishLabel;
    if ([declareModel.hospitalName isEqualToString:declareModel.doctorName]) {
        finishLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:[NSString stringWithFormat:@"%@ / %@",declareModel.productionName,declareModel.hospitalName]];
    }else {
        if (declareModel.productionName) {
            finishLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:[NSString stringWithFormat:@"%@ / %@ / %@",declareModel.productionName,declareModel.hospitalName, declareModel.doctorName]];
        }else {
            finishLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:@""];
        }
        
    }
    
    
    
    [bgView addSubview:finishLabel];
    
    //用于紧急状态
    UILabel *useWayLabel2 = [self createLabelWithFont:15 andTextColor:[UIColor whiteColor] andTextAlignment:NSTextAlignmentCenter andText:declareModel.declareName];
    
    useWayLabel2.backgroundColor = [UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000];
    useWayLabel2.clipsToBounds = YES;
    useWayLabel2.layer.cornerRadius = 12.5;
    [bgView addSubview:useWayLabel2];
    
    [stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        
    }];
    
    [bossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateImageView.mas_bottom).offset(20);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.width);
        make.height.equalTo(@20);
    }];
    [giveTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bossLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [staffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giveTaskLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.width);
        make.height.equalTo(@20);
    }];

    [hopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(staffLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hopeLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
    }];
    finishLabel.numberOfLines = 0;
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endDate.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@300);
        make.height.equalTo(@60);
    }];
    CGSize usewaySize = [self sizeWithString:useWayLabel2.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 25)];
    [useWayLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(finishLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(usewaySize.width+20);
        make.height.equalTo(@25);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 280, bgView.width-10, 10)];
    [bgView addSubview:imageView1];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {10,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 10.0);    //开始画线
    CGContextAddLineToPoint(line, bgView.width-10, 10.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UILabel *remarkLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft andText:[NSString stringWithFormat:@"使用方式:  %@",declareModel.wayString]];
    [bgView addSubview:remarkLabel];
    remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    remarkLabel.numberOfLines = 0;
    CGSize size = [self sizeWithString:remarkLabel.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(bgView.width - 30, MAXFLOAT)];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView1.mas_bottom).offset(6);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(bgView.width - 30);
        make.height.equalTo(size.height+2);
    }];
    CGSize size1;
    //对有没有备注做判断
    if (![declareModel.remark isEqualToString:@""]) {
        UILabel *realRemarkLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft andText:[NSString stringWithFormat:@"备注  :  %@", declareModel.remark]];
        [bgView addSubview:realRemarkLabel];
        realRemarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
        realRemarkLabel.numberOfLines = 0;
         size1 = [self sizeWithString:realRemarkLabel.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(bgView.width - 30, MAXFLOAT)];
        [realRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remarkLabel.mas_bottom).offset(6);
            make.left.equalTo(bgView.mas_left).offset(15);
            make.width.equalTo(bgView.width - 30);
            make.height.equalTo(size1.height+2);
        }];

    }
    
    if (declareModel.auditInfos.count == 0) {
        if ([declareModel.remark isEqualToString:@""]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, remarkLabel.frame.origin.y + size.height + 15);
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, remarkLabel.frame.origin.y + size.height + 15 + 6 + size1.height+10);
            });

        }
       
    }else {
        UILabel *progressLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andText:@"审批流程"];
        [bgView addSubview:progressLabel];
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(10);
            if ([declareModel.remark isEqualToString:@""]){
                make.top.equalTo(remarkLabel.mas_bottom).offset(15);
            }else{
                make.top.equalTo(remarkLabel.mas_bottom).offset(15+size1.height+2+6);
            }
           
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
        [bgView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(0);
            make.top.equalTo(progressLabel.mas_bottom).offset(5);
            make.width.equalTo(SCREEN_WIDTH-20);
            make.height.equalTo(@01);
        }];
        CGFloat height = 0.0;
        for (int i = 0; i < declareModel.auditInfos.count; i++) {
            ProcessView *processView = [[ProcessView alloc]init];
            [bgView addSubview:processView];
            
            //流程
            [processView setAuditInfosModelToView:declareModel.auditInfos[i] andOrder:i];
            
            CGSize size = [self sizeWithString:[declareModel.auditInfos[i] message] font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT)];
            height = height + 40 +size.height + 10;
            [processView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left).offset(0);
                make.top.equalTo(lineLabel.mas_bottom).offset(10+(40 +size.height + 10)*i);
                make.width.equalTo(SCREEN_WIDTH-20);
                make.height.equalTo(40 + size.height);
            }];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, lineLabel.frame.origin.y + height + 10);
      });
      }
  }
/**
 *  用于任务详情页
 *
 *  @param bgView    bgView description
 *  @param type      type description
 *  @param taskModel taskModel description
 */
- (void)createTaskDetailMainViewWithBgView:(UIScrollView*)bgView andWithType:(int)type andWithTaskModel:(TaskDetailModel*)taskModel{
    UIImageView *statusImgView = [[UIImageView alloc]init];
    statusImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"taskStatus%@",taskModel.stauts]];
    [bgView addSubview:statusImgView];
    
    UILabel *startDate= [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentRight andText:taskModel.createDate];
    [bgView addSubview:startDate];
    UILabel *bossLabel;
    if (type == 0 ) {
        bossLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:@"我"];
    }else{
//        bossLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:[NSString stringWithFormat:@"%@(%@)",taskModel.phoneNumber,taskModel.receiverName]];
        bossLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:taskModel.receiverName];
    }
    [bgView addSubview:bossLabel];
    UILabel *giveTaskLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:@"下达了任务给"];
    [bgView addSubview:giveTaskLabel];
    
    UILabel *staffLabel;
    if (type == 0) {
        staffLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:taskModel.toName];//[NSString stringWithFormat:@"%@(%@)",taskModel.phoneNumber,taskModel.receiverName]];
    }else{
        staffLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:@"我"];
    }
    [bgView addSubview:staffLabel];
    UILabel *hopeLabel = [self createLabelWithFont:15 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentCenter andText:@"希望"];
    [bgView addSubview:hopeLabel];
    
    UILabel *endDate = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:[NSString stringWithFormat:@"%@前",taskModel.planCompleteDate]];
    [bgView addSubview:endDate];
    
    UILabel *finishLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter andText:@"完成"];
    [bgView addSubview:finishLabel];
    
    //用于紧急状态
    UILabel *stateLabel2;
    if ([taskModel.priority isEqualToString:@"0"]) {
      stateLabel2 = [self createLabelWithFont:15 andTextColor:[UIColor whiteColor] andTextAlignment:NSTextAlignmentCenter andText:@"普通"];
    }else{
        stateLabel2 = [self createLabelWithFont:15 andTextColor:[UIColor whiteColor] andTextAlignment:NSTextAlignmentCenter andText:@"紧急"];
    }
    stateLabel2.backgroundColor = [UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000];
    stateLabel2.clipsToBounds = YES;
    stateLabel2.layer.cornerRadius = 10;
    [bgView addSubview:stateLabel2];
    
    [statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        
    }];
    
    
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        
    }];
    
    [bossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusImgView.mas_bottom).offset(20);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.width);
        make.height.equalTo(@20);
    }];
    [giveTaskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bossLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [staffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giveTaskLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.width);
        make.height.equalTo(@20);
    }];
    
    [hopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(staffLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hopeLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(bgView.width);
        make.height.equalTo(@20);
    }];
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endDate.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    [stateLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(finishLabel.mas_bottom).offset(6);
        make.centerX.equalTo(bgView);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 240, bgView.width-10, 10)];
    [bgView addSubview:imageView1];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {10,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 10.0);    //开始画线
    CGContextAddLineToPoint(line, bgView.width-10, 10.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //任务标题
    UILabel *titleLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter andText:taskModel.taskName];
    [bgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView1.mas_bottom).offset(6);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(bgView.width - 30);
        make.height.equalTo(@25);
    }];
    
    //任务内容
    UILabel *remarkLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft andText:[NSString stringWithFormat:@"任务内容:%@",taskModel.contentStr]];
    [bgView addSubview:remarkLabel];
    remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    remarkLabel.numberOfLines = 0;
    CGSize size = [self sizeWithString:taskModel.contentStr font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(bgView.width - 30, MAXFLOAT)];
    //    NSLog(@"%lf",size.height);
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
        make.left.equalTo(bgView.mas_left).offset(15);
        make.width.equalTo(bgView.width - 30);
        make.height.equalTo(size.height);
    }];
    
    
    
    //任务反馈
    if ([taskModel.feedback isEqualToString:@""]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, remarkLabel.frame.origin.y + size.height + 15 );
        });
    }else {
        UIImageView *imageView2 = [[UIImageView alloc] init];
        [bgView addSubview:imageView2];
        
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remarkLabel.mas_bottom).offset(0);
            make.left.equalTo(bgView.mas_left).offset(5);
            make.width.equalTo(bgView.width);
            make.height.equalTo(10);
        }];
        
        UIGraphicsBeginImageContext(imageView2.frame.size);   //开始画线
        [imageView2.image drawInRect:CGRectMake(0, 0, imageView2.frame.size.width, imageView2.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        
        CGFloat lengths[] = {10,5};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 10.0);    //开始画线
        CGContextAddLineToPoint(line, bgView.width-10, 10.0);
        CGContextStrokePath(line);
        imageView2.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UILabel *progressLabel = [[UILabel alloc] init];
        if ([taskModel.stauts intValue] == 3) {
            progressLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft andText:[NSString stringWithFormat:@"拒绝原因:%@",taskModel.feedback]];
        }else {
            progressLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft andText:[NSString stringWithFormat:@"反馈结果:%@",taskModel.feedback]];
        }
        
        [bgView addSubview:progressLabel];
        progressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        progressLabel.numberOfLines = 0;
        CGSize size = [self sizeWithString:taskModel.feedback font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(bgView.width - 30, MAXFLOAT)];
        //    NSLog(@"%lf",size.height);
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView2.mas_bottom).offset(6);
            make.left.equalTo(bgView.mas_left).offset(15);
            make.width.equalTo(bgView.width - 30);
            make.height.equalTo(size.height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, progressLabel.frame.origin.y + size.height + 15 );
        });
        
//        UILabel *progressLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft andText:@"反馈结果"];
//        [bgView addSubview:progressLabel];
//        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(bgView.mas_left).offset(10);
//            make.top.equalTo(remarkLabel.mas_bottom).offset(15);
//            make.width.equalTo(@100);
//            make.height.equalTo(@20);
//        }];
//        UILabel *lineLabel = [[UILabel alloc]init];
//        lineLabel.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];
//        [bgView addSubview:lineLabel];
//        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(bgView.mas_left).offset(0);
//            make.top.equalTo(progressLabel.mas_bottom).offset(5);
//            make.width.equalTo(SCREEN_WIDTH-20);
//            make.height.equalTo(@01);
//        }];
//        
//        CGFloat height = 0.0;
//       
//            ProcessView *processView = [[ProcessView alloc]init];
//            [bgView addSubview:processView];
//            
//            //流程
//            [processView setTaskDetailModelToView:taskModel];
//            CGSize size = [self sizeWithString:taskModel.feedback font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT)];
//            height = height + 40 +size.height + 10;
//            [processView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(bgView.mas_left).offset(0);
//                make.top.equalTo(lineLabel.mas_bottom).offset(10);
//                make.width.equalTo(SCREEN_WIDTH-20);
//                make.height.equalTo(40 + size.height);
//            }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            bgView.contentSize = CGSizeMake(SCREEN_WIDTH-20, lineLabel.frame.origin.y + height + 10);
//        });
        
        
    }
    
}

//用于任务详情页
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment andText:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.text = text;
    label.textAlignment = alignment;
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
