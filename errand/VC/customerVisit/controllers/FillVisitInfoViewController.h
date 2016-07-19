//
//  FillVisitInfoViewController.h
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillVisitInfoViewController : UIViewController

@property (nonatomic, assign) NSInteger type; //0新建计划， 1新建临时

- (void)uploadData;

- (void)uploadDataFinishAction:(void(^)(NSString *dateStr))action;

@end
