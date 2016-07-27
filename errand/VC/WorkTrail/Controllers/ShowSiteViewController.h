//
//  ShowSiteViewController.h
//  errand
//
//  Created by 胡先生 on 16/7/26.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAMapKit.h>
@interface ShowSiteViewController : UIViewController

@property (nonatomic, assign)CLLocationDegrees lat;
@property (nonatomic, assign)CLLocationDegrees lon;
@property (nonatomic, strong)NSString *datetitle;
@property (nonatomic, strong)NSString *siteTitle;
@end
