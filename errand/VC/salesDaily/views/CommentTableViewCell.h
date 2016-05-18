//
//  CommentTableViewCell.h
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesDailyModel.h"
#import "CommentModel.h"
@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *kindNameLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *phoneModelLabel;
@property (nonatomic, strong)UIImageView *addressImgView;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)AmotButton *writeImgView;
@property (nonatomic, strong)UILabel *acountLabel;
@property (nonatomic, strong)UIImageView *sanJiaoImgView;

@property (nonatomic, copy)void(^writeBlock)();

- (void)setSalesDailyModel:(SalesDailyModel*)model;

@end
