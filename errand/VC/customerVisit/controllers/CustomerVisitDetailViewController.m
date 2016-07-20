//
//  CustomerVisitDetailViewController.m
//  errand
//
//  Created by gravel on 15/12/22.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CustomerVisitDetailViewController.h"
#import "CustomerVisitBll.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MMAlertView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "MissVisitReportView.h"
#import "SummaryReportView.h"

@interface CustomerVisitDetailViewController ()<AMapLocationManagerDelegate, AMapSearchDelegate>{
    MissVisitReportView *_reportV;
    SummaryReportView *_reportView;
}
@property (nonatomic, strong)UIImageView *statusImgView;
@property (nonatomic ,strong)UILabel *startDateLbl;
@property (nonatomic, strong)UILabel *staffLabel;
@property (nonatomic, strong)UILabel *planLabel;
@property (nonatomic, strong)UILabel *endDateLabel;
@property (nonatomic, strong)UILabel *visitLabel;
@property (nonatomic, strong)UILabel *doctorLabel;
@property (nonatomic, strong)UILabel *hospitalLabel;
@property (nonatomic, strong)UILabel *remarkLabel;
@property (nonatomic, strong)UIImageView *imageView1;
@property (nonatomic, strong)UILabel *sumLabel;
@property (nonatomic, strong)UILabel *lineLabel2;

@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation CustomerVisitDetailViewController{
    float bottomHeight ;
    UIScrollView *_scrollView;
    //用来判断是离开签到 还是到达签到
    int category;
    //用于拜访总结
    NSString *_message;
    
    UIButton *_arriveBtn;
    UIButton *_leaveButton;
    UILabel *_timeLabel;
    NSTimer *_clockTimer;
    UIView *_bottomView;
    
    BOOL _isMissVisit;
    NSTimer *_arriveTimer;
    BOOL _arriveTimerFire;
    BOOL _leavePost;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"customerVisitDetail", @"customerVisitDetail");
    [self addBackButton];
    
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    bottomHeight = [MyAdapter aDapter:80];
    [self createMainView];
    [self createData];
    
    // Do any additional setup after loading the view.
}

- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)createRightItems:(VisitDetailModel *)model
{
//    UIButton * rightBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
//    [rightBtnOne setBackgroundImage:[[UIImage imageNamed:@"edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [rightBtnOne addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    NSInteger flag = 0;
    
    if ([model.belongToID isEqual:[Function userDefaultsObjForKey:@"userID"]]) {
        NSString *currentDate = [[Function stringFromDate:[NSDate date]] substringToIndex:10];
        if ([model.endDate isEqualToString:currentDate]) {
            UIButton *missVisit = [UIButton buttonWithType:UIButtonTypeCustom];
            [missVisit setTitle:@"失访" forState:UIControlStateNormal];
            missVisit.frame = CGRectMake(40, 5, 40, 30);
            missVisit.layer.cornerRadius = 15;
            missVisit.layer.backgroundColor = [UIColor colorWithRed:0.97 green:0.09 blue:0.16 alpha:1.00].CGColor;
            [missVisit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [missVisit addTarget:self action:@selector(missVisitClick) forControlEvents:UIControlEventTouchUpInside];
            missVisit.titleLabel.font = GDBFont(14);
            [bgView addSubview:missVisit];
            
            flag = 1;
        }
        
        
        UIButton * rightBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        if (flag == 0) {
            rightBtnTwo.frame = CGRectMake(40, 0, 40, 40);
        }else {
            rightBtnTwo.frame = CGRectMake(0, 0, 40, 40);
        }
        [rightBtnTwo setImage:[[UIImage imageNamed:@"delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
        [rightBtnTwo addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if ([model.category isEqual:@0]) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *todayStr = [formatter stringFromDate:[NSDate date]];
            if ([model.endDate compare:todayStr] == NSOrderedAscending || [model.endDate compare:todayStr] == NSOrderedSame) {
                
            }else {
                [bgView addSubview:rightBtnTwo];
            }
        }else {
            [bgView addSubview:rightBtnTwo];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    }
    
    
    
}

- (void)missVisitClick
{
    _isMissVisit = YES;
    
//    MMAlertView *alterView = [[MMAlertView alloc]initWithInputTitle:@"失访原因" detail:@"" placeholder:@"" handler:^(NSString *text) {
//        if (text.length!=0) {
//            [self showHintInView:self.view];
//            _message = text;
//            [self getCurrentAddressName];
//            
//        }else{
////            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"失访原因不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////            [alertView show];
//            [Dialog simpleToast:@"失访原因不能为空"];
//        }
//    }];
//    [alterView show];
    
    if (_reportV == NULL) {
        _reportV = [[MissVisitReportView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_reportV];
    }
    _reportV.hidden = NO;
    
    [_reportV buttonClickAction:^(NSInteger index) {
        if (index == 1) {
            [self showHintInView:self.view];
            _message = _reportV.textView.text;
            [self getCurrentAddressName];
        }
    }];
}

- (void)handleMissVisitRequest:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *lat = [NSString stringWithFormat:@"%f", request.location.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f", request.location.longitude];
    NSString *resultAddress = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
    NSString *urlStr = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"/api/v1/sale/visitplans/miss/%@", _visitDetailModel.ID]];
    NSDictionary *dic = @{@"message": _message,
                          @"coordinate": @{@"latitude": lat,
                                           @"longitude": lon,
                                           @"name": resultAddress}};
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self hideHud];
        [self misVisitRefreshData];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)misVisitRefreshData
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self viewDidLoad];
    _refreshBeforeDataCB();
}

- (void)editBtnClick{
    NSLog(@"editBtnClick");
}
- (void)deleteBtnClick{
    NSLog(@"deleteBtnClick");
//    delete/id
    
    NSString *urlStr = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"/api/v1/sale/visitplans/delete/%@", _visitDetailModel.ID]];
    [self showHintInView:self.view];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        [Dialog simpleToast:@"删除成功"];
        [self hideHud];
        _refreshBeforeDataCB();
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
    
}

//获取数据
- (void)createData{
    [self showHintInView:self.view];
    CustomerVisitBll *visitBll = [[CustomerVisitBll alloc]init];
    [visitBll getCustomerVisitDetailData:^(VisitDetailModel *model){
        self.visitDetailModel = model;
        [self setDataToView];
        self.status = model.stateString;
        //状态处于待审核的时候 可以进行编辑和删除
        if ([self.status intValue] == 0) {
            [self createRightItems:model];
        }
        //状态处于过期的时候 不创建底部
        if ([self.status intValue] != -1) {
            NSString *currentDate = [[Function stringFromDate:[NSDate date]] substringToIndex:10];
            if ([model.endDate isEqualToString:currentDate]) {
                
                if ([model.belongToID isEqual:[Function userDefaultsObjForKey:@"userID"]]) {
                    [self createBottomView];
                }else {
                    _bottomView.hidden = YES;
                    _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -10-10);
                }
                
            }else {
                _bottomView.hidden = YES;
                _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -10-10);
            }
            
        }else {
            _bottomView.hidden = YES;
            _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -10-10);
        }
        
        [self hideHud];
        
    } visitID:_visitID viewCtrl:self];
}

//填充数据
- (void)setDataToView{
    
    VisitDetailModel *model = self.visitDetailModel;
    CGSize size = [self sizeWithString:model.remarkString font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 20 - 30, MAXFLOAT)];
    CGSize size1 = CGSizeMake(0, 0);
    //是否是已拜访状态
    if ([self.visitDetailModel.stateString isEqualToString:@"2"] ||
        [self.visitDetailModel.stateString isEqualToString:@"3"]) {
         _lineLabel2.backgroundColor = [UIColor lightGrayColor];
        [_lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_remarkLabel.mas_bottom).offset(15);
            make.width.equalTo(_scrollView.mas_width);
            make.height.equalTo(@0.5);
            make.left.equalTo(_scrollView.mas_left).offset(0);
        }];
        size1 = [self sizeWithString:model.sumString font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 20 - 30, MAXFLOAT)];
        
        [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineLabel2.mas_bottom).offset(15);
            make.left.equalTo(_scrollView.mas_left).offset(15);
            make.width.equalTo(SCREEN_WIDTH - 20 - 30);
            make.height.equalTo(size1.height+10);
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scrollView.contentSize = CGSizeMake(_scrollView.width, _sumLabel.frame.origin.y + size1.height + 10 +15);
            
        });
    }
//    else if (){
//        [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_lineLabel2.mas_bottom).offset(15);
//            make.left.equalTo(_scrollView.mas_left).offset(15);
//            make.width.equalTo(SCREEN_WIDTH - 20 - 30);
//            make.height.equalTo(size1.height+10);
//            
//        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _scrollView.contentSize = CGSizeMake(_scrollView.width, _sumLabel.frame.origin.y + size1.height + 10 +15);
//            
//        });
//    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scrollView.contentSize = CGSizeMake(_scrollView.width, _remarkLabel.frame.origin.y + size.height + 10 +15);
        });
    }
    _scrollView.backgroundColor = [UIColor whiteColor];
    _statusImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"visitStatus%@",model.stateString]];
    _startDateLbl.text = model.startDate;
    
    if ([model.category isEqual:@0]) {
        _startDateLbl.textColor = kGreenColor;
        _startDateLbl.text = @"计划拜访";
    }else {
        _startDateLbl.text = @"临时拜访";
        _startDateLbl.textColor = kOrangeColor;
    }
    _staffLabel.text = @"我";
    _planLabel.text = @"计划于";
    _endDateLabel.text = model.endDate;
    _visitLabel.text = @"拜访客户";
    _doctorLabel.text = model.doctorName;
    _hospitalLabel.text = [NSString stringWithFormat:@"%@(%@) / %@", model.productName, model.specification, model.hospitalName];//model.hospitalName;
    NSMutableAttributedString *remarkString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",@"两个",model.remarkString]];
    [remarkString addAttribute:NSForegroundColorAttributeName
     
                         value:[UIColor whiteColor]
     
                         range:NSMakeRange(0, 2)];
    
    
    _remarkLabel.attributedText = remarkString;
    
    NSMutableAttributedString *sumString;
    if ([self.visitDetailModel.stateString isEqualToString:@"3"]) {
        
        sumString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",@"失访原因: ",model.sumString]];
    }else {
        sumString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",@"拜访总结: ",model.sumString]];
    }
    
    
    //        [remarkString addAttribute:NSFontAttributeName
    //
    //                              value:[UIFont systemFontOfSize:16.0]
    //
    //                              range:NSMakeRange(0, 2)];
    
    [sumString addAttribute:NSForegroundColorAttributeName
     
                      value:[UIColor colorWithRed:0.322 green:0.714 blue:1.000 alpha:1.000]
     
                      range:NSMakeRange(0, 5)];
    _sumLabel.attributedText = sumString;
    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH - 20 -10, 10));   //开始画线
    [_imageView1.image drawInRect:CGRectMake(0, 0, SCREEN_WIDTH - 20 -10, 10)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {10,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor lightGrayColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 10.0);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH - 20 -10, 10.0);
    CGContextStrokePath(line);
    
    _imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView1.mas_bottom).offset(6);
        make.left.equalTo(_scrollView.mas_left).offset(10);
        make.width.equalTo(SCREEN_WIDTH - 20 - 30);
        make.height.equalTo(size.height+10);
    }];
    
    CGSize hospitalSize = [Function sizeOfStr:model.hospitalName andFont:GDBFont(15) andMaxSize:CGSizeMake(280, CGFLOAT_MAX)];
    
    
}

- (void)createBottomView{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomHeight, SCREEN_WIDTH, bottomHeight)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
     _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor colorWithWhite:0.333 alpha:1.000];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_timeLabel];
    _timeLabel.text = @"00:00:00";
    
    int state = [self.visitDetailModel.stateString intValue];
    //0 待拜访 1拜访中 2完成拜访 -1 过期
    switch (state) {
        case 0:
        {
            _arriveBtn = [self createButtonWithView:_bottomView andWithText1:@"到达" andWithText2:@"签到" andWithDirectType:0];
            _arriveBtn.backgroundColor = [UIColor colorWithRed:0.314 green:0.702 blue:0.988 alpha:1.000];
            _leaveButton = [self createButtonWithView:_bottomView andWithText1:@"离开" andWithText2:@"签到" andWithDirectType:1];
            _leaveButton.backgroundColor = [UIColor colorWithRed:0.314 green:0.702 blue:0.988 alpha:1.000];
            [_arriveBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_leaveButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
            _timeLabel.text = @"00:00:00";
            _leaveButton.userInteractionEnabled = NO;
            _leaveButton.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
            [self makeTimeLabelConstraints];
            
            _bottomView.hidden = NO;
            _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -bottomHeight-10-10);
        }
            break;
        case 1:{
           
            long dt=[self.visitDetailModel.arriveDate doubleValue]/1000;
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dt];
             NSLog(@"dadao %@",confromTimesp);
            
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm"];
            NSString *arriveDateStr1 = [dateFormatter1 stringFromDate:confromTimesp];
       
            _arriveBtn = [self createButtonWithView:_bottomView andWithText1:arriveDateStr1 andWithText2:@"已签到" andWithDirectType:0];
            _arriveBtn.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
            
            _leaveButton = [self createButtonWithView:_bottomView andWithText1:@"离开" andWithText2:@"签到" andWithDirectType:1];
            _leaveButton.backgroundColor = [UIColor colorWithRed:0.314 green:0.702 blue:0.988 alpha:1.000];
            
            _arriveBtn.userInteractionEnabled = NO;
            [_leaveButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            //定时器
            _clockTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(clockDidTick) userInfo:nil repeats:YES];
            //加入主循环池中
            [[NSRunLoop currentRunLoop]addTimer:_clockTimer forMode:NSDefaultRunLoopMode];
            //开始循环
            [_clockTimer fire];
            _leaveButton.userInteractionEnabled = YES;
            _leaveButton.backgroundColor = [UIColor colorWithRed:0.314 green:0.702 blue:0.988 alpha:1.000];
            [self makeTimeLabelConstraints];
            
            _bottomView.hidden = NO;
            _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -bottomHeight-10-10);
        }break;
        case 2:{
        
            NSDate *arriveTimesp = [NSDate dateWithTimeIntervalSince1970:[self.visitDetailModel.arriveDate doubleValue]/1000];
            NSDate *leaveTimesp = [NSDate dateWithTimeIntervalSince1970:[self.visitDetailModel.leaveDate doubleValue]/1000];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"HH:mm"];
            NSString *arriveDateStr1 = [dateFormatter1 stringFromDate:arriveTimesp];
            NSString *leaveDateStr1 = [dateFormatter1 stringFromDate:leaveTimesp];
            NSLog(@"%@",leaveTimesp);
            _arriveBtn = [self createButtonWithView:_bottomView andWithText1:arriveDateStr1 andWithText2:@"已签到" andWithDirectType:0];
            _arriveBtn.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
            
            _leaveButton = [self createButtonWithView:_bottomView andWithText1:leaveDateStr1 andWithText2:@"已签到" andWithDirectType:1];
            _leaveButton.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
            
            long value = (long)([self.visitDetailModel.leaveDate doubleValue]/1000 - [self.visitDetailModel.arriveDate doubleValue]/1000);
            int msperhour = 3600;
            int mspermin = 60;
            int hrs =  value / msperhour;
            int mins = (value % msperhour) / mspermin;
            int secs = (value % msperhour) % mspermin;
            if (hrs == 0) {
                if (mins == 0) {
                    _timeLabel.text = [NSString stringWithFormat:@"00:00:%02d", secs];
                } else {
                    _timeLabel.text = [NSString stringWithFormat:@"00:%02d:%02d", mins, secs];
                }
            } else {
                _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hrs, mins, secs];
            }

            
            _arriveBtn.userInteractionEnabled = NO;
            _leaveButton.userInteractionEnabled = NO;
            
            _leaveButton.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
            [self makeTimeLabelConstraints];
            
            _bottomView.hidden = NO;
            _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -bottomHeight-10-10);
        }break;
            
        default: {
            _bottomView.hidden = YES;
            _scrollView.frame = CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 -10-10);
        }
            break;
    }
    
}

- (void)makeTimeLabelConstraints
{
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_arriveBtn.mas_right).offset(0);
        make.right.equalTo(_leaveButton.mas_left).offset(0);
        make.height.equalTo(@20);
        make.centerY.equalTo(_bottomView);
    }];
}

#pragma mark ---- 定时器的方法
- (void)clockDidTick{
    
    if (_arriveTimerFire) {
        [_clockTimer timeInterval];
        return;
    }
    
    long currentTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%@",[NSDate date]);
    long value = (long)(currentTime - [self.visitDetailModel.arriveDate doubleValue]/1000);
    int msperhour = 3600;
    int mspermin = 60;
    
    int hrs =  value / msperhour;
    int mins = (value % msperhour) / mspermin;
    int secs = (value % msperhour) % mspermin;
    
    if (hrs == 0) {
        if (mins == 0) {
            _timeLabel.text = [NSString stringWithFormat:@"00:00:%02d", secs];
        } else {
            _timeLabel.text = [NSString stringWithFormat:@"00:%02d:%02d", mins, secs];
        }
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hrs, mins, secs];
    }
    
}

- (void)arriveClickRunTimer:(NSTimer *)timer
{
    
    long currentTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%@",[NSDate date]);
    NSDate *currentDate = timer.userInfo;
    long value = (long)(currentTime - currentDate.timeIntervalSince1970)+1;
    int msperhour = 3600;
    int mspermin = 60;
    
    int hrs =  value / msperhour;
    int mins = (value % msperhour) / mspermin;
    int secs = (value % msperhour) % mspermin;
    
    if (hrs == 0) {
        if (mins == 0) {
            _timeLabel.text = [NSString stringWithFormat:@"00:00:%02d", secs];
        } else {
            _timeLabel.text = [NSString stringWithFormat:@"00:%02d:%02d", mins, secs];
        }
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hrs, mins, secs];
    }
}


#pragma mark --- 到达签到
-(void)leftButtonClick{
    _isMissVisit = NO;
//    [self showHintInView:self.view];
    [self getCurrentAddressName];
    category = 0;
    _message=@"";
    
}


#pragma mark --- 离开签到
-(void)rightButtonClick{
    _isMissVisit = NO;
//       MMAlertView *alterView = [[MMAlertView alloc]initWithInputTitle:@"拜访总结" detail:@"" placeholder:@"" handler:^(NSString *text) {
//        if (text.length!=0) {
////            [self showHintInView:self.view];
//            category = 1;
//            [self getCurrentAddressName];
//            _message = text;
//        }else{
//            [Dialog simpleToast:@"拜访总结不能为空"];
//        }
//    }];
//    [alterView show];
    
    if (_reportView == NULL) {
        _reportView = [[SummaryReportView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_reportView];
    }
    _reportView.hidden = NO;
    
    [_reportView buttonClickAction:^(NSInteger index) {
        if (index == 1) {
//            [self showHintInView:self.view];
            category = 1;
            [self getCurrentAddressName];
            _message = _reportView.textView.text;
            
        }
    }];
}

//创建主视图
- (void)createMainView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 64+10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64 - bottomHeight -10-10)];
    _scrollView.bounces = YES;
    _scrollView.layer.cornerRadius = 15;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [self createTaskDetailMainView];
}

- (void)createTaskDetailMainView{
    _statusImgView = [[UIImageView alloc]init];
    [_scrollView addSubview:_statusImgView];
    _startDateLbl =  [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_startDateLbl];
    _staffLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_staffLabel];
    _planLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_planLabel];
    
    _endDateLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter ];
    [_scrollView addSubview:_endDateLabel];
    _visitLabel = [self createLabelWithFont:15 andTextColor:[UIColor grayColor] andTextAlignment:NSTextAlignmentCenter ];
    [_scrollView addSubview:_visitLabel];
    
    _doctorLabel = [self createLabelWithFont:20 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_doctorLabel];
    
    _hospitalLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter ];
    [_scrollView addSubview:_hospitalLabel];
    _hospitalLabel.numberOfLines = 0;
    
    [_statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
        
    }];
    [_startDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.left.equalTo(_statusImgView.mas_right).offset(10);
        make.height.equalTo(@16);
    }];
    
    [_staffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusImgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        //?????????
        make.width.equalTo(SCREEN_WIDTH-50);
        
        make.height.equalTo(@20);
    }];
    [_planLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_staffLabel.mas_bottom).offset(6);
        make.centerX.equalTo(_scrollView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    [_endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_planLabel.mas_bottom).offset(6);
        make.centerX.equalTo(_scrollView);
        make.width.equalTo(_scrollView.mas_width);
        make.height.equalTo(@20);
    }];
    [_visitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endDateLabel.mas_bottom).offset(6);
        make.centerX.equalTo(_scrollView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [_doctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_visitLabel.mas_bottom).offset(6);
        make.centerX.equalTo(_scrollView);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [_hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_doctorLabel.mas_bottom).offset(6);
        make.centerX.equalTo(_scrollView);
        make.width.equalTo(kWidth-20);
        make.height.equalTo(@60);
    }];
    
    //line
    _imageView1 = [[UIImageView alloc]init];
    [_scrollView addSubview:_imageView1];
    
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hospitalLabel.mas_bottom).offset(6);
        make.left.equalTo(_scrollView.mas_left).offset(0);
        make.width.equalTo(kWidth+5-20);
        make.height.equalTo(@10);
    }];
    
    
    _remarkLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_remarkLabel];
    _remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _remarkLabel.numberOfLines = 0;
    
    
    _lineLabel2 = [[UILabel alloc]init];
    [_scrollView addSubview:_lineLabel2];
    
    
    _sumLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_sumLabel];
    _sumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _sumLabel.numberOfLines = 0;
    
    
    
    
}

-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    return label;
}

/**
 *   底部签到的按钮
 *
 *  @param bottomView bottomView description
 *  @param text1      按钮上边的字
 *  @param text2      按钮下面的字
 *  @param directType 0 左按钮 1 右按钮
 *
 *  @return return value description
 */
- (UIButton *)createButtonWithView:(UIView *)bottomView andWithText1:(NSString*)text1 andWithText2:(NSString*)text2 andWithDirectType:(int)directType{
    UIButton *button = [[UIButton alloc]init];
    [bottomView addSubview:button];
    UILabel * Label1 = [[UILabel alloc]init];
    Label1.text = text1;
   
    Label1.textColor = [UIColor whiteColor];
    Label1.textAlignment = NSTextAlignmentCenter;
    [button addSubview:Label1];
  
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = text2;
    
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label2];
    
    float lengthData;
    if (SCREEN_WIDTH > 375) {
        lengthData  = (self.view.frame.size.width-20)/7;
        if (directType == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bottomView.mas_left).offset(lengthData);
                make.width.equalTo(bottomHeight-30);
                make.height.equalTo(bottomHeight-30);
                make.centerY.equalTo(bottomView);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(bottomView.mas_right).offset(-lengthData);
                make.width.equalTo(bottomHeight-30);
                make.height.equalTo(bottomHeight-30);
                make.centerY.equalTo(bottomView);
            }];
        }
        button.layer.cornerRadius = (bottomHeight-30)/2;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top).offset(5);
            make.width.equalTo(bottomHeight-30);
            make.height.equalTo((bottomHeight-30 )/2);
            make.centerX.equalTo(button);
            
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_bottom).offset(-5);
            make.width.equalTo(bottomHeight-30);
            make.height.equalTo((bottomHeight-30 )/2);
            make.centerX.equalTo(button);
        }];
        Label1.font = [UIFont boldSystemFontOfSize:17];
        label2.font = [UIFont boldSystemFontOfSize:17];
        
    }else{
        lengthData = (self.view.frame.size.width-20)/6;
        if (directType == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bottomView.mas_left).offset(lengthData);
                make.width.equalTo(bottomHeight-20);
                make.height.equalTo(bottomHeight-20);
                make.centerY.equalTo(bottomView);
                
            }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(bottomView.mas_right).offset(-lengthData);
                make.width.equalTo(bottomHeight-20);
                make.height.equalTo(bottomHeight-20);
                make.centerY.equalTo(bottomView);
                
            }];
        }
        
        
        button.layer.cornerRadius = (bottomHeight-20)/2;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top).offset(5);
            make.width.equalTo(bottomHeight-20 );
            make.height.equalTo((bottomHeight-20 )/2);
            make.centerX.equalTo(button);
            
        }];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_bottom).offset(-5);
            make.width.equalTo(bottomHeight-20);
            make.height.equalTo((bottomHeight-20 )/2);
            make.centerX.equalTo(button);
        }];
        Label1.font = [UIFont boldSystemFontOfSize:17];
        label2.font = [UIFont boldSystemFontOfSize:17];
    }
    
    
    return button;
}

- (void)getCurrentAddressName{
    // 配置用户KEY
    [self runLocationProcess];
}

- (void)runLocationProcess
{
    _locationManager = nil;
    _locationManager.delegate = nil;
    
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDelegate:self];
    
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    [_locationManager setAllowsBackgroundLocationUpdates:YES];
    [_locationManager startUpdatingLocation];
//    NSLog(@"runLocationProcess");
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"didUpdateLocation%@", location);
    [manager stopUpdatingLocation];
    
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeoRequest];
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [Function alertUserDeniedLocation:error delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LocationErrorAlertTag) {
        [Function isShowSystemLocationSetupPage:buttonIndex];
    }
}
// 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *resultAddress = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        
        if (_isMissVisit) {
            [self handleMissVisitRequest:request response:response];
            return;
        }
        
        if (category == 1) {
            if (_leavePost == NO) {
                CustomerVisitBll *visitBll = [[CustomerVisitBll alloc]init];
                [visitBll addSigninData:^(NSDictionary *result) {
                    [self hideHud];
                    //1 离开签到
                    [Dialog simpleToast:@"离开签到成功"];
                    self.changeVisitStatusBlock(_indexPath,@"2");
                    [self leaveClickChangeButton];
                    _leavePost = YES;
                    
                } category:category visitID:self.visitID longitude:[NSString stringWithFormat:@"%f",request.location.longitude] latitude:[NSString stringWithFormat:@"%f",request.location.latitude] name:resultAddress Message:_message viewCtrl:self];
            }
        }else {
            if (_arriveTimerFire == NO) {
                CustomerVisitBll *visitBll = [[CustomerVisitBll alloc]init];
                [visitBll addSigninData:^(NSDictionary *result) {
                    [self hideHud];
                    [Dialog simpleToast:@"到达签到成功"];
                    self.changeVisitStatusBlock(_indexPath,@"1");
                    [self arriveClickChangeButton];
                    _arriveTimerFire = YES;
                    
                } category:category visitID:self.visitID longitude:[NSString stringWithFormat:@"%f",request.location.longitude] latitude:[NSString stringWithFormat:@"%f",request.location.latitude] name:resultAddress Message:_message viewCtrl:self];
            }
        }
    }
        
}

- (void)arriveClickChangeButton
{
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self createMainView];
    [self createData];
    
    NSDate *currentDate = [NSDate date];
    NSLog(@"currentDate %@", currentDate);
//    double timetamp = currentDate.timeIntervalSince1970;
//    NSNumber *timeNum = [NSNumber numberWithFloat:timetamp*1000];
    
    _arriveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(arriveClickRunTimer:) userInfo:currentDate repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_arriveTimer forMode:NSDefaultRunLoopMode];
    
    self.navigationItem.rightBarButtonItem = nil;
    _leaveButton.userInteractionEnabled = YES;
    _leaveButton.backgroundColor = [UIColor colorWithRed:0.314 green:0.702 blue:0.988 alpha:1.000];
    
    _arriveBtn.hidden = YES;
    [_arriveBtn removeFromSuperview];
    _arriveBtn = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm";
    _arriveBtn = [self createButtonWithView:_bottomView andWithText1:[formatter stringFromDate:currentDate] andWithText2:@"已签到" andWithDirectType:0];
    
    _arriveBtn.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
    
    _arriveBtn.userInteractionEnabled = NO;
    [self makeTimeLabelConstraints];
    
}

- (void)leaveClickChangeButton
{
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self viewDidLoad];
    
    [_clockTimer invalidate];
    [_arriveTimer invalidate];
    _leaveButton.hidden = YES;
    [_leaveButton removeFromSuperview];
    _leaveButton = nil;
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm";
    
    _leaveButton = [self createButtonWithView:_bottomView andWithText1:[formatter stringFromDate:currentDate] andWithText2:@"已签到" andWithDirectType:1];
    _leaveButton.backgroundColor = [UIColor colorWithRed:0.757 green:0.757 blue:0.761 alpha:1.000];
    _leaveButton.userInteractionEnabled = NO;
    [self makeTimeLabelConstraints];
}

//- (void)arriveclockDidTick{
//    static long value = 0;
//    value++;
//    int msperhour = 3600;
//    int mspermin = 60;
//
//    int hrs =  value / msperhour;
//    int mins = (value % msperhour) / mspermin;
//    int secs = (value % msperhour) % mspermin;
//    
//    
//    if (hrs == 0) {
//        if (mins == 0) {
//            _timeLabel.text = [NSString stringWithFormat:@"00:00:%02d", secs];
//        } else {
//            _timeLabel.text = [NSString stringWithFormat:@"00:%02d:%02d", mins, secs];
//        }
//    } else {
//        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hrs, mins, secs];
//    }
//    
//    
//}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //取消定时器
    [_clockTimer invalidate];
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
