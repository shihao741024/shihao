//
//  WorkTrailViewController.m
//  errand
//
//  Created by pro on 16/4/6.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "WorkTrailViewController.h"
#import "EveryLoctionViewController.h"
#import "LoctionLayoutViewController.h"
#import "LoctionConclusionViewController.h"
#import "WorkTrailTopSelectView.h"

@interface WorkTrailViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    UIPageViewController *_pageCtrl;
    
    NSMutableArray *_ctrlArray;
//    NSMutableArray *_btnArray;
//    NSMutableArray *_linViewArray;
    
    EveryLoctionViewController *_everyLoctionCtrl;
    LoctionLayoutViewController *_loctionLayoutCtrl;
    LoctionConclusionViewController *_loctionConclusionCtrl;
    
    WorkTrailTopSelectView *_topSelectView;
}
@end

@implementation WorkTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    
    [self dataConfig];
    [self uiConfig];
}

- (void)dataConfig
{
//    _btnArray = [[NSMutableArray alloc] init];
    _ctrlArray = [[NSMutableArray alloc] init];
//    _linViewArray = [[NSMutableArray alloc] init];
}

- (void)createRightItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)RecordsearchClick
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)uiConfig
{
    _pageCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageCtrl.delegate = self;
    _pageCtrl.dataSource = self;
    [self addChildViewController:_pageCtrl];
    _pageCtrl.view.frame = CGRectMake(0, 64+42, kWidth, kHeight-64-42);
    [self.view addSubview:_pageCtrl.view];
    
    _everyLoctionCtrl = [[EveryLoctionViewController alloc] init];
    _loctionLayoutCtrl = [[LoctionLayoutViewController alloc] init];
    _loctionConclusionCtrl = [[LoctionConclusionViewController alloc] init];
    _ctrlArray = [NSMutableArray arrayWithArray:@[_everyLoctionCtrl, _loctionLayoutCtrl, _loctionConclusionCtrl]];
    
    [_pageCtrl setViewControllers:@[_ctrlArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
    
    _topSelectView = [[WorkTrailTopSelectView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 42)];
    [self.view addSubview:_topSelectView];
    [_topSelectView selectIndexAction:^(NSInteger index) {
        [self changeSelectPageCtrlIndex:index];
    }];
}

- (void)changeSelectPageCtrlIndex:(NSInteger)index
{
    id currentCtrl = _pageCtrl.viewControllers[0];
    NSInteger ctrlIndex = [_ctrlArray indexOfObject:currentCtrl];
    
    if (index-100 >= ctrlIndex) {
        [_pageCtrl setViewControllers:@[_ctrlArray[index-100]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    }
    else
    {
        [_pageCtrl setViewControllers:@[_ctrlArray[index-100]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        }];
    }
}

- (UIViewController *)getCurrentCtrl:(UIViewController *)viewCtrl isNext:(BOOL)isNext
{
    
    NSInteger index = [_ctrlArray indexOfObject:viewCtrl];
    if (isNext == YES) {
        index = index+1;
    }
    else
    {
        index = index-1;
    }
    id getCtrl = nil;
    if (index <0 || index>= _ctrlArray.count) {
        getCtrl = nil;
    }
    else
    {
        getCtrl = _ctrlArray[index];
    }
    return getCtrl;
    
}

#pragma mark UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    id ctrl = [self getCurrentCtrl:viewController isNext:NO];
    return ctrl;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    id ctrl = [self getCurrentCtrl:viewController isNext:YES];
    return ctrl;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    id currentCtrl = _pageCtrl.viewControllers[0];
    NSInteger index = [_ctrlArray indexOfObject:currentCtrl];
    
    [_topSelectView setSelectButton:index+100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
