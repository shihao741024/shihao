//
//  CommentPicCollectionViewCell.m
//  errand
//
//  Created by gravel on 16/3/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CommentPicCollectionViewCell.h"

@implementation CommentPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
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
}

@end
