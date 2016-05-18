//
//  AssignViewController.m
//  errand
//
//  Created by gravel on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AssignViewController.h"

@interface AssignViewController ()

@end

@implementation AssignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"assign", @"assign");
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createRightItem];
    
    // Do any additional setup after loading the view.
}
- (void)createRightItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)submitClick{
    
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
