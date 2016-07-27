//
//  ShowSiteViewController.m
//  errand
//
//  Created by 胡先生 on 16/7/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ShowSiteViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import "LocationDetailViewController.h";
#import "CustomPointAnnotation.h"

@interface ShowSiteViewController ()<MAMapViewDelegate>
{

    MAMapView *_mapView;
    NSMutableArray *_siteAnnotations;
    CLLocationDegrees _lat;
    CLLocationDegrees _lon;

}
@end

@implementation ShowSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"具体位置";
    [self addMapView];
     [self.view addSubview:_mapView];
//    _siteAnnotations = [[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  添加地图
-(void)addMapView{

    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    _mapView.delegate = self;
    _mapView.userTrackingMode = 1;
    _mapView.rotateEnabled = NO;
    _mapView.showsUserLocation = NO;
    _mapView.zoomLevel = 15;
    
    
    
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc]init];
    
//    NSLog(@"self.lat------------>%f",self.lat);
//    NSLog(@"self.lon------------>%f",self.lon);
    
    annotation.coordinate = CLLocationCoordinate2DMake(self.lat, self.lon);
    annotation.title = self.datetitle;
    annotation.subtitle = self.siteTitle;
    [_mapView addAnnotation:annotation];

    [_mapView setCenterCoordinate:annotation.coordinate];
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
