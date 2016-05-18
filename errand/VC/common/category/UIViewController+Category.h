//
//  UIViewController+Category.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface UIViewController(Category)<MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>

-(void)hideNodataLabel:(UIView*)v;  //隐藏没有数据的提示框
-(void)hideNodataLabel;

-(void)showNoDataInfo:(UIView*)v title:(NSString*)title;//展示没有数据的提示框
-(void)showNoDataInfo:(UIView*)v ;
-(void)showNoDataInfo;

//清除不需要的行
-(void)setExtraCellLineHidden: (UITableView *)tableView;

-(void)showInfica;
-(void)hideInfica;

//初次加载时使用
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;
- (void)showHint;
- (void)showHintInView:(UIView*)v;
- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

/** 拨打电话 */
-(void)openCall:(NSString*)phone;

/** 发短信 */
-(void)showMessageView:(NSArray *)phones;

//获得下拉视图
- (UIView *)getPopUpView:(UIView*)popUpView;

//获取第一个字母
- (NSString *)firstCharactor:(NSString *)aString;

//改变搜索栏的颜色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

//导航栏上的搜索和加号图标
- (void)createRightItems;

//根据日期获取周几
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

//导航栏上的编辑和删除图标
-(void)createMissionRightItems;

//根据日期获取是一周的第几天
- (NSInteger)orderDayFromDate:(NSDate*)inputDate;

/**
 *  获取用户的id
 *
 *  @return id
 */

- (NSNumber*)getUserID;

@end
