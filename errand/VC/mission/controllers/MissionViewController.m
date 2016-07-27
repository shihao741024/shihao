//
//  MissionViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MissionViewController.h"
#import "MissionChildViewController.h"
#import "MissionEdittingViewController.h"
#import "MissionModel.h"
#import "SearchMissionVC.h"
#import "MissionBll.h"

@interface MissionViewController ()<MissionCommitDelegate>

@end

@implementation MissionViewController{
    MySegmentViewController *pager;
    MissionChildViewController *view;
    MissionChildViewController *view1;
    NSArray *_searchArray;
    int _count;
}

- (void)viewDidLoad {
    [self addBackButton];
    [self showHintInView:self.view];
    
        self.title=NSLocalizedString(@"mission", @"mission");
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self createRightItems];
    pager = (MySegmentViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
    view=[self.storyboard instantiateViewControllerWithIdentifier:@"MissionChildViewController"];
    view.type=0;
    view.title=NSLocalizedString(@"IReport", @"IReport");
    
    view1=[self.storyboard instantiateViewControllerWithIdentifier:@"MissionChildViewController"];
    view1.type=1;
    view1.title = @"我审批的";
    [pages addObject:view];
    [pages addObject:view1];
    [pager setPages:pages];
    
    
    [super viewDidLoad];
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countNumReduce) name:@"numReduce" object:nil];
    _searchArray = [NSMutableArray array];
    
    /*
    MissionBll *bll = [[MissionBll alloc]init];
    [bll getMissionCount:^(int result) {
    
//            NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"IHandled", @"IHandled"),result]];
//            [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, titleStr.length -6)];
        [self hideHud];
        self.title=NSLocalizedString(@"mission", @"mission");
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        [self createRightItems];
        pager = (MySegmentViewController *)self;
        NSMutableArray *pages = [NSMutableArray new];
        view=[self.storyboard instantiateViewControllerWithIdentifier:@"MissionChildViewController"];
        view.type=0;
        view.title=NSLocalizedString(@"IReport", @"IReport");
        
        view1=[self.storyboard instantiateViewControllerWithIdentifier:@"MissionChildViewController"];
        view1.type=1;
        view1.title =  [NSString stringWithFormat:@"%@(%d)",@"我审批的",result];
        _count = result;
        [pages addObject:view];
        [pages addObject:view1];
        [pager setPages:pages];
        
 
        [super viewDidLoad];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countNumReduce) name:@"numReduce" object:nil];
        _searchArray = [NSMutableArray array];
    } viewCtrl:self];

    */
  
    // Do any additional setup after loading the view.
}

- (void)countNumReduce {
    
    _count = _count - 1;
    view1.title = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"IHandled", @"IHandled"), _count];
    NSMutableArray * pages = [NSMutableArray arrayWithArray:@[view, view1]];
    pager.pages = [NSMutableArray arrayWithArray:@[view, view1]];
//    [pager setPages:pages];
//    [pager updateTitleLabels];
//    [pager.pageControl setSectionTitles:[pager getTitleLabelsWithArray:pages]];
//    [pager.pageControl setSectionTitles:[pager getTitleLabelsWithArray:pages];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editMissionData:) name:@"editMissionData" object:nil];
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/trip/count"];

    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        NSString *title1 = [NSString stringWithFormat:@"我审批的(%@)", responseObject[@"size"]];
        view1.title = title1;
        [self updateTitleLabels];
    } errorCB:^(NSError *error) {
        
    }];
}
- (void)editMissionData:(NSNotification*)notification{
    
    view.editIndexPath = [notification.userInfo objectForKey:@"indexPath"];
    view.editModel = notification.object;
    
}
- (void)addClick{
    //.......................
//    NSLog(@"添加1111111111111111111111111");
    //.......................
    MissionEdittingViewController *taskEditVC = [[MissionEdittingViewController alloc] init];
    NSArray *dataArray = @[NSLocalizedString(@"startPoint:", @"startPoint:"), NSLocalizedString(@"estination:", @"estination:"), NSLocalizedString(@"startTime:", @"startTime:"), NSLocalizedString(@"endTime:", @"endTime:"), NSLocalizedString(@"wayForBusiness:", @"wayForBusiness:"),NSLocalizedString(@"contentOfBusiness:", @"contentOfBusiness:")];
    taskEditVC.dataArray = dataArray;
    taskEditVC.missionCommitDelegate = self;
    [self.navigationController pushViewController:taskEditVC animated:YES];
}

- (void)searchClick{
    
    SearchMissionVC *searchVC = [[SearchMissionVC alloc]init];
    searchVC.searchArray = _searchArray;
    [self.navigationController pushViewController:searchVC animated:YES];
    searchVC.feedBackMissionSearchDataBlock= ^(NSString *start,NSString *dest,NSString *content,NSString *startDate,NSString *endDate,NSNumber * traveType,NSNumber* status, NSString *traveTypeStr,NSString *statusStr){
        NSArray *searchArray = @[start,dest,content,startDate,endDate,traveType,status,traveTypeStr,statusStr];
        _searchArray = searchArray;
        if ((int)[pager selectedIndex]) {
            view1.searchArray = searchArray;
        }else{
            view.searchArray = searchArray;
        }
    };

}
#pragma mark - MissionCommitDelegate
- (void)feedBackWithMissionModel:(MissionModel *)model{
    
    
    view.model = model;
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
