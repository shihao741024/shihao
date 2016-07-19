//
//  LoginViewController.m
//  errand
//
//  Created by gravel on 16/1/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserBLL.h"
#import "Dialog.h"
@interface LoginViewController ()

@end

@implementation LoginViewController{
    UITextField *_passField;
    UITextField *_phoneField;
    UIButton *_loginButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.322 green:0.710 blue:0.996 alpha:1.000];
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20 , SCREEN_WIDTH, SCREEN_WIDTH*251/200)];
    bgImgView.image = [UIImage imageNamed:@"loginBg"];
    [self.view addSubview:bgImgView];
    UILabel *appNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0,20+ SCREEN_WIDTH*251/200+10, SCREEN_WIDTH, 25)];
    
    appNameLbl.text = @"医路行";
    appNameLbl.backgroundColor = [UIColor clearColor];
    appNameLbl.textAlignment = NSTextAlignmentCenter;
    appNameLbl.font = [UIFont boldSystemFontOfSize:18];
    appNameLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:appNameLbl];
    if (SCREEN_HEIGHT > 480) {
        [UIView animateWithDuration:2 animations:^{
            bgImgView.frame = CGRectMake(0,  20-[MyAdapter aDapterView:100] , SCREEN_WIDTH, SCREEN_WIDTH*251/200);
            appNameLbl.frame = CGRectMake(0, 20-[MyAdapter aDapterView:100]+SCREEN_WIDTH*251/200+10, SCREEN_WIDTH, 25);
        }];
    }else{
        [UIView animateWithDuration:2 animations:^{
            bgImgView.frame = CGRectMake(0,  20-[MyAdapter aDapterView:100] - 100, SCREEN_WIDTH, SCREEN_WIDTH*251/200);
            appNameLbl.frame = CGRectMake(0, 20-[MyAdapter aDapterView:100]+SCREEN_WIDTH*251/200+10-100, SCREEN_WIDTH, 25);
        }];
    }
   
    
   
   
//    登陆界面
    _loginButton = [[UIButton alloc]init];
    [_loginButton setTitle:NSLocalizedString(@"login", @"login") forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]]];
    _loginButton.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    _loginButton.alpha = 0;
    _loginButton.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(-[MyAdapter aDapterView:40]);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
    //
    UIView *secondView = [[UIView alloc]init];
    secondView.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    secondView.alpha = 0;
    secondView.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:secondView];
    UILabel *passwordLbl = [[UILabel alloc]init];
    passwordLbl.alpha = 0;
    [passwordLbl setText:NSLocalizedString(@"password", @"password")];
    [passwordLbl setTextColor:[UIColor whiteColor]];
    passwordLbl.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:16]];
    [secondView addSubview:passwordLbl];
    _passField = [[UITextField alloc]init];
    _passField.secureTextEntry = YES; //密码
    _passField.clearButtonMode = UITextFieldViewModeAlways;
    _passField.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]];
    _passField.textColor = [UIColor whiteColor];
    [secondView addSubview:_passField];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.5 animations:^{
        _loginButton.alpha = 1;
        secondView.alpha = 1;
        passwordLbl.alpha = 1;
    }];
    });
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_loginButton.mas_top).offset(-[MyAdapter aDapterView:20]);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
   
    [passwordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondView);
        make.left.equalTo(secondView.mas_left).offset([MyAdapter aDapterView:50]/2);
        make.width.equalTo([MyAdapter aDapterView:80]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    [_passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondView);
        make.left.equalTo(passwordLbl.mas_right).offset([MyAdapter aDapterView:10]);
        make.right.equalTo(secondView).offset([MyAdapter aDapterView:-10]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    //
    UIView *firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor colorWithRed:0.216 green:0.580 blue:0.871 alpha:1.000];
    firstView.alpha = 0;
    firstView.layer.cornerRadius = [MyAdapter aDapterView:50]/2;
    [self.view addSubview:firstView];
    UILabel *phoneLbl = [[UILabel alloc]init];
    [phoneLbl setText:NSLocalizedString(@"phoneNumber", @"phoneNumber")];
    phoneLbl.alpha = 0;
    [phoneLbl setTextColor:[UIColor whiteColor]];
    phoneLbl.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:16]];
    [firstView addSubview:phoneLbl];
    _phoneField = [[UITextField alloc]init];
    _phoneField.font = [UIFont boldSystemFontOfSize:[MyAdapter aDapterView:20]];
    _phoneField.textColor = [UIColor whiteColor];
    _phoneField.clearButtonMode = UITextFieldViewModeAlways;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [firstView addSubview:_phoneField];
   
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                firstView.alpha = 1;
                phoneLbl.alpha = 1;
            }];
        });

    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(secondView.mas_top).offset(-[MyAdapter aDapterView:8]);
        make.height.equalTo([MyAdapter aDapterView:50]);
        make.width.equalTo([MyAdapter aDapterView:320]);
    }];
            [phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView);
        make.left.equalTo(firstView.mas_left).offset([MyAdapter aDapterView:50]/2);
        make.width.equalTo([MyAdapter aDapterView:80]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView);
        make.left.equalTo(phoneLbl.mas_right).offset([MyAdapter aDapterView:10]);
        make.right.equalTo(firstView).offset([MyAdapter aDapterView:-10]);
        make.height.equalTo([MyAdapter aDapterView:50]);
    }];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([Function userDefaultsObjForKey:@"userName"]) {
        _phoneField.text = [Function userDefaultsObjForKey:@"userName"];
    }
    
//    _passField.text=@"123456";
    
}
//检测是否通过
-(BOOL)checkForm{
    if(_phoneField.text.length==0){
        [Dialog simpleToast:@"请填写手机号"];
        _loginButton.userInteractionEnabled=YES;
        return false;
    }
    
    if(![self isMobileNumber:_phoneField.text]){
        [Dialog simpleToast:@"请填写正确的手机号"];
        _loginButton.userInteractionEnabled=YES;
        return false;
    }
    if(_passField.text.length==0){
        [Dialog simpleToast:@"请填写密码"];
        _loginButton.userInteractionEnabled=YES;
        return false;
    }
    return true;
}


- (void)loginButtonClick:(UIButton *)button{
    
    [_phoneField resignFirstResponder];
    [_passField resignFirstResponder];
     if(![self checkForm])
     return;
    [self showHintInView:self.view];
     button.userInteractionEnabled=NO;
    UserBLL *useBLL = [[UserBLL alloc]init];
    [useBLL login:^(int result) {
        if(result==1){
            AppDelegate  *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            [del enter];
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@", GDBUserID]];
            [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccessNotification object:self userInfo:nil];
            [self hideHud];
        }else{
            _loginButton.userInteractionEnabled=YES;
            [self hideHud];
        }
        
//        [Dialog simpleToast:@"正在登录中"];
        
    } username:_phoneField.text password:_passField.text  viewCtrl:self];

}
#pragma mark---- 键盘监听事件
-(void)KeyboardWillHide:(NSNotification *)noti
{
    self.view.transform = CGAffineTransformIdentity;//回到最初状态
}
-(void)KeyboardWillShow:(NSNotification *)noti
{
   CGRect keyRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    self.view.transform = CGAffineTransformMakeTranslation(0, -keyRect.size.height);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passField resignFirstResponder];
    [_phoneField resignFirstResponder];
}
//通过正则判断手机号码
//- (BOOL)isMobileNumber:(NSString *)mobileNum
//{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//       最新移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
//     * 联通：130,131,132,152,155,156,185,186
//       最新联通：130 131 132 145 155 156 171 175 176 185 186
//     * 电信：133,1349,153,180,189
//       最新电信：133 149 153 173 177 180 181 189
//       虚拟运营商：170
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

//+ (BOOL)checkTelNumber:(NSString *) telNumber
//{
//    NSString *pattern = @"^1+[3578]+\d{9}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@SELF MATCHES %@, pattern];
//    BOOL isMatch = [pred evaluateWithObject:telNumber];
//    return isMatch;
//}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 最新移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
     * 最新联通：130 131 132 145 155 156 171 175 176 185 186
     * 最新电信：133 149 153 173 177 180 181 189
     * 虚拟运营商：170
     */
    NSString * MOBILE = @"^((13[0-9])|(15[^4\\D])|(18[0-9])|(14[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
