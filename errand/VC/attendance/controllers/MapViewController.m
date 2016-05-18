//
//  MapViewController.m
//  errand
//
//  Created by gravel on 16/1/11.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "MapViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
@interface MapViewController ()
// 地图定位

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButton];
    self.title = NSLocalizedString(@"path", @"path");
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
