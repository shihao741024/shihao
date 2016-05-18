//
//  TravelSituationTableViewCell.h
//  errand
//
//  Created by pro on 16/4/14.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelSituationTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *topLinkImgView;
@property (nonatomic, strong) UIImageView *linkImgView;
@property (nonatomic, strong) UIImageView *statusImgView;

- (void)fillData:(NSDictionary *)dic beforeDic:(NSDictionary *)beforeDic;
- (void)hideLinkImgView:(BOOL)hide;

@end
