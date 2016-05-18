//
//  EveryLoctionViewController.h
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATableView.h"


@interface EveryLocationBAView : BATableView
//0全部，1正常，2异常
@property (nonatomic, assign) NSInteger status;

@end



@interface HeadStaticView : UIView

@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, copy) void(^chooseButtonCB)(BOOL selected);

- (void)fillCount:(NSInteger)count;

//0全部，1正常，2异常
- (void)chooseButtonAction:(void(^)(BOOL selected))action;

@end



@interface EveryLoctionViewController : UIViewController

@end
