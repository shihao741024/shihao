//
//  ColorGuideStatusView.m
//  errand
//
//  Created by pro on 16/4/15.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ColorGuideStatusView.h"

@implementation ColorGuideStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *falseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        falseView.backgroundColor = [UIColor colorWithRed:0.88 green:0.50 blue:0.43 alpha:1.00];
        falseView.layer.backgroundColor = [UIColor colorWithRed:0.88 green:0.50 blue:0.43 alpha:1.00].CGColor;
        falseView.layer.cornerRadius = 10;
        [self addSubview:falseView];
        
        UILabel *falseLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 0, 20)];
        falseLabel.text = @"异常";
        falseLabel.font = GDBFont(13);
        [self addSubview:falseLabel];
        [falseLabel sizeToFit];
        falseLabel.frame = CGRectMake(25, 0, kFrameW(falseLabel), 20);
        
        
        
        UIView *incompleteView = [[UIView alloc] initWithFrame:CGRectMake(kFrameX(falseLabel)+kFrameW(falseLabel)+10, 0, 20, 20)];
//        incompleteView.backgroundColor = [UIColor colorWithRed:0.46 green:0.25 blue:0.84 alpha:1.00];
        incompleteView.layer.backgroundColor = [UIColor colorWithRed:0.46 green:0.25 blue:0.84 alpha:1.00].CGColor;
        incompleteView.layer.cornerRadius = 10;
        [self addSubview:incompleteView];
        
        UILabel *incompleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        incompleteLabel.text = @"点不全";
        incompleteLabel.font = GDBFont(13);
        [self addSubview:incompleteLabel];
        [incompleteLabel sizeToFit];
        incompleteLabel.frame = CGRectMake(kFrameX(incompleteView)+kFrameW(incompleteView)+5, 0, kFrameW(incompleteLabel), 20);
        
        
        
        UIView *tureView = [[UIView alloc] initWithFrame:CGRectMake(kFrameX(incompleteLabel)+kFrameW(incompleteLabel)+10, 0, 20, 20)];
//        tureView.backgroundColor = [UIColor colorWithRed:0.88 green:0.50 blue:0.43 alpha:1.00];
        tureView.layer.backgroundColor = [UIColor colorWithRed:0.20 green:0.64 blue:0.41 alpha:1.00].CGColor;
        tureView.layer.cornerRadius = 10;
        [self addSubview:tureView];
        
        UILabel *trueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        trueLabel.text = @"正常";
        trueLabel.font = GDBFont(13);
        [self addSubview:trueLabel];
        [trueLabel sizeToFit];
        trueLabel.frame = CGRectMake(kFrameX(tureView)+kFrameW(tureView)+5, 0, kFrameW(trueLabel), 20);
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
