//
//  AboutUsViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    UITextView *_aboutTextView;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    self.title = @"关于我们";
    [self addBackButton];
    
    [self uiConfig];
    [self prepareData];
}

- (void)uiConfig
{
    _aboutTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 64, kWidth-40, kHeight-64-20)];
    
    _aboutTextView.font = GDBFont(15);
    _aboutTextView.textColor = COMMON_FONT_BLACK_COLOR;
    _aboutTextView.editable = NO;
    _aboutTextView.backgroundColor = COMMON_BACK_COLOR;
    [self.view addSubview:_aboutTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)prepareData
{
    NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/content/about"];
    [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
        _aboutTextView.text = responseObject[@"value"];
    } errorCB:^(NSError *error) {
        
    }];
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
