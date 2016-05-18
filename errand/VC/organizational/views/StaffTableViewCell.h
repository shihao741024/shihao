//
//  WjjStaffTableViewCell.h
//  errand
//
//  Created by Apple on 15/12/13.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSInteger)type;

/** 姓名 */
@property (nonatomic, assign) UILabel      *nameLabel;
/** 电话号码 */
@property (nonatomic, assign) UILabel      *phoneNumLabel;
/** 联系人状态 */
@property (nonatomic, assign) UIButton     *stateBtn;

@property (nonatomic, strong) UIImageView     *iconImgView;

@property(nonatomic,copy) void (^callPhoneBlock)();

- (void)stateBtnClick:(UIButton *)btn;

@end