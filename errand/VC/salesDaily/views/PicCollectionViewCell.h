//
//  PicCollectionViewCell.h
//  errand
//
//  Created by gravel on 16/2/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong)UIImageView *picImageView;

@property (nonatomic, strong)UIButton *deleteBtn;

@property(nonatomic, copy) void (^deleteBtnClickBlock)();

@property(nonatomic, copy) void (^tapClickBlock)();

@end
