//
//  CornerBgView.m
//  iOS_company2.0
//
//  Created by LZios on 15/12/4.
//  Copyright © 2015年 LZios. All rights reserved.
//

#import "CornerBgView.h"



@implementation CornerBgView
{
    CornerStyle _cornerStyle;
    CGFloat _cornerRadius;
}

- (instancetype)initWithFrame:(CGRect)frame cornerStyle:(CornerStyle)cornerStyle cornerRadius:(CGFloat)cornerRadius
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _cornerRadius = cornerRadius;
        _cornerStyle = cornerStyle;
    }
    return self;
    
}

- (void)drawCornerTopRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                           cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    bezierPath.lineWidth = 1;
    [[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00] setStroke];
    [bezierPath stroke];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}



- (void)drawCornerBottomRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                           cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    bezierPath.lineWidth = 1;
    [[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00] setStroke];
    [bezierPath stroke];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)drawSideLineRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1;
    [[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00] setStroke];
    
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [bezierPath stroke];
    
    [bezierPath moveToPoint:CGPointMake(rect.size.width, 0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [bezierPath stroke];
    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = bezierPath.CGPath;
//    self.layer.mask = maskLayer;
}

- (void)drawCornerSingleRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                           cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    bezierPath.lineWidth = 1;
    [[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.00] setStroke];
    [bezierPath stroke];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    if (_cornerStyle == CornerTop) {
        [self drawCornerTopRect:rect];
        
    }else if (_cornerStyle == CornerMiddle) {
        [self drawSideLineRect:rect];
        
    }else if (_cornerStyle == CornerBottom) {
        [self drawCornerBottomRect:rect];
        
    }else if (_cornerStyle == CornerSingle) {
        [self drawCornerSingleRect:rect];
    }
    
}

- (void)handleSetNeedsLayoutWithStyle:(CornerStyle)cornerStyle
{
    _cornerStyle = cornerStyle;
    [self setNeedsLayout];
}


@end
