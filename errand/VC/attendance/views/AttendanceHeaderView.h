//
//  AttendanceHeaderView.h
//  errand
//
//  Created by gravel on 15/12/30.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecordModel.h"
@interface AttendanceHeaderView : UIView
@property (nonatomic, strong)UIView *bgImgView;
@property (nonatomic, strong)UIImageView *locationImgView;
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UILabel *headerTimeLabel;

- (void)setMyRecordModelToView:(MyRecordModel*)model;

@end
