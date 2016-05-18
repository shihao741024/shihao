//
//  WJJLabel.m
//  errand
//
//  Created by wjjxx on 16/3/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "WJJLabel.h"

@implementation WJJLabel {
    
    NSInteger _index;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTextWithString:(NSString *)string andIndex:(NSInteger)index {

    _index = index;
    
    if (![string isEqualToString:@""]) {
        
        if (!self.subviews.count) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_clearButton == nil) {
                    _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + self.bounds.size.width - 50, self.bounds.origin.y + self.bounds.size.height / 2 - 25, 50, 50)];
                    //                btn.tag = index;
                    [_clearButton setImage:[UIImage imageNamed:@"clear_text"] forState:UIControlStateNormal];
                    [_clearButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:_clearButton];
                }
                _clearButton.hidden = NO;
            });
        }
        
        [[self.subviews lastObject] setHidden:NO];
        self.text = string;
    } else {
        
        self.text = string;
        if (self.subviews.count) {
            
            [[self.subviews lastObject] setHidden:YES];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    
    self.text = @"";
    btn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(changeDataSourceWithIndex:)]) {
        
        [self.delegate changeDataSourceWithIndex:_index];
    }
    
}

@end
