//
//  CustomerVisitChildViewController.h
//  errand
//
//  Created by gravel on 15/12/19.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MySegmentViewController.h"

@interface CustomerVisitChildViewController : UIViewController

@property (nonatomic, assign)int type; //0 计划 1 临时

- (void)refreshData;
- (void)myVisitWillAppear:(void(^)())action;

@end
