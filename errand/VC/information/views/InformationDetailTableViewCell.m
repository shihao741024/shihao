//
//  InformationDetailTableViewCell.m
//  errand
//
//  Created by wjjxx on 16/3/22.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "InformationDetailTableViewCell.h"

@implementation InformationDetailTableViewCell{
    InformationModel *_informationModel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCell];
    }
    return self;
}

- (void)createCell{
    _dateLabel = [self createLabelWithFont:11 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentCenter];
    _headImgView = [[UIImageView alloc]init];
    [self addSubview:_headImgView];
    _contentLabel = [self createLabelWithFont:15 andTextColor:[UIColor redColor] andTextAlignment:NSTextAlignmentLeft];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _selectedBtn = [[UIButton alloc]init];
//    _selectedBtn.frame = CGRectMake(self.frame.size.width - 35, 20, 30, 30);
    [self addSubview:_selectedBtn];
//    [_selectedBtn setBackgroundColor:[UIColor redColor]];
    [_selectedBtn addTarget:self action:@selector(selectedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(SCREEN_WIDTH);
        make.height.equalTo(@20);
    }];
    
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(8);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    _headImgView.layer.cornerRadius = 22;
    _headImgView.clipsToBounds = YES;
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLabel.mas_bottom).offset(0);
        make.left.equalTo(_headImgView.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-44);
        make.height.equalTo(54);
    }];
    _contentLabel.layer.cornerRadius = 5;
    _contentLabel.clipsToBounds = YES;
}

- (void)setInformationModel:(InformationModel *)model isExpand:(BOOL)isExpand{
    _informationModel = model;
    _dateLabel.text = model.createDate;
    _headImgView.image = [UIImage imageNamed:@"headerImg_default"];
    _contentLabel.text = model.content;
    _contentLabel.backgroundColor = [UIColor whiteColor];
    
//     _selectedBtn.frame = CGRectMake(SCREEN_WIDTH - 35+ 15, 20 +15,0, 0);
    if (isExpand == YES) {
        if (model.isEdit == YES) {
            
            [_selectedBtn setImage:[UIImage imageNamed:@"itemchoice_checked"] forState:UIControlStateNormal];
            
        }else{
            [_selectedBtn setImage:[UIImage imageNamed:@"itemchoice_unchecked"] forState:UIControlStateNormal];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
             _selectedBtn.frame = CGRectMake(SCREEN_WIDTH - 35, 20, 30, 30);
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _selectedBtn.frame = CGRectMake(self.frame.size.width
                                            - 35+ 15, 20 +15,0, 0);
        }];
       
    }
}
- (void)selectedBtnClick{
     self.informationSelectClick();
    
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [self addSubview:label];
    return label;
}
- (void)awakeFromNib {
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
