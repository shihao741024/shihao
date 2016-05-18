//
//  AttendanceTableViewCell.h
//  errand
//
//  Created by gravel on 15/12/29.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecordModel.h"
#import "StaffRecordModel.h"
@interface AttendanceTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *bgImgView;
@property (nonatomic, strong)UIImageView *locationImgView;
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UILabel *timeLabel;

- (void)setAttendanceModel:(MyRecordModel*)model;
- (void)setStaffRecordModel:(StaffRecordModel*)model;
@end
