//
//  LoctionLayoutViewController.m
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

//位置分布
#import "LoctionLayoutViewController.h"

#import "CustomAnnotationView.h"
#import "CustomPointAnnotation.h"
#import "WorkTrailFunction.h"

@interface LoctionLayoutViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    NSMutableArray *_dataArray;
    
    NSMutableArray *_annotations;
}
@end

@implementation LoctionLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self dataInit];
    [self uiConfig];
    [self prepareData];
}

- (void)uiConfig
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _mapView.delegate = self;
    _mapView.userTrackingMode = 1;
    _mapView.showsUserLocation = NO;
    _mapView.zoomLevel = 11;
//    _mapView.hidden = YES;
    _mapView.rotateEnabled = NO;
    [self.view addSubview:_mapView];
}

- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/path/last"];
    NSDictionary *dic = @{@"ids":@[]};
    //ids为空时不传
    
    [self showHintInView:self.view];
    [Function generalPostRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        
        [self hideHud];
        [self selectnormalData:responseObject];
    } errorCB:^(NSError *error) {
        [self hideHud];
        
    }];
}

- (void)dataInit
{
    
    _annotations = [NSMutableArray array];
}

- (void)selectnormalData:(id)responseObject
{
    _dataArray = [NSMutableArray arrayWithArray:responseObject];
    
    for (NSInteger i=_dataArray.count-1; i>=0; i--) {
        NSDictionary *dic = _dataArray[i];
        if (dic[@"coordinate"] == [NSNull null]) {
            [_dataArray removeObject:dic];
        }
    }
    
    [self addAnnotationsWithArray:_dataArray showAnnos:YES];
}

- (void)addAnnotationsWithArray:(NSMutableArray *)dataArray showAnnos:(BOOL)showAnnos
{
    [_annotations removeAllObjects];
    for (NSDictionary *dic in dataArray) {
        
        CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:dic];
        CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:dic];
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
        annotation.title = [WorkTrailFunction getAnnotationTitle:dic[@"createDate"]];
        annotation.subtitle = dic[@"coordinate"][@"name"];
        annotation.userName = dic[@"userName"];
        if (dic[@"avatar"] == [NSNull null]) {
            annotation.avatar = @"";
        }else {
            annotation.avatar = dic[@"avatar"];
        }
        
        [_annotations addObject:annotation];
        
    }
    
    [_mapView addAnnotations:_annotations];
    if (showAnnos) {
        [_mapView showAnnotations:_annotations edgePadding:UIEdgeInsetsZero animated:YES];
    }
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomPointAnnotation class]])
    {
        CustomPointAnnotation *customAnnotation = (CustomPointAnnotation *)annotation;
        
        if ([customAnnotation.type isEqualToString:@"数字"]) {
            static NSString *customReuseIndetifier = @"numberReuseIndetifier";
            
            NumberAnnotationView *annotationView = (NumberAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
            
            if (annotationView == nil)
            {
                annotationView = [[NumberAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:customReuseIndetifier];
            }
            
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout   = YES;
            annotationView.draggable        = NO;
            annotationView.calloutOffset    = CGPointMake(0, -5);
            //        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:customAnnotation.avatar] placeholderImage:[UIImage imageNamed:@"location_layout"]];
            annotationView.numberLabel.text = customAnnotation.userName;
            
            return annotationView;
        }else {
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
            //        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:customAnnotation.avatar] placeholderImage:[UIImage imageNamed:@"location_layout"]];
            annotationView.portraitImageView.image = [UIImage imageNamed:@"location_layout"];
            annotationView.name             = customAnnotation.userName;
            
            return annotationView;
        }
        
    }
    
    return nil;
}

#pragma mark - Action Handle

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{
    
    
    if (wasUserAction) {
        NSLog(@"%f", mapView.zoomLevel);
        [_mapView removeAnnotations:_annotations];
        
        
        if (mapView.zoomLevel < 12) {
            [self configNumberAnnos:_mapView];
        }else {
            
            [self addAnnotationsWithArray:_dataArray showAnnos:NO];
        }
    }else{
        
        [_mapView removeAnnotations:_annotations];
        if (mapView.zoomLevel < 12) {
            [self configNumberAnnos:_mapView];
        }else{
            [self addAnnotationsWithArray:_dataArray showAnnos:NO];
        }
        
    }
}

- (BOOL)isExistDic:(NSDictionary *)dic inTempAarray:(NSMutableArray *)tempArray
{
    for (NSArray *array in tempArray) {
        
        for (NSDictionary *tempDic in array) {
            if ([tempDic[@"createDate"] isEqual:dic[@"createDate"]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)configNumberAnnos:(MAMapView *)mapView
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in _dataArray) {
        BOOL exist = [self isExistDic:dic inTempAarray:tempArray];
        if (exist) {
            continue;
        }
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dic];
        [tempArray addObject:array];
        
        CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:dic];
        CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:dic];
        
        for (NSDictionary *twoDic in _dataArray) {
            CLLocationDegrees TwoLat = [WorkTrailFunction getLatWithDic:twoDic];
            CLLocationDegrees TwoLon = [WorkTrailFunction getLonWithDic:twoDic];
            
            double meter = 44*mapView.metersPerPointForCurrentZoom;
            BOOL isContains = [self isInSameCircle:TwoLat lon:TwoLon centerLat:lat centerLon:lon meter:meter];
            
            if (isContains) {
                BOOL exist = [self isExistDic:twoDic inTempAarray:tempArray];
                if (!exist) {
                    [array addObject:twoDic];
                }
                
            }
        }
    }
    
    NSLog(@"tempArray %@", tempArray);
    [self addNumberAnnotationsWithArray:tempArray];
}

- (void)addNumberAnnotationsWithArray:(NSMutableArray *)numberArray
{
    [_annotations removeAllObjects];
    for (NSArray *array in numberArray) {
        
        NSDictionary *dic = array[0];
        
        if (array.count == 1) {
            CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:dic];
            CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:dic];
            
            CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
            annotation.title = [WorkTrailFunction getAnnotationTitle:dic[@"createDate"]];
            annotation.subtitle = dic[@"coordinate"][@"name"];
            annotation.userName = dic[@"userName"];
            annotation.type = @"";
            if (dic[@"avatar"] == [NSNull null]) {
                annotation.avatar = @"";
            }else {
                annotation.avatar = dic[@"avatar"];
            }
            
            [_annotations addObject:annotation];
        }else {
            CLLocationDegrees lat = [WorkTrailFunction getLatWithDic:dic];
            CLLocationDegrees lon = [WorkTrailFunction getLonWithDic:dic];
            
            CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
            annotation.title = [NSString stringWithFormat:@"%ld人", array.count];
            annotation.subtitle = @"";
            annotation.userName = [NSString stringWithFormat:@"%ld", array.count];
            annotation.type = @"数字";
            if (dic[@"avatar"] == [NSNull null]) {
                annotation.avatar = @"";
            }else {
                annotation.avatar = dic[@"avatar"];
            }
            
            [_annotations addObject:annotation];
        }
    }
    
    [_mapView addAnnotations:_annotations];
    
}

- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction
{
    
}

- (BOOL)isInSameCircle:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon centerLat:(CLLocationDegrees)centerLat centerLon:(CLLocationDegrees)centerLon meter:(double)meter
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat,lon);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(centerLat,centerLon);
    BOOL isContains = MACircleContainsCoordinate(location, center, meter);
    return isContains;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation NumberAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 44, 44);
        
        self.backgroundColor = [UIColor whiteColor];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _numberLabel.font = GDBFont(15);
//        _numberLabel.backgroundColor = [UIColor colorWithRed:0.60 green:0.70 blue:0.35 alpha:1.00];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.layer.backgroundColor = [UIColor colorWithRed:0.60 green:0.70 blue:0.35 alpha:1.00].CGColor;
        _numberLabel.layer.cornerRadius = 22;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_numberLabel];
        
    }
    
    return self;
}

@end
