//
//  DoctorFillViewController.h
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsModel.h"

@interface DoctorFillViewController : UIViewController


@property (nonatomic, strong) DoctorsModel *doctorModel;

- (void)updateInfoSuccessAction:(void(^)())action;

@end
