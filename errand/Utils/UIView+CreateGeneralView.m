//
//  UIView+CreateGeneralView.m
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "UIView+CreateGeneralView.h"

@implementation UIView (CreateGeneralView)

- (UILabel *)createGeneralLabel:(CGFloat)font frame:(CGRect)frame textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.font = GDBFont(font);
    [self addSubview:label];
    return label;
}

- (SRRefreshView *)createSlimeRefreshView
{
    SRRefreshView *slimeView = [[SRRefreshView alloc] init];
    slimeView.upInset =0;
    slimeView.slimeMissWhenGoingBack = YES;
    slimeView.slime.bodyColor = [UIColor grayColor];
    slimeView.slime.skinColor = [UIColor grayColor];
    slimeView.slime.lineWith = 1;
    slimeView.slime.shadowBlur = 4;
    slimeView.slime.shadowColor = [UIColor grayColor];
    [self addSubview:slimeView];
    return slimeView;
}

- (void)hideHud
{
    [MBProgressHUD HUDForView:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
