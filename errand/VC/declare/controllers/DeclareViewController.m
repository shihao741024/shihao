//
//  DeclareViewController.m
//  errand
//
//  Created by gravel on 15/12/18.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DeclareViewController.h"
#import "DeclareChildViewController.h"
#import "SearchDeclareVC.h"
#import "TaskEdittingViewController.h"

@interface DeclareViewController ()

@end

@implementation DeclareViewController{
    MySegmentViewController *pager;
    DeclareChildViewController *view;
    DeclareChildViewController *view1;
    NSArray *_searchArray;
}


- (void)viewDidLoad {
    [self addBackButton];
   self.title = NSLocalizedString(@"declare", @"declare");
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self createRightItems];
    pager = (MySegmentViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
    view=[[DeclareChildViewController alloc]init];
    view.type=0;
    view.title= NSLocalizedString(@"I_Submit", @"I_Submit");
    view1=[[DeclareChildViewController alloc]init];
    view1.type=1;
    view1.title= NSLocalizedString(@"I_Approval", @"I_Approval");
    [pages addObject:view];
    [pages addObject:view1];
    [pager setPages:pages];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/cost/count"];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        NSString *title1 = [NSString stringWithFormat:@"我审批的(%@)", responseObject[@"size"]];
        view1.title = title1;
        [self updateTitleLabels];
    } errorCB:^(NSError *error) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)searchClick{
    SearchDeclareVC *assign = [[SearchDeclareVC alloc]init];
    assign.searchArray = _searchArray;
    
    assign.type = self.selectedIndex;
    if (self.selectedIndex == 0) {
        assign.saveDic = view.saveDic;
    }else if (self.selectedIndex == 1) {
        assign.saveDic = view1.saveDic;
    }
    
    [self.navigationController pushViewController:assign animated:YES];
    assign.feedBackDeclareSearchDataBlock = ^(NSString *title,NSString *customerName,NSString *useWay,NSString *aim,NSString *remark,NSString *statusStr,NSNumber* status,NSNumber *productID,NSNumber *hospitalID,NSNumber *doctorID,NSString *productStr, NSMutableDictionary *saveDic){
        NSArray *searchArray = @[title,customerName,useWay,aim,remark,statusStr,status,productID,hospitalID,doctorID, saveDic];
//        _searchArray = searchArray;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSearchArray" object:searchArray];
        
//        if ((int)[pager selectedIndex]) {
//            view1.searchArray = searchArray;
//        }else{
//            view.searchArray = searchArray;
//        }

    };
}

- (void)addClick{
    
    //    根据type来复用任务交办的申请页面
    TaskEdittingViewController *taskEditVC = [[TaskEdittingViewController alloc] init];
    NSArray *dataArray = @[NSLocalizedString(@"PRO_Name", @"PRO_Name"), NSLocalizedString(@"Standard", @"Standard"),  NSLocalizedString(@"COST_Client", @"COST_Client"),NSLocalizedString(@"USE_Way",@"USE_Way"),NSLocalizedString(@"BUDGET_Cost",@"BUDGET_Cost"),NSLocalizedString(@"BUDGET_Aim",@"BUDGET_Aim"),NSLocalizedString(@"remarks",@"remarks")];
    taskEditVC.dataArray = dataArray;
    taskEditVC.type = 1;
    taskEditVC.feedBackDeclareBlock = ^(DeclareModel *declareModel){
        view.model = declareModel;
    };
    [self.navigationController pushViewController:taskEditVC animated:YES];
    
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
