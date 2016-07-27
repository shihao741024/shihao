//
//  ShowTrailViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/19.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ShowTrailViewController.h"
#import "TravelSituationViewController.h"
#import "GeneralTopDateChangeView.h"
#import "CheckWorkFunction.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import "CustomPointAnnotation.h"
#import "CustomAnnotationView.h"
#import "WorkTrailFunction.h"
#import "TrailCheckView.h"

@interface ShowTrailViewController ()<MAMapViewDelegate>
{
    GeneralTopDateChangeView *_dateChangeView;
    int _dayIndex;
    MAMapView *_mapView;
    
    //在地图底图标注和兴趣点图标之上绘制overlay
    NSMutableArray *_overlaysAboveLabels;
    NSMutableArray *_overlaysAboveRoads;
    
    NSMutableArray *_stopAnnotations; //停止标注数组
    NSMutableArray *_allAnnotations;  //所有路径点数组
    NSMutableArray *_startEndAnnotations; //起点终点数组
    NSMutableArray *_freeSignAnnotations; //自由打卡数组
    NSMutableArray *_customerAnnotations; //客户拜访数组
    
    TrailCheckView *_trailCheckView;
}

@end

@implementation ShowTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = @"轨迹";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItemTitle:@"出行情况"];
    
    [self dataConfig];
    [self uiConfig];
    [self prepareData];
    
}
//初始化数组
- (void)dataConfig
{
    _dayIndex = 0;
    _overlaysAboveLabels = [NSMutableArray array];
    _stopAnnotations = [NSMutableArray array];
    
    _allAnnotations = [NSMutableArray array];
    
    _startEndAnnotations = [NSMutableArray array];
    _freeSignAnnotations = [NSMutableArray array];
    _customerAnnotations = [NSMutableArray array];
}

- (void)rightItemTitleClick
{
    TravelSituationViewController *travelSituationCtrl = [[TravelSituationViewController alloc] init];
    travelSituationCtrl.saleId = _saleId;
    travelSituationCtrl.startDate = [self getStartDate];
    [self.navigationController pushViewController:travelSituationCtrl animated:YES];
}

- (void)uiConfig
{
    [self createDateChangeView];
    [self addMapView];
    [self addTrailCheckView];
}

//添加左下角的view
- (void)addTrailCheckView
{
    _trailCheckView = [[TrailCheckView alloc] initWithFrame:CGRectMake(15, kHeight-90-15, 125, 90)];
    [self.view addSubview:_trailCheckView];
    
    [_trailCheckView buttonClickAction:^(NSInteger type, BOOL selected) {
        if (type == 0) {//自由打开
            if (selected) {
                [_mapView addAnnotations:_freeSignAnnotations];
                [_mapView showAnnotations:_freeSignAnnotations edgePadding:UIEdgeInsetsZero animated:YES];
            }else {
                [_mapView removeAnnotations:_freeSignAnnotations];
            }
        }else if (type == 1) {//客户拜访
            if (selected) {
                [_mapView addAnnotations:_customerAnnotations];
                [_mapView showAnnotations:_customerAnnotations edgePadding:UIEdgeInsetsZero animated:YES];
            }else {
                [_mapView removeAnnotations:_customerAnnotations];
            }
        }
    }];
}



- (void)addMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64+50, kWidth, kHeight-64-50)];
    _mapView.delegate = self;
    _mapView.userTrackingMode = 1;
    _mapView.showsUserLocation = NO;
    _mapView.zoomLevel = 11;
    [self.view addSubview:_mapView];
}

//时间切换view
- (void)createDateChangeView
{
    _dateChangeView = [[GeneralTopDateChangeView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    _dateChangeView.todayButton.hidden = YES;
    [self.view addSubview:_dateChangeView];
    
    [_dateChangeView buttonClickAction:^(NSInteger type) {
        
        if (type == -1) {
            _dayIndex = _dayIndex - 1;
        }else if (type == 1) {
            _dayIndex = _dayIndex + 1;
        }else {
            _dayIndex = 0;
        }
        
        if (_dayIndex == 0) {
            _dateChangeView.todayButton.hidden = YES;
        }else {
            _dateChangeView.todayButton.hidden = NO;
        }
        
        [self prepareData];
    }];
}
//每天截至时间
- (NSString *)getStartDate
{
    NSDate *date = [Function getPriousDateFromDate:[NSDate date] withDay:_dayIndex];
    NSString *startDate = [CheckWorkFunction stringFromDate:date isStart:NO];
    return startDate;
}

//重置地图
- (void)removeAllMapViewSign
{
    [_mapView removeOverlays:_overlaysAboveLabels];
    [_mapView removeAnnotations:_stopAnnotations];
    [_mapView removeAnnotations:_startEndAnnotations];
    
    [_mapView removeAnnotations:_allAnnotations];
    
    [_mapView removeAnnotations:_freeSignAnnotations];
    [_mapView removeAnnotations:_customerAnnotations];
}

- (void)prepareData
{
    
    [self removeAllMapViewSign];
    
    [self getSummaryData];
    
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/sale/path/track/%@", _saleId];
    
    NSString *startDate = [self getStartDate];
    NSDictionary *dic = @{@"startDate": startDate};
    
    _dateChangeView.titleLabel.text = [Function dateChangeTitle:_dayIndex dateStr:startDate];
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        [self selectBeyondhundredMeters:responseObject];
        [self freeSignCustomVisit:responseObject];
        [self hideHud];
    } errorCB:^(NSError *error) {
        [self hideHud];
    }];
   
}

//自由打卡的数组配置
- (void)freeSignCustomVisit:(id)responseObject
{
    NSArray *freeSign = [NSArray arrayWithArray:responseObject[@"coordinate"]];
    NSArray *customs = [NSArray arrayWithArray:responseObject[@"visitVos"]];
    
    [_freeSignAnnotations removeAllObjects];
    [_customerAnnotations removeAllObjects];
    
    for (NSDictionary *dic in freeSign) {
        CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:dic];
        CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:dic];
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
        annotation.title = dic[@"createDate"];
        annotation.subtitle = dic[@"coordinate"][@"name"];
        annotation.userName = dic[@"belongTo"][@"name"];
        annotation.type = @"自由打卡";
        if (dic[@"belongTo"][@"avatar"] == [NSNull null]) {
            annotation.avatar = @"";
        }else {
            annotation.avatar = dic[@"belongTo"][@"avatar"];
        }
        [_freeSignAnnotations addObject:annotation];
    }
    
    for (NSDictionary *dic in customs) {
        //arrive
        CLLocationDegrees lat1 = [dic[@"arrive"][@"latitude"] doubleValue];
        CLLocationDegrees lon1 = [dic[@"arrive"][@"longitude"] doubleValue];
        
        CustomPointAnnotation *annotation1 = [[CustomPointAnnotation alloc] init];
        annotation1.coordinate = CLLocationCoordinate2DMake(lat1,lon1);
        annotation1.title = [WorkTrailFunction getAnnotationTitle:dic[@"arriveDate"]];
        annotation1.subtitle = dic[@"arrive"][@"name"];
        annotation1.type = @"客户拜访抵";
        [_customerAnnotations addObject:annotation1];
        
        //leave
        CLLocationDegrees lat2 = [dic[@"leave"][@"latitude"] doubleValue];
        CLLocationDegrees lon2 = [dic[@"leave"][@"longitude"] doubleValue];
        
        CustomPointAnnotation *annotation2 = [[CustomPointAnnotation alloc] init];
        annotation2.coordinate = CLLocationCoordinate2DMake(lat2,lon2);
        annotation2.title = [WorkTrailFunction getAnnotationTitle:dic[@"leaveDate"]];
        annotation2.subtitle = dic[@"leave"][@"name"];
        annotation2.type = @"客户拜访离";
        [_customerAnnotations addObject:annotation2];
    }
    
}

//获取停止数据
- (void)getSummaryData
{
    NSString *urlStr = [BASEURL stringByAppendingFormat:@"/api/v1/sale/path/summary/%@", _saleId];
    NSString *startDate = [self getStartDate];
    NSDictionary *dic = @{@"startDate": startDate};
    
    [Function generalPostRequest:urlStr infoDic:dic resultCB:^(id responseObject) {
        
        
        [self configResult:responseObject];
    } errorCB:^(NSError *error) {
       
    }];
}

//配置停止数组
- (void)configResult:(id)responseObject
{
    NSArray *resArray = [NSArray arrayWithArray:responseObject];
    NSMutableArray *stopArray = [NSMutableArray array];
    
    for (NSDictionary *dic in resArray) {
        if ([dic[@"action"] isEqualToString:@"停"]) {
            [stopArray addObject:dic];
        }
    }
    
    [_stopAnnotations removeAllObjects];
    for (NSDictionary *dic in stopArray) {
        
        CLLocationDegrees lat = [WorkTrailFunction getSummaryLatWithDic:dic];
        CLLocationDegrees lon = [WorkTrailFunction getSummaryLonWithDic:dic];
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
        annotation.title = [WorkTrailFunction getAnnotationTitle:dic[@"startDate"]];
        annotation.subtitle = dic[@"location"];
        annotation.type = @"停";
        [_stopAnnotations addObject:annotation];
        
    }
    
    [_mapView addAnnotations:_stopAnnotations];
//    [_mapView showAnnotations:_stopAnnotations edgePadding:UIEdgeInsetsZero animated:YES];
    
}

- (void)selectBeyondhundredMeters:(id)responseObject
{
    NSMutableArray *path = [NSMutableArray arrayWithArray:responseObject[@"path"]];
    //删除没数据的点
    for (NSInteger i=path.count-1; i>=0; i--) {
        NSDictionary *dic = path[i];
        if (dic[@"coordinate"] == [NSNull null]) {
            [path removeObject:dic];
        }
        
    }
    
    if (path.count == 0) {
        return;
    }
    
    //删除100米之内的点
    NSMutableArray *handlePath = [NSMutableArray array];
    [handlePath addObject:path[0]];
    
//    [_allAnnotations removeAllObjects];
    for (NSInteger i=0; i<path.count; i++) {
        NSDictionary *firstDic = path[i];
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:firstDic];
        CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:firstDic];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
        [_allAnnotations addObject:annotation];
        [_mapView addAnnotations:_allAnnotations];
        [_mapView showAnnotations:_allAnnotations edgePadding:UIEdgeInsetsMake(80, 20, 80, 20) animated:NO];
        
        
        if (i+1 < path.count) {
            NSDictionary *secondDic = path[i+1];
            
            CLLocationDegrees lat1 = [WorkTrailFunction getLatWithDic:firstDic];
            CLLocationDegrees lon1 = [WorkTrailFunction getLonWithDic:firstDic];
            
            CLLocationDegrees lat2 = [WorkTrailFunction getLatWithDic:secondDic];
            CLLocationDegrees lon2 = [WorkTrailFunction getLonWithDic:secondDic];
            //1.将两个经纬度点转成投影点
            MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat1,lon1));
            MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat2,lon2));
            //2.计算距离, 单位米
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            
            if (distance > 100) {
                [handlePath addObject:secondDic];
            }
        }
    }
    
    [self configTexPolylineCoords:handlePath];
}

//始和终的标注的数组配置
- (void)configStartEndAnnotations:(NSMutableArray *)points
{
    
    [_startEndAnnotations removeAllObjects];
    //已经做了count ！= 0 的判断
    NSDictionary *startDic = points[0];
    NSDictionary *endDic = [points lastObject];
    NSArray *startEndArray = @[startDic, endDic];
    
    for (NSInteger i=0; i<startEndArray.count; i++) {
        NSDictionary *dic = startEndArray[i];
        CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:dic];
        CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:dic];
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
        annotation.title = dic[@"planDate"];//[WorkTrailFunction getAnnotationTitle:dic[@"createDate"]];
        annotation.subtitle = dic[@"coordinate"][@"name"];
        
        if (i == 0) {
            annotation.type = @"起";
        }else {
            annotation.type = @"终";
        }
        [_startEndAnnotations addObject:annotation];
        
    }
    
    [_mapView addAnnotations:_startEndAnnotations];
//    [_mapView showAnnotations:_startEndAnnotations edgePadding:UIEdgeInsetsZero animated:YES];
}

//路线图
- (void)configTexPolylineCoords:(NSMutableArray *)points
{
    NSInteger count = points.count;
    CLLocationCoordinate2D texPolylineCoords[count];
    
    for (NSInteger i=0; i<points.count; i++) {
        NSDictionary *rootDic = points[i];
        
        texPolylineCoords[i].latitude = [WorkTrailFunction getLatWithDic:rootDic];
        texPolylineCoords[i].longitude = [WorkTrailFunction getLonWithDic:rootDic];
        
    }
    if (count != 0) {
        
        [_overlaysAboveLabels removeAllObjects];
        MAPolyline *texPolyline = [MAPolyline polylineWithCoordinates:texPolylineCoords count:count];
        [_overlaysAboveLabels insertObject:texPolyline atIndex:0];
        [_mapView addOverlays:_overlaysAboveLabels level:MAOverlayLevelAboveLabels];
        
        [self configStartEndAnnotations:points];
    }
    
}

//每段路线view
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        
        if (overlay == _overlaysAboveLabels[0])
        {
            polylineRenderer.lineWidth    = 10.f;
            [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
            
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - MAMapViewDelegate

//每个标注view
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    CustomPointAnnotation *pointAnnotation = (CustomPointAnnotation *)annotation;
    /*
    if ([pointAnnotation.type isEqualToString:@"自由打卡"]) {
        
        CustomPointAnnotation *customAnnotation = (CustomPointAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:customReuseIndetifier];
        }
        
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout   = YES;
        annotationView.draggable        = NO;
        annotationView.calloutOffset    = CGPointMake(0, -5);
        annotationView.name             = customAnnotation.userName;
//        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:customAnnotation.avatar] placeholderImage:[UIImage imageNamed:@"free_sign"]];
        annotationView.portraitImageView.image = [UIImage imageNamed:@"free_sign"];
        
        return annotationView;
        
    }else if ([pointAnnotation.type isEqualToString:@"起"] || [pointAnnotation.type isEqualToString:@"停"] || [pointAnnotation.type isEqualToString:@"终"] || [pointAnnotation.type isEqualToString:@"客户拜访抵"] || [pointAnnotation.type isEqualToString:@"客户拜访离"]) {
        
        static NSString *reuseIndetifier = @"reuseIndetifier";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:pointAnnotation reuseIdentifier:reuseIndetifier];
        }
        
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        
        if ([pointAnnotation.type isEqualToString:@"停"]) {
            annotationView.image = [UIImage imageNamed:@"default_mark_stop"];
            
        }else if ([pointAnnotation.type isEqualToString:@"起"]) {
            annotationView.image = [UIImage imageNamed:@"default_startpoint"];
            
        }else if ([pointAnnotation.type isEqualToString:@"终"]) {
            annotationView.image = [UIImage imageNamed:@"default_endpoint"];
            
        }else if ([pointAnnotation.type isEqualToString:@"客户拜访抵"]) {
            annotationView.image = [UIImage imageNamed:@"senior_visit_arrive_b"];
            
        }else if ([pointAnnotation.type isEqualToString:@"客户拜访离"]) {
            annotationView.image = [UIImage imageNamed:@"senior_visit_leave_b"];
            
        }
        
        return annotationView;
    }
    */
    static NSString *reuseIndetifier = @"reuseIndetifier";
    
    MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    
    if (annotationView == nil)
    {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:pointAnnotation reuseIdentifier:reuseIndetifier];
    }
    
    // must set to NO, so we can show the custom callout view.
    annotationView.canShowCallout = YES;
    annotationView.draggable = NO;
    
    if ([pointAnnotation.type isEqualToString:@"停"]) {
        annotationView.image = [UIImage imageNamed:@"default_mark_stop"];
        
    }else if ([pointAnnotation.type isEqualToString:@"起"]) {
        annotationView.image = [UIImage imageNamed:@"default_startpoint"];
        
    }else if ([pointAnnotation.type isEqualToString:@"终"]) {
        annotationView.image = [UIImage imageNamed:@"default_endpoint"];
        
    }else if ([pointAnnotation.type isEqualToString:@"客户拜访抵"]) {
        annotationView.image = [UIImage imageNamed:@"senior_visit_arrive_b"];
        
    }else if ([pointAnnotation.type isEqualToString:@"客户拜访离"]) {
        annotationView.image = [UIImage imageNamed:@"senior_visit_leave_b"];
        
    }else if ([pointAnnotation.type isEqualToString:@"自由打卡"]) {
        annotationView.image = [UIImage imageNamed:@"sign"];
        
    }
    
    return annotationView;
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [_mapView addAnnotations:_allAnnotations];
    [_mapView showAnnotations:_allAnnotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
}
- (void)navigationItemClicked:(UIBarButtonItem *)barButtonItem;
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    [_mapView.layer removeAllAnimations];
    _mapView.delegate = nil;
    [_mapView removeAnnotations:_allAnnotations];
    [_mapView removeOverlays:_overlaysAboveLabels];
    [_mapView removeFromSuperview];
    _mapView = nil;
    
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
