//
//  WorkTrailTopSelectView.h
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTrailTopSelectView : UIView

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray *lineArray;

@property (nonatomic, strong) UIView *bottomLine;

- (void)setSelectButton:(NSInteger)index;

- (void)selectIndexAction:(void(^)(NSInteger index))action;

@end
