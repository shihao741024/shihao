//
//  SalesStatisticsViewController.m
//  errand
//
//  Created by gravel on 15/12/19.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "SalesStatisticsViewController.h"
#import "SalesStatisticsChildViewController.h"
#import "StatisticsEdittingVC.h"
#import "SalesStatisticsSearchViewController.h"

@interface SalesStatisticsViewController ()//<HuDongSegmentedViewControllerDelegate>
@end

@implementation SalesStatisticsViewController{
    MySegmentViewController *pager;
    SalesStatisticsChildViewController *view1;
    SalesStatisticsChildViewController *view2;
    SalesStatisticsChildViewController *view3;
//    NSInteger selectedIndex;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    
   
    self.title = NSLocalizedString(@"salesStatistics", @"salesStatistics");
    [self addBackButton];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self createRightItems];
    
    pager = (MySegmentViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
    view1=[[SalesStatisticsChildViewController alloc]init];
    view1.type= 0;
    view1.title=[NSString stringWithFormat:@"%@", NSLocalizedString(@"salesReport", @"salesReport")];
    
    view2=[[SalesStatisticsChildViewController alloc]init];
    view2.type=1;
    view2.title=[NSString stringWithFormat:@"%@", NSLocalizedString(@"pureSalesReport", @"pureSalesReport")];
    
    view3 = [[SalesStatisticsChildViewController alloc]init];
    view3.type = 2;
    view3.title = NSLocalizedString(@"competeReport", @"competeReport");
    
    [pages addObject:view1];
    [pages addObject:view2];
    [pages addObject:view3];
    [pager setPages:pages];

    [super viewDidLoad];
}

- (void)addClick{
    StatisticsEdittingVC *taskEditVC = [[StatisticsEdittingVC alloc] init];
   
    NSArray *dataArray;
    // //0 销售上报  1 传销上报  2 竞品上报
    if ((self.selectedIndex == 0)||(self.selectedIndex == 2)) {
        if (self.selectedIndex == 0) {
             taskEditVC.title=NSLocalizedString(@"salesReport", @"salesReport");
        }else{
             taskEditVC.title=NSLocalizedString(@"competeReport", @"competeReport");
        }
        
         dataArray = @[[NSString stringWithFormat:@"%@:", NSLocalizedString(@"productName", @"productName")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"selectCustomer", @"selectCustomer")],[NSString stringWithFormat:@"%@:",NSLocalizedString(@"upDate", @"upDate")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"productNum", @"productNum")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"distributBusiness", @"distributBusiness")], @"单价(元):"];
    }else if (self.selectedIndex == 1){
         taskEditVC.title=NSLocalizedString(@"pureSalesReport", @"pureSalesReport");
        dataArray = @[[NSString stringWithFormat:@"%@:", NSLocalizedString(@"productName", @"productName")], [NSString stringWithFormat:@"%@:", NSLocalizedString(@"selectCustomer", @"selectCustomer")],[NSString stringWithFormat:@"%@:", NSLocalizedString(@"productNum", @"productNum")],[NSString stringWithFormat:@"%@:",NSLocalizedString(@"upDate", @"upDate")]];
    }
    taskEditVC.dataArray = dataArray;
    taskEditVC.feedBackSalesStatisticsBlock = ^(SalesStatisticsModel *salesStatisticsModel){
        if (self.selectedIndex == 0) {
//             view1.salesStatisticsModel = salesStatisticsModel;
            [view1 addFinishRefreshData];
        }else if (self.selectedIndex == 1){
//             view2.salesStatisticsModel = salesStatisticsModel;
            [view2 addFinishRefreshData];
        }else{
//             view3.salesStatisticsModel = salesStatisticsModel;
            [view3 addFinishRefreshData];
        }
       
    };
    taskEditVC.salesStatisticsType = (int)self.selectedIndex;
    [self.navigationController pushViewController:taskEditVC animated:YES];
}

- (void)searchClick{
    SalesStatisticsSearchViewController *searchCtrl = [[SalesStatisticsSearchViewController alloc] init];
    searchCtrl.type = self.selectedIndex;
    
    if (self.selectedIndex == 0) {
        searchCtrl.saveDic =view1.saveDic;
        
    }else if (self.selectedIndex == 1) {
        searchCtrl.saveDic =view2.saveDic;
        
    }else if (self.selectedIndex == 2) {
        searchCtrl.saveDic =view3.saveDic;
    }else {
        
    }
    
    
    [self.navigationController pushViewController:searchCtrl animated:YES];
    
    [searchCtrl backSearchParameterAction:^(NSDictionary *parameter, NSDictionary *saveDic) {
        if (self.selectedIndex == 0) {
            view1.paraDic = parameter;
            view1.saveDic = saveDic;
            [view1 searchActionRefreshData];
            
        }else if (self.selectedIndex == 1) {
            view2.paraDic = parameter;
            view2.saveDic = saveDic;
            [view2 searchActionRefreshData];
            
        }else if (self.selectedIndex == 2) {
            view3.paraDic = parameter;
            view3.saveDic = saveDic;
            [view3 searchActionRefreshData];
        }else {
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
