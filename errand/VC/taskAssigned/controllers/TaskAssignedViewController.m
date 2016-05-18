//
//  TaskAssignedViewController.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "TaskAssignedViewController.h"
#import "TaskAssignedChildViewController.h"
#import "TaskAssignedChildViewController.h"
#import "SearchTaskVC.h"
#import "TaskEdittingViewController.h"

@interface TaskAssignedViewController ()

@end

@implementation TaskAssignedViewController{
    MySegmentViewController *pager;
    TaskAssignedChildViewController *view;
    TaskAssignedChildViewController *view1;
    NSArray *_searchArray;
}

- (void)viewDidLoad {
    [self addBackButton];
    self.title = NSLocalizedString(@"taskAssign", @"taskAssign");
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self createRightItems];
    pager = (MySegmentViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
   view=[self.storyboard instantiateViewControllerWithIdentifier:@"TaskAssignedChildViewController"];
    view.type=0;
    view.title=NSLocalizedString(@"I_Assign", @"I_Assign");
    view1=[self.storyboard instantiateViewControllerWithIdentifier:@"TaskAssignedChildViewController"];
    view1.type=1;
    view1.title=NSLocalizedString(@"I_Backlog", @"I_Backlog");
    [pages addObject:view];
    [pages addObject:view1];
    [pager setPages:pages];
    [super viewDidLoad];
    _searchArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/sale/task/to"];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        NSString *title1 = [NSString stringWithFormat:@"我待办的(%@)", responseObject[@"size"]];
        view1.title = title1;
        [self updateTitleLabels];
    } errorCB:^(NSError *error) {
        
    }];
}

- (void)searchClick{
    
    SearchTaskVC *allSearchVC = [[SearchTaskVC alloc]init];
    allSearchVC.searchArray = _searchArray;
    allSearchVC.type = (int)[pager selectedIndex];
    [self.navigationController pushViewController:allSearchVC animated:YES];
    allSearchVC.feedBackTaskSearchDataBlock= ^(NSNumber *category,NSString *beginDate,NSString *endDate,NSString *content,NSString *title,NSNumber *to,NSString *staffName,NSString *kindStr){
        NSArray *searchArray = @[category,beginDate,endDate,content,title,to,staffName,kindStr];
        _searchArray = searchArray;
        if (allSearchVC.type == 0) {
            view.searchArray = searchArray;
            [view searchAction];
        }else{
            view1.searchArray = searchArray;
            [view1 searchAction];
        }
        
    };
}

- (void)addClick{
    TaskEdittingViewController *taskEditVC = [[TaskEdittingViewController alloc] init];
    NSArray *dataArray = @[NSLocalizedString(@"taskName", @"taskName"), NSLocalizedString(@"priority", @"priority"), NSLocalizedString(@"receiver", @"receiver"), NSLocalizedString(@"finishDate", @"finishDate"), NSLocalizedString(@"taskContent", @"taskContent")];
    taskEditVC.dataArray = dataArray;
    taskEditVC.feedBackBlock = ^(TaskModel *model){
        view.model = model;
    };
    
    [taskEditVC setFeedBackBlockTaskModels:^(NSArray<TaskModel *> *models) {
        view.models = models;
    }];
    
    taskEditVC.type = 0;
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
