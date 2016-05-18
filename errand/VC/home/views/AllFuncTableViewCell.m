//
//  AllFuncTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AllFuncTableViewCell.h"

@implementation AllFuncTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void)createCell{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-26-20, 20, 20,20)];
    _selectImage = view;
    [self.contentView addSubview:_selectImage];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(26, 10, 40, 40)];
    self.titleImage = imageView;
    [self.contentView addSubview:self.titleImage];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:  CGRectMake(26+40+10, 20, 200, 20)];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = COMMON_FONT_BLACK_COLOR;
    self.titleLabel = contentLabel;
    
    [self.contentView addSubview:self.titleLabel];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
