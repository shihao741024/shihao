//
//  MySegmentViewController.h
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@protocol MySegmentedPageViewControllerDelegate;

@interface MySegmentViewController:UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) HMSegmentedControl *pageControl;
@property (strong, nonatomic) UIView *contentContainer;

@property (strong, nonatomic)NSMutableArray *pages;
@property(assign,nonatomic)int startIndex;
@property(assign,nonatomic)float bottom_ju;
- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;
- (UIViewController *)selectedController;
- (NSInteger)selectedIndex;
- (void)updateTitleLabels;


- (NSArray *)getTitleLabelsWithArray:(NSArray *)array;
@end

@protocol MySegmentedPageViewControllerDelegate <NSObject>

- (NSString *)viewControllerTitle;

@end