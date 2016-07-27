//
//  AttendanceViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AttendanceViewController.h"
#import "AttendanceBll.h"
#import "AttendanceTableViewCell.h"
#import "MyRecordModel.h"
#import "RecordViewController.h"
#import "AttendanceHeaderView.h"
#import "MMAlertView.h"
#import "MMPopupView.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import "MapViewController.h"
#import "SubordinateRecordViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import "ShowTrailViewController.h"
#import "WorkTrailViewController.h"

@interface AttendanceViewController ()<SRRefreshDelegate,AMapLocationManagerDelegate, AMapSearchDelegate>

@property (nonatomic, strong)UIView *bottomBgView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)AmotButton *checkPathBtn;
@property (nonatomic, strong)AmotButton *attendanceBtn;
@property (nonatomic, strong)UILabel *sumLabel;
@property (nonatomic, strong)UILabel *hintLabel;
@property (nonatomic, strong)AmotButton *myRecordBtn;
@property (nonatomic, strong)AmotButton *staffBtn;
@property (nonatomic, strong)UILabel *myLabel;
@property (nonatomic, strong)UILabel *myRcordLabel;
@property (nonatomic, strong)UILabel *staffLabel;
@property (nonatomic, strong)UILabel *staffRcordLabel;

// 地图定位
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation AttendanceViewController{
    
    NSMutableArray *_dataArray;
    
    NSString * currentLatitude;
    NSString * currentLongitude;
    CLLocation *checkinLocation;
    int _totalElements;
    
    AMapSearchAPI *_search;
    AMapReGeocodeSearchRequest *regeoRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"attendance", @"attendance");
    [self createView];
    
    // Do any additional setup after loading the view.
}

- (void)createView{
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets =NO;
    _dataArray=[[NSMutableArray alloc] init];
    
    [self createBottomView];
    [self createHeaderView];
    [self initData];
}

- (void)initData{
    
    //    获取当前日期的时间戳
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  startString=[NSString stringWithFormat:@"%@%@",[dateformatter stringFromDate:[NSDate date]],@"000000"];
    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
    [dateformatter2 setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *startDate = [dateformatter2 dateFromString:startString];
    NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
    [dateformatter3 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *startStr = [dateformatter3 stringFromDate:startDate];
    //        NSString *startTimeSp = [NSString stringWithFormat:@"%ld%@", (long)[startDate timeIntervalSince1970],@"000"];
    
    NSString *  endString=[NSString stringWithFormat:@"%@%@",[dateformatter stringFromDate:[NSDate date]],@"235959"];
    NSDate *endDate = [dateformatter2 dateFromString:endString];
    NSString *endStr = [dateformatter3 stringFromDate:endDate];
    //    NSLog(@"%@",endStr);
    //        NSString *endTimeSp = [NSString stringWithFormat:@"%ld%@", (long)[endDate timeIntervalSince1970],@"000"];
    
    //    获取当前日期
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [self showHintInView:self.view];
    AttendanceBll *attendanceBll = [[AttendanceBll alloc]init];
    [attendanceBll getTodayRecordData:^(NSArray *array, int totalElements) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dataArray addObject:obj];
        }];
        _totalElements = totalElements;
        [self hideHud];
        [self setDataToView];
        [self setDataToHeaderView];
    } type:0 pageIndex:1 startDate:startStr endDate:endStr viewCtrl:self];
    
}

- (void)setDataToView{
    
//    _timeLabel.text = @"08:30-17:30";
    [_checkPathBtn setBackgroundImage:[UIImage imageNamed:@"checkPath"] forState:UIControlStateNormal];
    [_checkPathBtn setBackgroundImage:[UIImage imageNamed:@"checkPath"] forState:UIControlStateHighlighted];
    [_checkPathBtn setTitle:NSLocalizedString(@"checkPath", @"checkPath") forState:UIControlStateNormal];
    [_attendanceBtn setBackgroundImage:[UIImage imageNamed:@"attendance"] forState:UIControlStateNormal];
    [_attendanceBtn setBackgroundImage:[UIImage imageNamed:@"attendance"] forState:UIControlStateHighlighted];
    //dongtaihuoqu
    _sumLabel.text = [NSString stringWithFormat:@"%d",_totalElements] ;
    //
    _hintLabel.text = NSLocalizedString(@"at least three times everyday", @"at least three times everyday");
    [_myRecordBtn setBackgroundImage:[UIImage imageNamed:@"bottom_left"] forState:UIControlStateNormal];
    [_myRecordBtn setBackgroundImage:[UIImage imageNamed:@"bottom_left"] forState:UIControlStateHighlighted];
    [_staffBtn setBackgroundImage:[UIImage imageNamed:@"bottom_right"] forState:UIControlStateNormal];
    [_staffBtn setBackgroundImage:[UIImage imageNamed:@"bottom_right"] forState:UIControlStateHighlighted];
    _myLabel.text = NSLocalizedString(@"my", @"my");
    _myRcordLabel.text = NSLocalizedString(@"record", @"record");
    _staffLabel.text = NSLocalizedString(@"staff", @"staff");
    _staffRcordLabel.text = NSLocalizedString(@"record", @"record");
}

- (void)setDataToHeaderView{
    //根据tag值
    int count = (int)(_bottomBgView.frame.origin.y -64 -10 )/[MyAdapter aDapterView:68];
    if (count >= _dataArray.count) {
        for (int i = 0; i < _dataArray.count ; i ++) {
            AttendanceHeaderView *view = (AttendanceHeaderView*)[self.view viewWithTag:10+_dataArray.count-1 - i];
            MyRecordModel *model = _dataArray[i];
            [view setMyRecordModelToView:model];
        }
        
    }else{
        for (int i = 0 ; i < count; i++) {
            AttendanceHeaderView *view = (AttendanceHeaderView*)[self.view viewWithTag:10+count-1-i];
            MyRecordModel *model = _dataArray[i];
            [view setMyRecordModelToView:model];
        }
    }
}

- (void)updateHeaderUI{
    [Dialog simpleToast:@"考勤上传成功"];
    _sumLabel.text = [NSString stringWithFormat:@"%d",[_sumLabel.text intValue]+1];
    int count = (int)(_bottomBgView.frame.origin.y -64 -10 )/[MyAdapter aDapterView:68];
    //对今天打卡的次数与屏幕能装的考勤条数做对比
    if (_dataArray.count > count) {
        for (int i = 0; i < count; i++) {
            AttendanceHeaderView *view = (AttendanceHeaderView*)[self.view viewWithTag:10+i];
            //每次移动后坐标有偏差
            if ((int)view.frame.origin.y <= 75 && (int)view.frame.origin.y >= 73) {
                [UIView animateWithDuration:0.5 animations:^{
                    view.frame = CGRectMake(SCREEN_WIDTH, view.frame.origin.y, SCREEN_WIDTH, view.frame.size.height);
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    view.frame = CGRectMake(-SCREEN_WIDTH, view.frame.origin.y+[MyAdapter aDapterView:68]*(count-1), SCREEN_WIDTH, view.frame.size.height);
                    [view setMyRecordModelToView:_dataArray[0]];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        view.frame = CGRectMake(0, view.frame.origin.y, SCREEN_WIDTH, view.frame.size.height);
                    }];
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [view setMyRecordModelToView:_dataArray[i]];
                    [UIView animateWithDuration:0.5 animations:^{
                        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -[MyAdapter aDapterView:68] , SCREEN_WIDTH, view.frame.size.height);
                        
                    }]; 
                });
            }
            //             NSLog(@"%f",view.frame.origin.y);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _attendanceBtn.userInteractionEnabled = YES;
        });
        
    }else{
        AttendanceHeaderView *view = (AttendanceHeaderView*)[self.view viewWithTag:10+_dataArray.count-1];
        [view setMyRecordModelToView:_dataArray[0]];
        _attendanceBtn.userInteractionEnabled = YES;
    }
}
//开辟线程先把头部的几个view创建好，之后刷新数据
- (void)createHeaderView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        int count = (int)(_bottomBgView.frame.origin.y -64 -10 )/[MyAdapter aDapterView:68];
        for (int i = 0 ; i < count; i++) {
            AttendanceHeaderView *view = [[AttendanceHeaderView alloc]initWithFrame:CGRectMake(0, 64+10+[MyAdapter aDapterView:68]*i, SCREEN_WIDTH - 20, [MyAdapter aDapterView:60])];
            view.tag = 10+i;
            [self.view addSubview:view];
        }
        
    });
}



- (void)createBottomView{
    //
    UIView *bgView = [[UIView alloc]init];
    //
    _bottomBgView = bgView;
    [self.view addSubview:_bottomBgView];
    
    UILabel *timeLabel = [self createLabelWithFont:[MyAdapter aDapterView:12] andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
    
    _timeLabel = timeLabel;
    
    _checkPathBtn = [[AmotButton alloc]init];
    [_bottomBgView addSubview:_checkPathBtn];
    
    _checkPathBtn.titleLabel.font = [UIFont systemFontOfSize:[MyAdapter aDapterView:14]];
    [_checkPathBtn setTitleColor:COMMON_FONT_BLACK_COLOR forState:UIControlStateNormal];
    [_checkPathBtn addTarget:self action:@selector(checkPathBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _attendanceBtn = [[AmotButton alloc]init];
    [_bottomBgView addSubview:_attendanceBtn];
    [_attendanceBtn addTarget:self action:@selector(attendanceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _sumLabel  = [self createLabelWithFont:[MyAdapter aDapterView:30] andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentCenter];
    _sumLabel.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:30]];
    _sumLabel.hidden = YES;
    
    _hintLabel = [self createLabelWithFont:[MyAdapter aDapterView:14] andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentCenter];
    
    _myRecordBtn = [[AmotButton alloc]init];
    [_bottomBgView addSubview:_myRecordBtn];
    
    [_myRecordBtn addTarget:self action:@selector(myRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _staffBtn = [[AmotButton alloc]init];
    [_bottomBgView addSubview:_staffBtn];
    
    [_staffBtn addTarget:self action:@selector(staffBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *myLabel = [self TWOcreateLabelWithFont:[MyAdapter aDapterView:14] andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
    _myLabel = myLabel;
    [_myRecordBtn addSubview:_myLabel];
    UILabel *myRecordLabel = [self TWOcreateLabelWithFont:[MyAdapter aDapterView:14] andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
    _myRcordLabel = myRecordLabel;
    [_myRecordBtn addSubview:_myRcordLabel];
    UILabel *staffLabel = [self TWOcreateLabelWithFont:[MyAdapter aDapterView:14] andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
    _staffLabel = staffLabel;
    [_staffBtn addSubview:_staffLabel];
    UILabel *staffRecordLabel = [self TWOcreateLabelWithFont:[MyAdapter aDapterView:14] andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
    _staffRcordLabel = staffRecordLabel;
    [_staffBtn addSubview:staffRecordLabel];
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_checkPathBtn.mas_top).offset(-[MyAdapter aDapterView:10]);
        make.width.equalTo(SCREEN_WIDTH - [MyAdapter aDapterView:30]);
        make.centerX.equalTo(_bottomBgView);
        make.height.equalTo([MyAdapter aDapterView:20]);
    }];
    
    [_checkPathBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_attendanceBtn.mas_top).offset(-[MyAdapter aDapterView:20]);
        make.width.equalTo([MyAdapter aDapterView:168]);
        make.height.equalTo([MyAdapter aDapterView:48]);
        make.centerX.equalTo(_bottomBgView);
    }];
    [_attendanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_sumLabel.mas_top).offset(-[MyAdapter aDapterView:12]);
        make.width.equalTo([MyAdapter aDapterView:160]);
        make.height.equalTo([MyAdapter aDapterView:160]);
        make.centerX.equalTo(_bottomBgView);
    }];
    [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_hintLabel.mas_top).offset(-[MyAdapter aDapterView:20]);
        make.width.equalTo(SCREEN_WIDTH - 30);
        make.height.equalTo([MyAdapter aDapter:25]);
        make.centerX.equalTo(_bottomBgView);
    }];
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBgView.mas_bottom).offset(-[MyAdapter aDapterView:30]);
        //        make.width.equalTo([MyAdapter aDapterView:150]);
        make.height.equalTo([MyAdapter aDapter:20]);
        make.left.equalTo(_myRecordBtn.mas_right).offset(10);
        make.right.equalTo(_staffBtn.mas_left).offset(-10);
        //        make.centerX.equalTo(_bottomBgView);
        
    }];
    [_myRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBgView.mas_bottom).offset(-[MyAdapter aDapterView:10]);
        make.width.equalTo([MyAdapter aDapterView:70]);
        make.height.equalTo([MyAdapter aDapterView:70]);
        make.left.equalTo(_bottomBgView.mas_left).offset([MyAdapter aDapterView:10]);
    }];
    [_staffBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBgView.mas_bottom).offset(-[MyAdapter aDapterView:10]);
        make.width.equalTo([MyAdapter aDapterView:70]);
        make.height.equalTo([MyAdapter aDapterView:70]);
        make.right.equalTo(_bottomBgView.mas_right).offset(-[MyAdapter aDapterView:10]);
    }];
    [_myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myRecordBtn.mas_top).offset([MyAdapter aDapterView:15]);
        make.width.equalTo([MyAdapter aDapterView:50]);
        make.centerX.equalTo(_myRecordBtn);
        make.height.equalTo([MyAdapter aDapterView:20]);
    }];
    [_myRcordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_myRecordBtn.mas_bottom).offset(-[MyAdapter aDapterView:15]);
        make.width.equalTo([MyAdapter aDapterView:50]);
        make.centerX.equalTo(_myRecordBtn);
        make.height.equalTo([MyAdapter aDapterView:20]);
    }];
    [_staffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_staffBtn.mas_top).offset([MyAdapter aDapterView:15]);
        make.width.equalTo([MyAdapter aDapterView:50]);
        make.centerX.equalTo(_staffBtn);
        make.height.equalTo([MyAdapter aDapterView:20]);
    }];
    [_staffRcordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_staffBtn.mas_bottom).offset(-[MyAdapter aDapterView:15]);
        make.width.equalTo([MyAdapter aDapterView:50]);
        make.centerX.equalTo(_staffBtn);
        make.height.equalTo([MyAdapter aDapterView:20]);
    }];
    
    
    
}

- (void)checkPathBtnClick{
//    MapViewController *mapVC = [[MapViewController alloc]init];
//    [self.navigationController pushViewController:mapVC animated:YES];
    
    WorkTrailViewController *worktrailCtrl = [[WorkTrailViewController alloc] init];
    worktrailCtrl.title = @"轨迹管理";
    [self.navigationController pushViewController:worktrailCtrl animated:YES];
    
//    ShowTrailViewController *trailMapCtrl = [[ShowTrailViewController alloc] init];
//    trailMapCtrl.saleId = GDBUserID;
//    [self.navigationController pushViewController:trailMapCtrl animated:YES];
}
//打卡 上传时间 地址 刷新ui
- (void)attendanceBtnClick{
    _attendanceBtn.userInteractionEnabled = NO;
    [self showHintInView:self.view];
    
    
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
    
    //        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    
    if (_search == nil) {
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
        regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.radius = 1000;
        regeoRequest.requireExtension = YES;
    }
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
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

- (void)myRecordBtnClick{
    RecordViewController *myRecordVC = [[RecordViewController alloc]init];
    myRecordVC.type = 0;
    [self.navigationController pushViewController:myRecordVC animated:YES];
}
- (void)staffBtnClick{
    SubordinateRecordViewController *staffRecordVC = [[SubordinateRecordViewController alloc]init];
    [self.navigationController pushViewController:staffRecordVC animated:YES];
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [_bottomBgView addSubview:label];
    return label;
}
-(UILabel *)TWOcreateLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    return label;
}

// 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果】
        //        AMapReGeocode *code=response.regeocode;
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        
        AttendanceBll *attendanceBll = [[AttendanceBll alloc]init];
        [attendanceBll addAttendanceData:^(MyRecordModel *model) {
            
            [self hideHud];
            [_dataArray insertObject:model atIndex:0];
            [self updateHeaderUI];
        } longitude:[NSString stringWithFormat:@"%f",request.location.longitude] latitude:[NSString stringWithFormat:@"%f",request.location.latitude] name:result viewCtrl:self];
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
