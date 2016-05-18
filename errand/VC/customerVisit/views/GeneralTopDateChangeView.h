//
//  GeneralTopDateChangeView.h
//  errand
//
//  Created by pro on 16/4/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTopDateChangeView : UIView

@property (nonatomic, strong) UIButton *todayButton;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)buttonClickAction:(void(^)(NSInteger type))action;

@end
