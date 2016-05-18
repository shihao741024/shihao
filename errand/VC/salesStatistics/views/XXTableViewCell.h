//
//  XXTableViewCell.h
//  test
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 xuxiang. All rights reserved.
//

/**
 *  注 ：使用此类时，将所需控件搭载在 _subView 上即可
 */

#import <UIKit/UIKit.h>
#import "SalesStatisticsModel.h"
@protocol XXTableViewDelegate <NSObject>

- (void)clickCellWithIndex:(NSInteger)index;
- (void)isScrollViewInCellMove:(BOOL)flag andIndex:(NSInteger)index;

@end

@interface XXTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, weak) id <XXTableViewDelegate>delegateOfXXTableView;

// 为0 怎没有偏移，为1则已偏移
@property bool flag;

@property(nonatomic, retain)UIScrollView *bgScrollView;
@property(nonatomic, retain)UILabel *stateLabel;
@property(nonatomic, retain)UILabel *startDate;
@property(nonatomic, retain)UILabel *taskNameLabel;
@property(nonatomic, retain)UILabel *phoneNumber;
@property(nonatomic, retain)UILabel *receiveName;
@property(nonatomic, retain)UILabel *endDate;
@property(nonatomic, retain)UILabel *remarkLabel;
@property(nonatomic, retain)UILabel *phoneImageLabel;
@property(nonatomic, copy)NSString *imageName;
@property(nonatomic, strong)NSNumber *salesStatisticsID;

/**
 *  为了方便找到对应的cell，在初始化方法中加入tag值
 *
 *  @param style           style description
 *  @param reuseIdentifier reuseIdentifier description
 *  @param tag             cell 的tag值
 *
 *  @return 返回带有tag值得cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTag:(NSInteger)tag;

-(void)setSalesStatisticsModel:(SalesStatisticsModel *)model andType:(int)type;
// 两个按钮的点击方法
- (void)deleteBtnClick;
- (void)editBtnClick;

@property (nonatomic, copy)void (^deleteBtnClickBlock)(NSNumber* salesStatisticsID, XXTableViewCell *);

@property (nonatomic, copy)void (^editBtnClickBlock)(NSNumber* salesStatisticsID, XXTableViewCell *);

@end
