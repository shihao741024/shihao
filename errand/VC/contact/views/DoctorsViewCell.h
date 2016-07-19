//
//  DoctorsViewCell.h
//  errand
//
//  Created by 医路同行Mac1 on 16/6/16.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorModel.h"

@interface DoctorsViewCell : UITableViewCell
- (void)fillData:(DoctorModel *)model;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *contentLable;


@end
