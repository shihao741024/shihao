//
//  JurisdictionTableViewCell.m
//  errand
//
//  Created by wjjxx on 16/2/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "JurisdictionTableViewCell.h"

@implementation JurisdictionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void)createCell{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-26-20, ( self.frame.size.height - 20)/2, 20,20)];
    _selectImage = view;
    [self addSubview:_selectImage];
   
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, self.frame.size.height)];
    contentLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel = contentLabel;
    
    [self addSubview:self.titleLabel];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
