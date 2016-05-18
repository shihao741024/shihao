//
//  ModifyPWViewController.m
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "ModifyPWViewController.h"
#import "UserBLL.h"
#import "MMAlertView.h"
@interface ModifyPWViewController ()

@end

@implementation ModifyPWViewController{
    UITextField *_oldPwdField;
    UITextField *_newPwdField;
    UITextField *_confirmField;
    UIButton *_sureButton;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor colorWithRed:0.34 green:0.71 blue:0.98 alpha:1.00];
    self.title=NSLocalizedString(@"modifyPW", @"modifyPW");
    
    [self addBackgroundView];
    [self addBackButton];
    [self createView];
}

- (void)addBackgroundView
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.backgroundColor = [UIColor colorWithRed:0.34 green:0.71 blue:0.98 alpha:1.00];
    imgView.contentMode = UIViewContentModeTop;
    imgView.image = [UIImage imageNamed:@"loginBg"];
    [self.view addSubview:imgView];
}

- (void)createView{
    //老密码
    UIView *oldView = [[UIView alloc]init];
    oldView.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    oldView.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:oldView];
    UILabel *oldpasswordLbl = [[UILabel alloc]init];
    [oldpasswordLbl setText:NSLocalizedString(@"oldPW", @"oldPW")];
    [oldpasswordLbl setTextColor:[UIColor whiteColor]];
    oldpasswordLbl.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:16]];
    [oldView addSubview:oldpasswordLbl];
    
    _oldPwdField = [[UITextField alloc]init];
    _oldPwdField.secureTextEntry = YES; //密码
    _oldPwdField.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]];
    _oldPwdField.textColor = [UIColor whiteColor];
    [oldView addSubview:_oldPwdField];
   
    [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset([MyAdapter aDapterView:20]+64);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
    
    [oldpasswordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oldView);
        make.left.equalTo(oldView.mas_left).offset([MyAdapter aDapterView:50]/2);
        make.width.equalTo([MyAdapter aDapterView:80]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    [_oldPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oldView);
        make.left.equalTo(oldpasswordLbl.mas_right).offset([MyAdapter aDapterView:10]);
        make.right.equalTo(oldView.mas_right).offset(-[MyAdapter aDapterView:10]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    
    //新密码
    UIView *newView = [[UIView alloc]init];
    newView.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    newView.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:newView];
    UILabel *newPWLbl = [[UILabel alloc]init];
    [newPWLbl setText:NSLocalizedString(@"newPW", @"newPW")];
    [newPWLbl setTextColor:[UIColor whiteColor]];
    newPWLbl.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:16]];
    [newView addSubview:newPWLbl];
    _newPwdField = [[UITextField alloc]init];
    _newPwdField.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]];
    _newPwdField.textColor = [UIColor whiteColor];
    _newPwdField.secureTextEntry = YES;
    [newView addSubview:_newPwdField];
    
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(oldView.mas_bottom).offset([MyAdapter aDapterView:8]);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
    [newPWLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newView);
        make.left.equalTo(newView.mas_left).offset([MyAdapter aDapterView:50]/2);
        make.width.equalTo([MyAdapter aDapterView:80]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    [_newPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newView);
        make.left.equalTo(newPWLbl.mas_right).offset([MyAdapter aDapterView:10]);
        make.right.equalTo(newView.mas_right).offset(-[MyAdapter aDapterView:10]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    //确认密码
    UIView *confirmView = [[UIView alloc]init];
    confirmView.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    confirmView.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:confirmView];
    UILabel *confirmLbl = [[UILabel alloc]init];
    [confirmLbl setText:NSLocalizedString(@"confirmPW", @"confirmPW")];
    [confirmLbl setTextColor:[UIColor whiteColor]];
    confirmLbl.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:16]];
    [confirmView addSubview:confirmLbl];
    _confirmField = [[UITextField alloc]init];
    _confirmField.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]];
    _confirmField.textColor = [UIColor whiteColor];
    _confirmField.secureTextEntry = YES;
    [confirmView addSubview:_confirmField];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(newView.mas_bottom).offset([MyAdapter aDapterView:8]);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
    
    [confirmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmView);
        make.left.equalTo(confirmView.mas_left).offset([MyAdapter aDapterView:50]/2);
        make.width.equalTo([MyAdapter aDapterView:80]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    [_confirmField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmView);
        make.left.equalTo(confirmLbl.mas_right).offset([MyAdapter aDapterView:10]);
        make.right.equalTo(confirmView.mas_right).offset(-[MyAdapter aDapterView:10]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];

    _sureButton = [[UIButton alloc]init];
    [_sureButton setTitle:NSLocalizedString(@"sure", @"sure") forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureButton.titleLabel setFont:[UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]]];
    _sureButton.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    _sureButton.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:_sureButton];
    [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(confirmView.mas_bottom).offset([MyAdapter aDapterView:40]);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
    

}
- (void)sureButtonClick:(UIButton*)button{
  
    if ([_oldPwdField.text isEqualToString:@""]||[_newPwdField.text isEqualToString:@""]||[_confirmField.text isEqualToString:@""]) {
//        MMPopupItemHandler block = ^(NSInteger index){
//            
//        };
//        
//        NSArray *items =
//        @[
//          MMItemMake(@"确定", MMItemTypeHighlight, block)];
//        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
//                                                             detail:@"不能有空信息"
//                                                              items:items];
//        [alertView show];
          [Dialog simpleToast:@"不能有空信息"];
    }else if (![_newPwdField.text isEqualToString:_confirmField.text]){
//        MMPopupItemHandler block = ^(NSInteger index){
//            
//        };
//        
//        NSArray *items =
//        @[
//          MMItemMake(@"确定", MMItemTypeHighlight, block)];
//        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
//                                                             detail:@"两次新密码不一致"
//                                                              items:items];
//        [alertView show];
          [Dialog simpleToast:@"两次新密码不一致"];
    }else if ([_oldPwdField.text isEqualToString:_newPwdField.text]){
//        MMPopupItemHandler block = ^(NSInteger index){
//            
//        };
//        
//        NSArray *items =
//        @[
//          MMItemMake(@"确定", MMItemTypeHighlight, block)];
//        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
//                                                             detail:@"新密码不能与原密码相同"
//                                                              items:items];
//        [alertView show];
        [Dialog simpleToast:@"新密码不能与原密码相同"];
    }else{
          [self showHintInView:self.view];
        UserBLL *userBll = [[UserBLL alloc]init];
        [userBll modifyPW:^(int result) {
            [self hideHud];
            [self.navigationController popViewControllerAnimated:YES];
        } oldPassword:_oldPwdField.text newPassword:_newPwdField.text viewCtrl:self];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_oldPwdField resignFirstResponder];
     [_newPwdField resignFirstResponder];
     [_confirmField resignFirstResponder];
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
