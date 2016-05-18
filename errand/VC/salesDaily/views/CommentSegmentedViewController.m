//
//  THSegmentedPager.m
//  THSegmentedPagerExample
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CommentSegmentedViewController.h"
#import "THSegmentedPageViewControllerDelegate.h"
#import "RDVTabBarController.h"
@interface CommentSegmentedViewController ()
@property (strong, nonatomic)UIPageViewController *pageViewController;
@end

@implementation CommentSegmentedViewController

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;

- ( void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   }

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
    // Init PageViewController
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageControl=[[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, segHeight)];
    
//    float bottomHeight= [self rdv_tabBarController].tabBarHidden?0:BOTTOM_HEIGHT;
    float bottomHeight= 49;
    self.contentContainer=[[UIView alloc] initWithFrame:CGRectMake(0, self.pageControl.height+self.pageControl.y, SCREEN_WIDTH, SCREEN_HEIGHT-(self.pageControl.height+self.pageControl.y+bottomHeight+_bottom_ju))];
//    self.contentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 153)];
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
    _pageControl.textColor = [UIColor blackColor];
    _pageControl.selectedTextColor = COMMON_LIGHT_COLOR;
    [_pageControl setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14.0]];
    _pageControl.selectionIndicatorColor = COMMON_LIGHT_COLOR;
    _pageControl.selectionIndicatorHeight=1.5;
    _pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
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
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle",@"")];
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
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

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

@end
