//
//  AgreeDeclareReportView.h
//  errand
//
//  Created by 高道斌 on 16/4/23.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeDeclareReportView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

- (void)buttonClickAction:(void(^)(NSInteger index))action;

@end
