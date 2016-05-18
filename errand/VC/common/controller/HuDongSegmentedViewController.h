//
//  HuDongSegmentedViewController.h
//  aiyuedong
//
//  Created by gravel on 15/9/26.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@protocol HuDongSegmentedViewControllerDelegate <NSObject>

- (void)selectedVCIndex:(NSInteger)index;

@end

@interface HuDongSegmentedViewController : UIViewController
{
    float segHeight;
}
@property(nonatomic, assign) UIViewController *selectedViewController;
@property(nonatomic, strong) IBOutlet HMSegmentedControl *segmentedControl;
@property(nonatomic, assign) NSInteger selectedViewControllerIndex;
- (void)setViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles index:(int)index;

- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title;
@property(nonatomic, assign) float pageHeight;
@property(nonatomic,assign)float navHeight;

@property(nonatomic,weak) id <HuDongSegmentedViewControllerDelegate>delegate;

@end
