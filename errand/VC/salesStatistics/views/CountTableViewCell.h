//
//  CountTableViewCell.h
//  errand
//
//  Created by gravel on 16/2/27.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticsCountModel.h"
@interface CountTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *pillLabel;
@property (nonatomic, strong)UILabel *hospitalLabel;
@property (nonatomic, strong)UILabel *countLabel;


-(void)setStatisticsCountModel:(StatisticsCountModel *)model andColor:(UIColor *)color type:(int)type;

@end
