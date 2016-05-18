//
//  OptionSelectDistriViewController.h
//  errand
//
//  Created by 高道斌 on 16/4/21.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface OptionSelectDistriViewController : UIViewController

@property (nonatomic, strong) ContactModel *contactModel;

- (void)selectedDistriDicAction:(void(^)(NSDictionary *distriDic))action;

@end
