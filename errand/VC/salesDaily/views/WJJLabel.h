//
//  WJJLabel.h
//  errand
//
//  Created by wjjxx on 16/3/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJJLabelDelegate <NSObject>

@optional
- (void)changeDataSourceWithIndex:(NSInteger)index;

@end

@interface WJJLabel : UILabel

@property (nonatomic, retain) UIButton *clearButton;

@property (nonatomic, weak) id <WJJLabelDelegate> delegate;

- (void)setTextWithString:(NSString *)string andIndex:(NSInteger)index;

@end
