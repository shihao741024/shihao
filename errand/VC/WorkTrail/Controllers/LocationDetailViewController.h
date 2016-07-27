//
//  LocationDetailViewController.h
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDetailViewController : UIViewController

@property (nonatomic, copy) NSString *saleId;
//每天截至时间
@property (nonatomic, copy) NSString *startDate;



@end
