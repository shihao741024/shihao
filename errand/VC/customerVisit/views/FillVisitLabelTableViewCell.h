//
//  FillVisitLabelTableViewCell.h
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJJLabel.h"

@interface FillVisitLabelTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *clearButton;

- (void)clearButtonClickAction:(void(^)(FillVisitLabelTableViewCell *currentCell))action;
- (void)contentLabelTapAction:(void(^)(FillVisitLabelTableViewCell *currentCell))action;

//新建拜访时使用
- (void)fillContent:(NSString *)content placeholder:(NSString *)placeholder;

//查询拜访记录时使用
- (void)searchVisitRecordFillContent:(NSString *)content placeholder:(NSString *)placeholder;

@end
