//
//  DoctorDetailShowTableViewCell.h
//  errand
//
//  Created by 高道斌 on 16/4/17.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorDetailShowTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;;


- (void)fillData:(NSString *)str;


@end
