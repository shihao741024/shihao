//
//  THSegmentedPager.h
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface CommentSegmentedViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) HMSegmentedControl *pageControl;
@property (strong, nonatomic) UIView *contentContainer;

@property (strong, nonatomic)NSMutableArray *pages;
@property(assign,nonatomic)int startIndex;
@property(assign,nonatomic)float bottom_ju;
- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;

- (void)updateTitleLabels;

@end
