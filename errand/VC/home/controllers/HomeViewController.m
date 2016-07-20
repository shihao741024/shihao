//
//  HomeViewController.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "HomeViewController.h"

#import "SDHomeGridView.h"
#import "SDHomeGridItemModel.h"
#import "SDGridItemCacheTool.h"
#import "ErrandItemBll.h"
#import "AmotButton.h"
#import "AddMoreViewController.h"
#import "AllFunctionViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ContactViewController.h"
#import "ContactsViewController.h"

@interface HomeViewController ()<SDHomeGridViewDeleate,AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, weak) SDHomeGridView *mainView;
@property (nonatomic, strong) NSArray *dataArray;
@property(nonatomic,strong)AmotButton *moreButton;
@end

@implementation HomeViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
//监听通知有没有开启
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    if (iOSVersion >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            [Function alertUserDeniedNotificationDelegate:self];
        }
    }else {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            [Function alertUserDeniedNotificationDelegate:self];
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.backgroundColor = COMMON_BACK_COLOR;  
   
    self.view.backgroundColor=COMMON_BACK_COLOR;
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title=NSLocalizedString(@"workbench", @"workbench");
    [self setupDataArray];
    [self setupMoreButton];
     [self createRightBtn];
    [self getCurrentCityName];

    
    // Do any additional setup after loading the view.
}
//add
-(void)createRightBtn{
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"totalTunction", @"totalTunction") style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    rightBar.tintColor=COMMON_RightBar_COLOR;
    self.navigationItem.rightBarButtonItem =rightBar;
}

-(void)buttonClick{
    AllFunctionViewController *more = [[AllFunctionViewController alloc]init];
    more.hadArray = _dataArray;
    [more setSetNewChangeClock:^(NSArray *arr) {
        _dataArray=[NSMutableArray arrayWithArray:arr];
        _mainView.gridModelsArray = _dataArray;
    }];
    more.automaticallyAdjustsScrollViewInsets = NO;
    more.edgesForExtendedLayout = UIRectEdgeTop;
    more.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController pushViewController:more animated:YES];

}
/**
 *  更多按钮
 */
-(void)setupMoreButton{
    float btnSize=[MyAdapter aDapter:46];
    float Margin=10;
    float bottomMargin=BOTTOM_HEIGHT;
    AmotButton *btn=[[AmotButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnSize-Margin, SCREEN_HEIGHT-Margin-btnSize-bottomMargin, btnSize, btnSize)];
    [btn setBackgroundImage:[UIImage imageNamed:@"homeMore"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"homeMore_selected"] forState:UIControlStateSelected];
    _moreButton=btn;
    [self.view addSubview:_moreButton];
    [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)moreButtonClick{
    AddMoreViewController *all = [[AddMoreViewController alloc]init];
    all.choicedArr=_dataArray;
    [all setSetNewChangeClock:^(NSArray *arr) {
        _dataArray=arr;
        _mainView.gridModelsArray = _dataArray;
        NSMutableArray *choiceArr = [[NSMutableArray alloc]init];
        for (id item in _dataArray) {
            [choiceArr addObject:[item itemId]];
        }
        NSString *choiceStr= [choiceArr componentsJoinedByString:@","];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:choiceStr forKey:@"homeItems"];
    }];
    [self.navigationController pushViewController:all animated:YES];
 }

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat tabbarHeight =BOTTOM_HEIGHT;
    
    CGFloat headerY = 0;
    headerY = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) ? 64 : 0;
 
    _mainView.frame = CGRectMake(0, headerY, SCREEN_WIDTH, SCREEN_HEIGHT - headerY - tabbarHeight);
}

- (void)setupMainView
{
    SDHomeGridView *mainView = [[SDHomeGridView alloc] init];
    mainView.gridViewDelegate = self;
    mainView.showsVerticalScrollIndicator = NO;
    
//    [self setupDataArray];
    mainView.gridModelsArray = _dataArray;
    [self.view addSubview:mainView];
    _mainView = mainView;
    
}

-(void)setDataToView{
    
}

- (void)setupDataArray
{
    NSArray *totalArr= [ErrandItemBll getAllItem];
    NSString *idStr;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"homeItems"]) {
        idStr= [user objectForKey:@"homeItems"];
    }else{
        idStr = @"1,2,3,4,5,6,7,8,9,10,11";
        [user setObject:idStr forKey:@"homeItems"];
    }
    
    _dataArray=[ErrandItemBll getMyItem:idStr allItem:totalArr];
     [self setupMainView];
}

#pragma mark - SDHomeGridViewDeleate

- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index
{
    SDHomeGridItemModel *model = _dataArray[index];
    @try {
        
        if ([model.itemId intValue] == 6 ) {
          
                UITabBarController *tbc = [[UITabBarController alloc]init];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                NSArray *nameArray = @[@"Hall",@"AboutMe",@"Comment",@"Statistics"];
                NSArray *titleArray = @[NSLocalizedString(@"Hall", @"Hall"),NSLocalizedString(@"AboutMe", @"AboutMe"),NSLocalizedString(@"Comment", @"Comment"),NSLocalizedString(@"Statistics", @"Statistics")];
                NSArray *imageArray = @[@"hall_unchecked",@"aboutMe_unchecked",@"comment_unchecked",@"statistics_unchecked"];
                NSArray *selectArray = @[@"hall_checked",@"aboutMe_checked",@"comment_checked",@"statistics_checked"];
                for (int i = 0 ; i < nameArray.count; i++) {
                    NSString *classStr = [NSString stringWithFormat:@"%@ViewController",nameArray[i]];
                    Class aclass = NSClassFromString(classStr);
                    UIViewController *vc = [[aclass alloc]init];
                            vc.title = titleArray[i];
                    vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArray[i] image:[UIImage imageNamed:imageArray[i]] selectedImage:[UIImage imageNamed:selectArray[i]]];
                    [arr addObject:vc];
                }
                tbc.viewControllers = arr;
            [self.navigationController pushViewController:tbc animated:YES];

        }else{
        /**
         *  Storyboard跳转到各页面
         */
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
        UIViewController *view=[main instantiateViewControllerWithIdentifier:model.toClassSeg];
            if ([view isKindOfClass:[ContactsViewController class]]) {
                ContactsViewController *vc = (ContactsViewController *)view;
                vc.phonebook = YES;
            }
        [self.navigationController pushViewController:view animated:true];
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}


- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView newArr:(NSArray *)arr
{
    _dataArray=arr;
    NSMutableArray *choiceArr = [[NSMutableArray alloc]init];
    for (id item in _dataArray) {
        [choiceArr addObject:[item itemId]];
    }
    NSString *choiceStr= [choiceArr componentsJoinedByString:@","];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:choiceStr forKey:@"homeItems"];

}
- (void)getCurrentCityName{
    // 配置用户KEY
    [self runLocationProcess];
}

- (void)runLocationProcess
{
    _locationManager = nil;
    _locationManager.delegate = nil;
    
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDelegate:self];
    
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    [_locationManager setAllowsBackgroundLocationUpdates:YES];
    [_locationManager startUpdatingLocation];
//    NSLog(@"runLocationProcess");
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"didUpdateLocation%@", location);
    [manager stopUpdatingLocation];
    
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeoRequest];
    
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    [Function alertUserDeniedLocation:error delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LocationErrorAlertTag) {
        [Function isShowSystemLocationSetupPage:buttonIndex];
    }
    if (alertView.tag == NotificationAlertFlag) {
        [Function isShowSystemNotificationSetupPage:buttonIndex];
    }
}

// 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (response.regeocode.addressComponent.city) {
            [user setObject:response.regeocode.addressComponent.city forKey:@"currentcity"];
        }else{
            [user setObject:response.regeocode.addressComponent.province forKey:@"currentcity"];
        }
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
