//
//  CommentViewController.m
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentChildVC.h"
@interface CommentViewController ()

@end

@implementation CommentViewController

- ( void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    UITabBarController *tbc = self.tabBarController;
    [self createRightItems];
    tbc.title = NSLocalizedString(@"Comment", @"Comment");
}

- (void)createRightItems{
    UITabBarController *tbc = self.tabBarController;
    tbc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc]init]];
}

- (void)viewDidLoad {

    CommentSegmentedViewController *pager = (CommentSegmentedViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
    CommentChildVC *view1=[[CommentChildVC alloc]init];
    view1.type= 0;
    view1.title=NSLocalizedString(@"commentForMe", @"commentForMe");
    CommentChildVC *view2=[[CommentChildVC alloc]init];
    view2.type=1;
    view2.title=NSLocalizedString(@"myComment", @"myComment");
    [pages addObject:view1];
    [pages addObject:view2];
    [pager setPages:pages];
   [super viewDidLoad];

//     Do any additional setup after loading the view.
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
