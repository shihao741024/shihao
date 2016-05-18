//
//  MyTreeTableViewCell.h
//  errand
//
//  Created by 徐祥 on 16/1/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
@interface MyTreeTableViewCell : UITableViewCell

/** 姓名 */
@property (nonatomic, assign) UILabel      *nameLabel;
/** 电话号码 */
@property (nonatomic, assign) UILabel      *phoneNumLabel;
/** 联系人状态 */
@property (nonatomic, assign) UIButton     *stateBtn;

@property (nonatomic ,assign)  UILabel      *departmentNameLabel;

@property (nonatomic, assign) UIImageView  * arrowImageView;

@property (nonatomic, strong) UIImageView  * iconImgView;

@property (nonatomic, assign) UIButton *selectButton;

@property(nonatomic,copy) void (^callPhoneBlock)();

@property (nonatomic, assign) BOOL searchVisitRecord;

- (void)resetButtonImage;

/**
 *  可创建两种cell， type 为 0，创建部门 cell；type 为 1， 创建个人 cell
 *
 *  @param style           style description
 *  @param reuseIdentifier reuseIdentifier description
 *  @param type            type description
 *
 *  @return return value description
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(int)type;

@property (nonatomic, copy)void (^departmentSelectClick)();

- (void)createCellForMyTreeWithModel:(Node *)node;

@end
