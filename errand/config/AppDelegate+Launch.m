//
//  AiYueDongDelegate+Launch.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AppDelegate+Launch.h"

#import "RDVTabBar.h"
#import "RDVTabBarItem.h"


@implementation AppDelegate(Launch)

-(RDVTabBarController *)createTabBar{
    RDVTabBarController *tabBarController = [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    return tabBarController;
}

- (void)checkUpdateInfo
{
    if (GDBUserID) {
        NSLog(@"检查是否有更新 %@", GDBUserID);
        NSString *urlStr = [BASEURL stringByAppendingString:@"/api/v1/content/ios"];
        [Function generalGetRequest:urlStr infoDic:nil resultCB:^(id responseObject) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        
            if (![Function isNullOrNil:dic[@"version"]]) {
                if ([dic[@"version"] floatValue] > [AppBulid floatValue]) {
                    
                    NSLog(@"有新版本");
                    ExtendtionAlertView *alert = [[ExtendtionAlertView alloc] initWithTitle:@"信息提示" message:dic[@"description"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.userInfo = dic;
                    alert.tag = 298618;
                    [alert show];
                    
                }else {
                 
                    NSLog(@"当前为最新版本");
                }
                
            }
        } errorCB:^(NSError *error) {
            
        }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
    }else{
    //跳转AppStore
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/yi-lu-xing/id1111479249?mt=8"]];
    
    }
    

}


- (RDVTabBarController *)setupViewControllers {
    UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *firstNavigationController =[secondStroyBoard instantiateViewControllerWithIdentifier:@"HomeNav"];
    
    
    UIViewController *secondViewController=[secondStroyBoard instantiateViewControllerWithIdentifier:@"InfoNav"];
    
    UIViewController *msgNav=[secondStroyBoard instantiateViewControllerWithIdentifier:@"MineNav"];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondViewController,
                                           msgNav]];
   
    self.viewController = tabBarController;
    [tabBarController.tabBar setHeight:BOTTOM_HEIGHT];
    [self customizeTabBarForController:tabBarController];
    
    return tabBarController;
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"bottom_home", @"bottom_msg", @"bottom_my"];
    NSArray *tabBarItemTitles = @[NSLocalizedString(@"workbench","workbench"),NSLocalizedString(@"message","message"), NSLocalizedString(@"my","my")];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        item.itemHeight=BOTTOM_HEIGHT;
        // [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        NSDictionary *unselectedTitleAttributes = nil, *selectedTitleAttributes = nil;
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            unselectedTitleAttributes = @{
                                          NSFontAttributeName: [UIFont systemFontOfSize:12],
                                          NSForegroundColorAttributeName: [UIColor colorWithWhite:0.604 alpha:1.000],
                                          };
            
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            unselectedTitleAttributes = @{
                                          UITextAttributeFont: [UIFont systemFontOfSize:12],
                                          UITextAttributeTextColor: [UIColor colorWithWhite:0.604 alpha:1.000],
                                          };
#endif
        }
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            selectedTitleAttributes = @{
                                        NSFontAttributeName: [UIFont systemFontOfSize:12],
                                        NSForegroundColorAttributeName: [UIColor colorWithRed:0.400 green:0.769 blue:1.000 alpha:1.000],
                                        };
            
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            selectedTitleAttributes = @{
                                        UITextAttributeFont: [UIFont systemFontOfSize:12],
                                        UITextAttributeTextColor: [UIColor colorWithRed:0.400 green:0.769 blue:1.000 alpha:1.000],
                                        };
#endif
        }
        item.unselectedTitleAttributes=unselectedTitleAttributes;
        item.selectedTitleAttributes=selectedTitleAttributes;
        
        index++;
    }
    
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor blackColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}



@end
