//
//  CustomerVisitViewController.m
//  errand
//
//  Created by gravel on 15/12/19.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CustomerVisitViewController.h"
#import "CustomerVisitChildViewController.h"
#import "VisitManagerViewController.h"
#import "CustomerVisitBll.h"
#import "MMAlertView.h"
#import "CreateVisitInfoViewController.h"
#import "VisitRecordViewController.h"
#import "VisitRecordSearchViewController.h"

@interface CustomerVisitViewController ()

@end

@implementation CustomerVisitViewController{
    MySegmentViewController * pager;
    CustomerVisitChildViewController *view;
    VisitRecordViewController *view1;
    
    UIView *bgView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [self addBackButton];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self createRightItems];
    pager = (MySegmentViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
    view=[[CustomerVisitChildViewController alloc]init];
    view.type=0;
    view.title=NSLocalizedString(@"planVisit", @"planVisit") ;
    [view myVisitWillAppear:^{
        [self changeItemAndTitle:YES];
    }];
    
    view1=[[VisitRecordViewController alloc]init];
    view1.title=NSLocalizedString(@"temporaryVisit", @"temporaryVisit") ;
    [view1 visitRecordWillAppear:^{
        [self changeItemAndTitle:NO];
    }];
    
    [pages addObject:view];
    [pages addObject:view1];
    [pager setPages:pages];
    
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    
    [self createCountIcon];
}

- (NSString *)viewControllerTitle
{
    return @"拜访";
}

- (void)changeItemAndTitle:(BOOL)isMyVisit
{
    if (isMyVisit) {
        self.title = @"我的拜访";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    }else {
        self.title = @"拜访记录";
        [self createSearchItem];
    }
    
}

- (void)createSearchItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(RecordsearchClick)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)RecordsearchClick
{
    VisitRecordSearchViewController *visitRecordSearchCtrl = [[VisitRecordSearchViewController alloc] init];
    [self.navigationController pushViewController:visitRecordSearchCtrl animated:YES];
    visitRecordSearchCtrl.saveDic = view1.saveDic;
    
    [visitRecordSearchCtrl backSearchParameterAction:^(NSDictionary *saveDic) {
        view1.saveDic = saveDic;
        [view1 refreshData];
    }];
    
}

- (void)createRightItems{
    UIButton * rightBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 65, 30)];
    [rightBtnOne setTitle:@"拜访管理" forState:UIControlStateNormal];
    [rightBtnOne setTitleColor:[UIColor colorWithRed:0.278 green:0.616 blue:0.863 alpha:1.000] forState:UIControlStateNormal];
    [rightBtnOne.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtnOne addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rightBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(70, 5, 30, 30)];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"add_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"add_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [rightBtnTwo addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    [bgView addSubview:rightBtnOne];
    [bgView addSubview:rightBtnTwo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    
}

/**
 *  建立拜访管理按钮
 */
- (void)createCountIcon{
    AmotButton *countButton = [[AmotButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 60, SCREEN_HEIGHT - 49 - 64, 60, 60)];
    [countButton setImage:[UIImage imageNamed:@"toggle"] forState:UIControlStateNormal];
    [countButton setImage:[UIImage imageNamed:@"toggle"] forState:UIControlStateSelected];
    [self.view addSubview:countButton];
    [countButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addClick{
    
    CreateVisitInfoViewController *createVisitCtrl = [[CreateVisitInfoViewController alloc] init];
    [self.navigationController pushViewController:createVisitCtrl animated:YES];
    [createVisitCtrl uploadFinishRefreshAction:^(NSString *dateStr){
        view.dateStr = dateStr;
        [view refreshData];
        [view1 refreshData];
    }];
    
}

- (void)searchClick{
    VisitManagerViewController *visitManagerVC = [[VisitManagerViewController alloc]init];
    [self.navigationController pushViewController:visitManagerVC animated:YES];
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
