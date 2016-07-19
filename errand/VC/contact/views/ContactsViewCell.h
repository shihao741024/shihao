//
//  ContactsViewCell.h
//  errand
//
//  Created by 医路同行Mac1 on 16/6/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface ContactsViewCell : UITableViewCell
- (void)fillData:(ContactModel *)model;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *addressLable;
@property (nonatomic,strong) UIButton *selectBtn;
- (void)hideAllView:(BOOL)hide;

- (void)selectButtonAction:(void(^)(ContactsViewCell *selectCell))action;
- (void)fillData:(ContactModel *)model hideSelectBtn:(BOOL)hideSelectBtn;

@end
