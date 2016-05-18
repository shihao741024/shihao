//
//  DetailEdittingViewController.m
//  errand
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "DetailEdittingViewController.h"
#import "HPGrowingTextView.h"

@interface DetailEdittingViewController ()

@end

@implementation DetailEdittingViewController {
    HPGrowingTextView *_textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTextField];
    [self addBackButton];
    [self setNavRightBtn];
}

- (void)setNavRightBtn {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    self.title=NSLocalizedString(@"editting", @"editting");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureBtnClick)];
}

- (void)sureBtnClick {
    if ([self.delegate respondsToSelector:@selector(feedBackEditedDetail:andIndex:)]) {
        [self.delegate feedBackEditedDetail:_textField.text andIndex:self.index];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createTextField {
    CGSize size = [self sizeWithString:self.contentString font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    if ([self.contentString isEqualToString:@""]) {
         _textField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH - 20, 50)];
    }else{
        _textField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH - 20, size.height+15)];
    }
   
    _textField.text = self.contentString;
    _textField.layer.cornerRadius = 10;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.minNumberOfLines = 1;
    _textField.maxNumberOfLines = 4;
    _textField.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_textField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
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
