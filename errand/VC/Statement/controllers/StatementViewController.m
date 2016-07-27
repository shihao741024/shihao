//
//  StatementViewController.m
//  errand
//
//  Created by 胡先生 on 16/7/13.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "StatementViewController.h"
#import "AppDelegate.h"
@interface StatementViewController ()

@end

@implementation StatementViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}



- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
//
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.allowRotation = 1;
    [self webView];
    [self addBackButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 1;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
}


-(UIWebView*)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(0);
        }];
        NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/report/saleReport"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *mrequest = [NSMutableURLRequest requestWithURL:url];
        NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
        NSString *username = [userDefault objectForKey:@"userName"];
        NSString *token = [userDefault objectForKey:@"token"];
        
        [mrequest setValue:username forHTTPHeaderField:@"username"];
        [mrequest setValue:token forHTTPHeaderField:@"token"];
        
        [_webView loadRequest:mrequest];
    }
    return _webView;
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
   
}



- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
       
    }];
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
