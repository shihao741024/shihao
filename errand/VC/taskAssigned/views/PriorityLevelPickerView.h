//
//  PriorityLevelPickerView.h
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriorityLevelPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSString *currentString;
@property (nonatomic, copy) void(^feedBack)(NSString *);
@property (nonatomic, strong) NSString *feedBackString;

@end
