//
//  HomeMoreViewController.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AllFunctionViewController.h"
#import "AllFuncTableViewCell.h"
#import "SDHomeGridItemModel.h"
#import "ErrandItemBll.h"
@interface AllFunctionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIBarButtonItem *btnRight;
@end

@implementation AllFunctionViewController{
    UITableView *_tableView;
    NSArray *_dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COMMON_BACK_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"totalTunction", @"totalTunction");
    [self addBackButton];
    [self createData];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

/**
 *  创建要添加项目的选项
 */
-(void)createData{
    _dataArray= [ErrandItemBll getAllItem];
    [self createTable];
}

-(void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AllFuncTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    SDHomeGridItemModel *model = _dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.titleImage.image = [UIImage imageNamed:model.imageResString];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDHomeGridItemModel *model = _dataArray[indexPath.row];
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
                //                    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
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
            [self.navigationController pushViewController:view animated:true];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
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
