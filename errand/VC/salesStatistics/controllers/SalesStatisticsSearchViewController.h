//
//  SalesStatisticsSearchViewController.h
//  errand
//
//  Created by 高道斌 on 16/4/20.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesStatisticsSearchViewController : UIViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDictionary *saveDic;

- (void)backSearchParameterAction:(void(^)(NSDictionary *parameter, NSDictionary *saveDic))action;

@end
