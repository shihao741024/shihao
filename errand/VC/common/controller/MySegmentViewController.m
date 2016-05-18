//
//  MySegmentViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MySegmentViewController.h"
#import "RDVTabBarController.h"

@interface MySegmentViewController ()
@property (strong, nonatomic)UIPageViewController *pageViewController;
@end

@implementation MySegmentViewController
@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;

- (NSMutableArray *)pages
{
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

- (void)viewDidLoad
{
    
    float segHeight=40;
    float navHeight=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    RDVTabBarController *t=[self rdv_tabBarController];
    if(!t){
        navHeight=0;
    }
    [super viewDidLoad];
//    
//    
    // Init PageViewController
    float bottomHeight= [self rdv_tabBarController].tabBarHidden?0:BOTTOM_HEIGHT;
    
    self.pageControl=[[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomHeight-segHeight, SCREEN_WIDTH, segHeight)];
    
    
    self.contentContainer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(self.pageControl.height+bottomHeight+_bottom_ju))];
    
    [self.view addSubview:_contentContainer];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    _pageControl.selectionIndicatorHeight = 1.0f;
    _pageControl.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    _pageControl.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    _pageControl.textColor = [UIColor blackColor];
    _pageControl.selectedTextColor = COMMON_LIGHT_COLOR;
    [_pageControl setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14.0]];
    _pageControl.selectionIndicatorColor = COMMON_LIGHT_COLOR;
    _pageControl.selectionIndicatorHeight=1.5;
    _pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _pageControl.tag = 10;
    
    if ([self.pages count]>0) {
        int ids=self.startIndex;
        [self.pageViewController setViewControllers:@[self.pages[ids]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
        double delayInSeconds =0.001;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.pageControl setSelectedSegmentIndex:ids animated:YES];
        });
    }
    [self.view addSubview:_pageControl];
    [self updateTitleLabels];
    //
    //    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //        self.pageControl.selectedTextColor = [UIColor whiteColor];
    //    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)updateTitleLabels
{
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels
{
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(MySegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<MySegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<MySegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"无",@"")];
        }
    }
    return [titles copy];
}

- (NSArray *)getTitleLabelsWithArray:(NSArray *)array {
    
    NSMutableArray *titles = [NSMutableArray arrayWithArray:array];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(MySegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<MySegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<MySegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"无",@"")];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    [self selectedIndex];
//    wjj edit
//    if ([self.pageControl selectedSegmentIndex]) {
//                [self createTijiaoItem];
//    }else{
//        [self createGuanliItem];
//
//    }
    return self.pages[[self.pageControl selectedSegmentIndex]];
    
}
- (NSInteger)selectedIndex{
    return [self.pageControl selectedSegmentIndex];
}
//wjj add
//- (void)createGuanliItem{
//    
//}
//- (void)createTijiaoItem{
//    
//}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
      
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
  
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    //wjj edit
//    if ([self.pageControl selectedSegmentIndex]) {
//        [self createGuanliItem];
//       
//    }else{
//         [self createTijiaoItem];
//        
//    }

//      NSLog(@"pageindex    %d",[self.pageControl selectedSegmentIndex]);
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
    
    
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
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
