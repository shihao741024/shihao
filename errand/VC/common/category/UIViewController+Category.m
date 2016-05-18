//
//  UIViewController+Category.m
//  errand
//
//  Created by gravel on 15/12/10.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "UIViewController+Category.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "MMPopupWindow.h"
#import "MMAlertView.h"
#import "MMPopupItem.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController(Category)
-(void)hideNodataLabel:(UIView*)v{
    UILabel *lbl1=[v viewWithTag:453];
    if(lbl1)
    {
        [lbl1 removeFromSuperview];
    }
}
-(void)hideNodataLabel{
    [self hideNodataLabel:self.view];
}

-(void)showNoDataInfo:(UIView*)v title:(NSString*)title{
    UILabel *lbl1=[v viewWithTag:453];
    if(lbl1)
    {
        [lbl1 removeFromSuperview];
    }
    UILabel *lbl =[[UILabel alloc] initWithFrame:CGRectMake(0, v.height/2-50, SCREEN_WIDTH, 100)];
    lbl.tag=453;
    lbl.text=title;
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.textColor=[UIColor colorWithWhite:0.702 alpha:1.000];
    lbl.numberOfLines=0;
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    lbl.textAlignment=NSTextAlignmentCenter;
    [v addSubview:lbl];
    
    //后期加上图片
    float imgWidth=100;
    float imgheight=30;
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(lbl.width/2-imgWidth/2, 0, imgWidth, imgheight)];
    imgView.image=[UIImage imageNamed:@"watermask"];
    //  [lbl addSubview:imgView];
}

-(void)showNoDataInfo:(UIView*)v {
    [self showNoDataInfo:v title:NSLocalizedString(@"nodata", @"there is no more data")];
}
-(void)showNoDataInfo{
    [self showNoDataInfo:self.view title:NSLocalizedString(@"nodata", @"there is no more data")];
}

-(void)showInfica{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)hideInfica{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    [self showInfica];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelColor=[UIColor grayColor];
    HUD.labelText = hint;
 
    HUD.labelFont=[UIFont systemFontOfSize:12.0];
    HUD.color=[UIColor clearColor];
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}
- (void)showHint{
     UIView *view = [[UIApplication sharedApplication].delegate window];
    [self showHudInView:view hint:NSLocalizedString(@"Loading", @"Loading")];
}
- (void)showHintInView:(UIView*)v{
    [self showHudInView:v hint:NSLocalizedString(@"Loading", @"Loading")];
}

- (void)showHint:(NSString *)hint
{
   
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset =IS_IPHONE_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud   {
    [self hideInfica];
    [[self HUD] hide:YES];
}

//拨打电话的功能
-(void)openCall:(NSString *)phone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

//清除不需要的行
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = COMMON_BACK_COLOR;
    [tableView setTableFooterView:view];
    
}

//根据日期获取周几
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//根据日期获取是一周的第几天
- (NSInteger)orderDayFromDate:(NSDate*)inputDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return theComponents.weekday;
}
#pragma mark -- MFMessageComposeViewControllerDelegate
//发送短信功能
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch(result){
        caseMessageComposeResultSent:
            //信息传送成功
            break;
        caseMessageComposeResultFailed:
            //信息传送失败
            break;
        caseMessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}

-(void)showMessageView:(NSArray *)phones
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:phones[0] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        if( [MFMessageComposeViewController canSendText] )
        {
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
            NSArray *phoneArray = @[alertView.title];
            controller.recipients = phoneArray;
            controller.navigationBar.tintColor = [UIColor redColor];
            controller.body = @"";
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
            [[[controller viewControllers] lastObject] goBackMainAPP];
            //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"该设备不支持短信功能"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
 
    }
}

//从短信页面返回主页面
- (void)goBackMainAPP{
    UIImage* img=[UIImage imageNamed:@"title_back.png"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame =CGRectMake(0, 0, 32, 32);
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(messageItemClicked) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}

- (void)messageItemClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//下拉列表
- (UIView *)getPopUpView:(UIView*)popUpView {
    
//    if (popUpView == nil) {
        popUpView = [[UIView alloc]init];
        popUpView.backgroundColor = [UIColor clearColor];
    popUpView.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, 64, 100, 0);

        [UIView animateWithDuration:0.5 animations:^{
            popUpView.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, 64, 100, 150);
            
        }];
        for (int i = 0; i < 3; i++) {
              UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(0, 0, 100, 0);

                       [button setTitle:@"xiala" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                
                button.frame = CGRectMake(0, i*50, 100, 50);
                
            }];

            [popUpView addSubview:button];
            [button addTarget:self action:@selector(KindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
      
//    }
    return popUpView;
}
- (void)KindButtonClick:(UIButton*)button{
    
}

//获取第一个字母
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
//改变搜索栏的颜色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
/**
 *  获取用户的id
 *
 *  @return id
 */

- (NSNumber*)getUserID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userID"];
}

#pragma mark - 计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    if (str != [NSNull null]) {
        NSDictionary *dict = @{NSFontAttributeName:font};
        CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        return size;
    }else {
        return CGSizeZero;
    }
    
    
}

- (void)createRightItems{
    UIButton * rightBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [rightBtnOne setBackgroundImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtnOne addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rightBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"add_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"add_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [rightBtnTwo addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [bgView addSubview:rightBtnOne];
    [bgView addSubview:rightBtnTwo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    
}

- (void)addClick{
    
}

- (void)searchClick{
    
}
-(void)createMissionRightItems{
    UIButton * rightBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [rightBtnOne setBackgroundImage:[[UIImage imageNamed:@"edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtnOne addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rightBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(40, 5, 30, 30)];
    [rightBtnTwo setBackgroundImage:[[UIImage imageNamed:@"delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    
    [rightBtnTwo addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [bgView addSubview:rightBtnOne];
    [bgView addSubview:rightBtnTwo];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
}
- (void)editClick{
    
}
- (void)deleteClick{
    
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
