//
//  UILabel+setText.m
//  test
//
//  Created by 徐祥 on 16/3/17.
//  Copyright © 2016年 徐祥. All rights reserved.
//

#import "UILabel+setText.h"

@implementation UILabel (setText)

- (void)setTextWithString:(NSString *)string {
    
    self.userInteractionEnabled = YES;
    if (![string isEqualToString:@""]) {
        
        if (!self.subviews.count) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + self.bounds.size.width - 30, self.bounds.origin.y + self.bounds.size.height / 2 - 15, 30, 30)];
                btn.tag = 10;
                [btn setImage:[UIImage imageNamed:@"clear_text"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
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
}

@end
