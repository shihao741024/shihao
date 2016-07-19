//
//  CreateVisitInfoViewController.m
//  errand
//
//  Created by pro on 16/4/7.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CreateVisitInfoViewController.h"
#import "FillVisitInfoViewController.h"

@interface CreateVisitInfoViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    UIPageViewController *_pageCtrl;
    NSMutableArray *_ctrlArray;
    NSMutableArray *_btnArray;
    
    FillVisitInfoViewController *_planCtrl;
    FillVisitInfoViewController *_tempCtrl;
}

@property (nonatomic ,copy) void(^uploadFinishRefreshCB)(NSString *dateStr);

@end

@implementation CreateVisitInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackButton];
    self.title = @"新建计划";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self dataConfig];
    
    [self uiConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)uiConfig
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"commit", @"commit") style:UIBarButtonItemStylePlain target:self action:@selector(submitClick)];
    
    _pageCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageCtrl.delegate = self;
    _pageCtrl.dataSource = self;
    [self addChildViewController:_pageCtrl];
    _pageCtrl.view.frame = CGRectMake(0, 64, kWidth, kHeight-64-44);
    [self.view addSubview:_pageCtrl.view];
    
    _planCtrl = [[FillVisitInfoViewController alloc] init];
    _planCtrl.type = 0;
    [_planCtrl uploadDataFinishAction:^(NSString *dateStr){
        _uploadFinishRefreshCB(dateStr);
    }];
    
    _tempCtrl = [[FillVisitInfoViewController alloc] init];
    _tempCtrl.type = 1;
    [_tempCtrl uploadDataFinishAction:^(NSString *dateStr){
        _uploadFinishRefreshCB(dateStr);
    }];
    
    _ctrlArray = [NSMutableArray arrayWithArray:@[_planCtrl, _tempCtrl]];
    
    [_pageCtrl setViewControllers:@[_ctrlArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
    
    [self addToolBarButton];
}

- (void)submitClick
{
    UIButton *button = _btnArray[0];
    if (button.selected == YES) {
        [_planCtrl uploadData];
    }else {
        [_tempCtrl uploadData];
    }
}

- (void)addToolBarButton
{
    CGFloat btnW = kWidth/2.0;
    NSArray *btnTitleArray = @[@"新建计划", @"新建临时"];
    for (NSInteger i=0; i<btnTitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+ i;
        button.frame = CGRectMake(i*btnW, 0, btnW, 42);
        button.titleLabel.font = GDBFont(14);
        [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.toolbar addSubview:button];
        
        if (i == 0) {
            button.selected = YES;
        }
        [_btnArray addObject:button];
    }
}

- (void)headButtonClick:(UIButton *)button
{
    for (UIButton *btn in _btnArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    self.title = [button titleForState:UIControlStateNormal];
    
    id currentCtrl = _pageCtrl.viewControllers[0];
    NSInteger index = [_ctrlArray indexOfObject:currentCtrl];
    
    if (button.tag-100 >= index) {
        [_pageCtrl setViewControllers:@[_ctrlArray[button.tag-100]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    }
    else
    {
        [_pageCtrl setViewControllers:@[_ctrlArray[button.tag-100]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        }];
    }
}

- (void)dataConfig
{
    _btnArray = [[NSMutableArray alloc] init];
    _ctrlArray = [[NSMutableArray alloc] init];
    //    _linViewArray = [[NSMutableArray alloc] init];
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
    if (index < 0 || index >= _ctrlArray.count) {
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
    
    for (UIButton *button in _btnArray) {
        if (button.tag == index + 100) {
            button.selected = YES;
            self.title = [button titleForState:UIControlStateNormal];
        }else {
            button.selected = NO;
        }
    }
}

- (void)uploadFinishRefreshAction:(void(^)(NSString *dateStr))action
{
    _uploadFinishRefreshCB = action;
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
