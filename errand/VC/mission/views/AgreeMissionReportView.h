//
//  AgreeMissionReportView.h
//  errand
//
//  Created by 医路同行Mac1 on 16/5/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeMissionReportView : UIView

@property (nonatomic, strong) UITextView *textView;

- (void)buttonClickAction:(void(^)(NSInteger index))action;

@end
