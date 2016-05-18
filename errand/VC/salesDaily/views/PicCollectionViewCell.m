//
//  PicCollectionViewCell.m
//  errand
//
//  Created by gravel on 16/2/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "PicCollectionViewCell.h"

@implementation PicCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
         [self createCell];
      
    }
    return self;
}

-(void)createCell{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.picImageView = imageView;
    self.picImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.picImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.picImageView addGestureRecognizer:tap];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.deleteBtn = deleteBtn;
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapClick{
    self.tapClickBlock();
}
- (void)deleteBtnClick{
    self.deleteBtnClickBlock();
}

@end
