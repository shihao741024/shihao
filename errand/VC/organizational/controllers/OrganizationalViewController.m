//
//  OrganizationViewController.m
//  errand
//
//  Created by gravel on 16/1/25.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "OrganizationalViewController.h"
#import "FirstOrganizationalVC.h"
#import "SecondOrganizationalVC.h"

@interface OrganizationalViewController ()

@end

@implementation OrganizationalViewController


- (void)viewDidLoad {
    [self addBackButton];
    self.title = NSLocalizedString(@"allStaff", @"allStaff");
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    MySegmentViewController *pager = (MySegmentViewController *)self;
    NSMutableArray *pages = [NSMutableArray new];
    
    
    SecondOrganizationalVC *view1 = [[SecondOrganizationalVC alloc]init];
    view1.title=@"全体员工";
    
    FirstOrganizationalVC *view = [[FirstOrganizationalVC alloc]init];
    view.title= @"组织员工";
    
    
    [pages addObject:view1];
    [pages addObject:view];
    [pager setPages:pages];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
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
