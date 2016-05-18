//
//  HuDongSegmentedViewController.m
//  aiyuedong
//
//  Created by gravel on 15/9/26.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "HuDongSegmentedViewController.h"
#import "MyAdapter.h"

@interface HuDongSegmentedViewController ()

@end

@implementation HuDongSegmentedViewController
@synthesize navHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    segHeight=40;
    if(!navHeight){
        navHeight=self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    }else if(navHeight==-1){
        navHeight=0;
    }
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"我的关注",@"我的粉丝",@"赞我",@"最近来访"]];
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setFrame:CGRectMake(0,SCREEN_HEIGHT - segHeight+2,SCREEN_WIDTH,segHeight+2)];
        _segmentedControl.selectionIndicatorHeight = 1.0f;
        _segmentedControl.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        _segmentedControl.textColor = [UIColor blackColor];
        _segmentedControl.selectedTextColor = COMMON_LIGHT_COLOR;
        [_segmentedControl setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:14.0]];
        _segmentedControl.selectionIndicatorColor = COMMON_LIGHT_COLOR;
        _segmentedControl.selectionIndicatorHeight=1.5;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.tag = 10;
        _segmentedControl.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
        [self.view addSubview:_segmentedControl];
    } else {
        //  [_segmentedControl removeAllSegments];
    }
    [_segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles index:(int)index
{
    //    if ([_segmentedControl numberOfSegments] > 0) {
    //        return;
    //    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:titles[i]];
    }
     [_segmentedControl setSectionTitles:titles];
    [_segmentedControl setSelectedSegmentIndex:index];
    self.selectedViewControllerIndex = index;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    //    if ([_segmentedControl numberOfSegments] > 0) {
    //        return;
    //    }
    for (int i = 0; i < [viewControllers count]; i++) {
        [self pushViewController:viewControllers[i] title:[viewControllers[i] title]];
    }
    [_segmentedControl setSelectedSegmentIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController title:viewController.title];
}
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    // [_segmentedControl insertSegmentWithTitle:title atIndex:_segmentedControl.numberOfSegments animated:NO];
    //   [viewController.view setFrame:CGRectMake(0, 400, SCREEN_WIDTH, 100)];
    [self addChildViewController:viewController];
    [_segmentedControl sizeToFit];
}

- (void)segmentedControlSelected:(id)sender
{
     self.selectedViewControllerIndex = _segmentedControl.selectedSegmentIndex;
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
}

- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(selectedVCIndex:)]) {
        [self.delegate selectedVCIndex:index];
    }
    _pageHeight=SCREEN_HEIGHT-navHeight-segHeight-BOTTOM_HEIGHT;
    if (!_selectedViewController) {
        _selectedViewController = self.childViewControllers[index];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            CGFloat deltaTop = 20.0f;
            if (self.navigationController && !self.navigationController.navigationBar.translucent) {
                deltaTop = self.navigationController.navigationBar.frame.size.height;
            }
            CGRect frame = self.view.frame;
            [_selectedViewController view].frame = CGRectMake(frame.origin.x, frame.origin.y - deltaTop, frame.size.width, frame.size.height);
            //            [[_selectedViewController view] sizeToFit];
        } else {
            [_selectedViewController view].frame = CGRectMake(0, navHeight, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-segHeight);//self.view.frame;
        }
        [self.view addSubview:[_selectedViewController view]];
        [_selectedViewController didMoveToParentViewController:self];
    } else {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            [self.childViewControllers[index] view].frame = self.view.frame;
        }else{
            [self.childViewControllers[index] view].frame  = CGRectMake(0, navHeight, SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-segHeight);//self.view.frame;
            
        }
        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            _selectedViewController = self.childViewControllers[index];
            _selectedViewControllerIndex = index;
        }];
    }
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
