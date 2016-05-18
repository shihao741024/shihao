//
//  CornerBgView.h
//  iOS_company2.0
//
//  Created by LZios on 15/12/4.
//  Copyright © 2015年 LZios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CornerStyle) {//圆角类型
    CornerNone,
    CornerTop,
    CornerMiddle,
    CornerBottom,
    CornerSingle
};

@interface CornerBgView : UIView

- (instancetype)initWithFrame:(CGRect)frame cornerStyle:(CornerStyle)cornerStyle cornerRadius:(CGFloat)cornerRadius;

- (void)handleSetNeedsLayoutWithStyle:(CornerStyle)cornerStyle;

@end
