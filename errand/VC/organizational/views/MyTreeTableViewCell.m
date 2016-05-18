//
//  MyTreeTableViewCell.m
//  errand
//
//  Created by 徐祥 on 16/1/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MyTreeTableViewCell.h"

@implementation MyTreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(int)type {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if (type == 1) {
            
            // 创建个人 cell
            [self createCellForPerson];
        } else if(type == 0){
            
            // 创建部门 cell
            [self createCellForDepartment];
        }else if (type == 2){
            
            //创建可以选择的部门 cell
            [self createCellForSelectDepartment];
        }
        else {
           [self createCellForMyTree];
        }
    }
    return self;
}

// 部门 cell
- (void)createCellForDepartment {
    
    // 部门
    UILabel * departmentNameLabel = [[UILabel alloc] init];
//    departmentNameLabel.backgroundColor = [UIColor redColor];
    self.departmentNameLabel = departmentNameLabel;
    self.departmentNameLabel.numberOfLines = 0;
    [self addSubview:self.departmentNameLabel];
    
    // 箭头
    UIImageView * arrowImageView = [[UIImageView alloc] init];
//    arrowImageView.backgroundColor = [UIColor blueColor];
    arrowImageView.image = [UIImage imageNamed:@"tree_ec"];
    self.arrowImageView = arrowImageView;
    [self addSubview:self.arrowImageView];
    
    // 适配
    __weak UIView * superView = self;
    /*
    [self.departmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(25);
        make.top.equalTo(superView.mas_top).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(20);
        make.width.equalTo(10);
        make.height.equalTo(10);
    }];
     */
}

//创建可以选择的部门 cell
- (void)createCellForSelectDepartment{
    
    // 部门
    UILabel * departmentNameLabel = [[UILabel alloc] init];
    //    departmentNameLabel.backgroundColor = [UIColor redColor];
    self.departmentNameLabel = departmentNameLabel;
    self.departmentNameLabel.numberOfLines = 0;
    [self addSubview:self.departmentNameLabel];
    
    // 箭头
    UIImageView * arrowImageView = [[UIImageView alloc] init];
    //    arrowImageView.backgroundColor = [UIColor blueColor];
    arrowImageView.image = [UIImage imageNamed:@"tree_ec"];
    self.arrowImageView = arrowImageView;
    [self addSubview:self.arrowImageView];
    
    //选择按钮
    UIButton *selectButton = [[UIButton alloc]init];
    [selectButton setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
    _selectButton = selectButton;
    [self addSubview:_selectButton];
    [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 适配
    __weak UIView * superView = self;
    /*
    [self.departmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(40);
        make.top.equalTo(superView.mas_top).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(20);
        make.width.equalTo(10);
        make.height.equalTo(10);
    }];
    */
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(superView.mas_right).offset(-15);
        make.centerY.equalTo(superView);
        make.width.equalTo(superView.height);
        make.height.equalTo(superView.height);
        
    }];
    
}

- (void) createCellForMyTree{
    // 部门
    UILabel * departmentNameLabel = [[UILabel alloc] init];
    //    departmentNameLabel.backgroundColor = [UIColor redColor];
    self.departmentNameLabel = departmentNameLabel;
    self.departmentNameLabel.numberOfLines = 0;
    [self addSubview:self.departmentNameLabel];
    
    // 箭头
    UIImageView * arrowImageView = [[UIImageView alloc] init];
    //    arrowImageView.backgroundColor = [UIColor blueColor];
    arrowImageView.image = [UIImage imageNamed:@"tree_ec"];
    self.arrowImageView = arrowImageView;
    [self addSubview:self.arrowImageView];
    
    //选择按钮
    UIButton *selectButton = [[UIButton alloc]init];
    [selectButton setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
    _selectButton = selectButton;
    [self addSubview:_selectButton];
    [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 适配
    __weak UIView * superView = self;
    [self.departmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(40);
        make.top.equalTo(superView.mas_top).offset(10);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(10);
        make.top.equalTo(superView.mas_top).offset(20);
        make.width.equalTo(10);
        make.height.equalTo(10);
    }];

}

- (void)createCellForMyTreeWithModel:(Node *)node{
    
    if (node.depth != 0) {
        // 适配
        __weak UIView * superView = self;
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(superView.mas_right).offset(-15);
            make.centerY.equalTo(superView);
            make.width.equalTo(superView.height);
            make.height.equalTo(superView.height);
            
        }];
    }
}
// 个人 cell
- (void)createCellForPerson {
    
    // 姓名
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    
    // 电话
    UILabel * phoneNumLabel = [[UILabel alloc] init];
//    phoneNumLabel.font = [UIFont systemFontOfSize:15];
    phoneNumLabel.textColor = [UIColor lightGrayColor];
    phoneNumLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneNumLabel = phoneNumLabel;
    [self addSubview:self.phoneNumLabel];
    
    // 电话按钮
    UIButton * stateBtn = [[UIButton alloc] init];
    [stateBtn setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    stateBtn.layer.cornerRadius = 15;
    stateBtn.layer.masksToBounds = YES;
    [stateBtn addTarget:self action:@selector(stateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.stateBtn = stateBtn;
    [self addSubview:self.stateBtn];
    
    // 适配
    __weak UIView * superView = self;
    // 姓名适配
    /*
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(25+44+10);
        make.top.equalTo(superView.mas_top).offset(10);
        make.right.equalTo(self.stateBtn.mas_left).offset(0);
        make.bottom.equalTo(self.phoneNumLabel.mas_top).offset(0);
        make.height.equalTo(30);
    }];
    
    // 电话号码适配
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_left).offset(25+44+10);
        make.right.equalTo(self.stateBtn.mas_left).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(-10);
    }];
    
    // 电话按钮适配
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(superView.mas_top).offset(20);
        make.right.equalTo(superView.mas_right).offset(-20);
        make.bottom.equalTo(superView.mas_bottom).offset(-20);
        make.width.equalTo(30);
    }];
    */
    
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, (70-44)/2.0, 44, 44)];
    //    _iconImgView.backgroundColor = [UIColor cyanColor];
    [self addSubview:_iconImgView];
    _iconImgView.layer.cornerRadius = 22;
    _iconImgView.clipsToBounds = YES;
    _iconImgView.image = [UIImage imageNamed:@"headerImg_default"];
    
}

// 电话按钮点击方法
- (void)stateBtnClick {
    
    // 打电话回调
    self.callPhoneBlock();
}

- (void)selectButtonClick{
    
    self.departmentSelectClick();
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)resetButtonImage
{
    if (_searchVisitRecord) {
        self.stateBtn.userInteractionEnabled = NO;
        [self.stateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.stateBtn setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
        [self.stateBtn setImage:[UIImage imageNamed:@"itemchoice_checked"] forState:UIControlStateSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (_searchVisitRecord) {
        
        self.stateBtn.selected = selected;
    }
    // Configure the view for the selected state
}

@end
