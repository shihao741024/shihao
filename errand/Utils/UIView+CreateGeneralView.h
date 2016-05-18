//
//  UIView+CreateGeneralView.h
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CreateGeneralView)

- (UILabel *)createGeneralLabel:(CGFloat)font frame:(CGRect)frame textColor:(UIColor *)textColor;

- (SRRefreshView *)createSlimeRefreshView;

- (void)hideHud;

@end
