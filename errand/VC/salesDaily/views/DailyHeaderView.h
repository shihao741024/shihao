//
//  DailyHeaderView.h
//  errand
//
//  Created by gravel on 16/3/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesDailyModel.h"
#import "SDBrowserImageView.h"
#import "SDPhotoBrowser.h"
#import "SDPhotoBrowserConfig.h"

@interface DailyHeaderView : UIView<UICollectionViewDelegate,UICollectionViewDataSource, SDPhotoBrowserDelegate, UITextViewDelegate>

@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *kindNameLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *phoneModelLabel;
@property (nonatomic, strong)UIImageView *addressImgView;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UIImageView *writeImgView;
@property (nonatomic, strong)UILabel *acountLabel;
@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, strong)UIButton *replyImgBtn;

@property (nonatomic, strong)UICollectionView *collectionView;


@property (nonatomic, strong)UITextView *contentTextView;

- (void)setSalesDailyModel:(SalesDailyModel*)model;

@property (nonatomic ,copy) void (^DailydeleteBtnClickBlock)();

@property (nonatomic ,copy) void (^replyImgBtnClickBlock)();


@property (nonatomic ,copy) void (^visitDetailClick)(NSString *idStr);

@end
