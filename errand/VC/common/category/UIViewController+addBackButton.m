//
//  UIViewController+addBackButton.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "UIViewController+addBackButton.h"

@implementation UIViewController(addBackButton)
- (void)navigationItemClicked:(UIButton *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addCloseBtn{
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(navigationItemCloseClicked:)];
    leftButton.tintColor=[UIColor colorWithWhite:0.173 alpha:1.000];
    [self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
}
- (void)addBackButton
{
    UIImage* img=[UIImage imageNamed:@"title_back.png"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame =CGRectMake(0, 0, 32, 32);
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(navigationItemClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
    
    //    //添加导航栏左侧的按钮
    //    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationItemClicked:)];
    //    leftItem.tintColor = [UIColor whiteColor];
    //    leftItem.tag = 1;
    //    [self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
}

-(void)addCloseButton
{
    UIImage* img=[UIImage imageNamed:@"title_back.png"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame =CGRectMake(0, 0, 32, 32);
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(navigationItemCloseClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}
- (void)navigationItemCloseClicked:(UIBarButtonItem *)barButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
