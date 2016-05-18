//
//  ChangePwdViewController.m
//  errand
//
//  Created by 高道斌 on 16/4/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "userBll.h"

@interface ChangePwdViewController ()
{
    UIImageView *_bgImgView;
    
    CustomInputView *_oldView;
    CustomInputView *_newView;
    CustomInputView *_confirmView;
    
}
@end

//密码修改界面
@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title=NSLocalizedString(@"modifyPW", @"modifyPW");
    [self addBackButton];
    
    [self registerKeyboardNotification];
    [self uiConfig];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)uiConfig
{
    [self addBackgroundView];
    [self addTextFieldAndButton];
}

- (void)addBackgroundView
{
    _bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImgView.backgroundColor = [UIColor colorWithRed:0.34 green:0.71 blue:0.98 alpha:1.00];
    _bgImgView.contentMode = UIViewContentModeTop;
    _bgImgView.image = [UIImage imageNamed:@"loginBg"];
    _bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImgView];
    
    
}

- (void)addTextFieldAndButton
{
    //从下到上
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    changeButton.layer.backgroundColor = [UIColor colorWithRed:0.24 green:0.58 blue:0.86 alpha:1.00].CGColor;
    changeButton.layer.cornerRadius = 20;
    changeButton.frame = CGRectMake(40, kHeight-60, kWidth-80, 40);
    [changeButton setTitle:@"修改" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImgView addSubview:changeButton];
    
    
    _confirmView = [[CustomInputView alloc] initWithFrame:CGRectMake(40, kFrameY(changeButton)-10-40, kFrameW(changeButton), 40)];
    _confirmView.titleLabel.text = @"确认密码：";
    [_bgImgView addSubview:_confirmView];
    
    _newView = [[CustomInputView alloc] initWithFrame:CGRectMake(40, kFrameY(_confirmView)-10-40, kFrameW(changeButton), 40)];
    _newView.titleLabel.text = @"新密码：";
    [_bgImgView addSubview:_newView];
    
    _oldView = [[CustomInputView alloc] initWithFrame:CGRectMake(40, kFrameY(_newView)-10-40, kFrameW(changeButton), 40)];
    _oldView.titleLabel.text = @"旧密码：";
    [_bgImgView addSubview:_oldView];
    
    
}

- (void)sureButtonClick:(UIButton*)button{
    
    if ([_oldView.textField.text isEqualToString:@""]||[_newView.textField.text isEqualToString:@""]||[_confirmView.textField.text isEqualToString:@""]) {
        
        [Dialog simpleToast:@"不能有空信息"];
    }else if (![_newView.textField.text isEqualToString:_confirmView.textField.text]){
               [Dialog simpleToast:@"两次新密码不一致"];
    }else if ([_oldView.textField.text isEqualToString:_newView.textField.text]){
       
        [Dialog simpleToast:@"新密码不能与原密码相同"];
    }else{
        [self showHintInView:self.view];
        UserBLL *userBll = [[UserBLL alloc]init];
        [userBll modifyPW:^(int result) {
            [self hideHud];
            [self.navigationController popViewControllerAnimated:YES];
        } oldPassword:_oldView.textField.text newPassword:_newView.textField.text viewCtrl:self];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_oldView.textField resignFirstResponder];
    [_newView.textField resignFirstResponder];
    [_confirmView.textField resignFirstResponder];
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


@implementation CustomInputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.24 green:0.58 blue:0.86 alpha:1.00].CGColor;
        self.layer.cornerRadius = frame.size.height/2.0;
        
        _titleLabel = [self createGeneralLabel:15 frame:CGRectMake(20, 0, 75, frame.size.height) textColor:[UIColor whiteColor]];
        
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(20+75+5, 0, frame.size.width-(20+75+5), frame.size.height)];
        _textField.font = GDBFont(15);
        _textField.secureTextEntry = YES;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor whiteColor];
        [self addSubview:_textField];
    }
    return self;
}

@end
