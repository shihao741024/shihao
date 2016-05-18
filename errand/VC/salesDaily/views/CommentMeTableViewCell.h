//
//  CommentMeTableViewCell.h
//  errand
//
//  Created by gravel on 16/3/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentMeModel.h"
@interface CommentMeTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *baseContentLabel;
@property (nonatomic, strong)UILabel *commentLabel;
@property (nonatomic, strong)UILabel *bottomLabel;
- (void)setCommentMeModel:(CommentMeModel *)model;

@end
