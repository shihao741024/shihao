//
//  UIView+Category.m
//  errand
//
//  Created by gravel on 16/3/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

//获取当前屏幕显示的viewcontroller

-  (UIViewController *)getCurrentVC {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;  
}
@end
