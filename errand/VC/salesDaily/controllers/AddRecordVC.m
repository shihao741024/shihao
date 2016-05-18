//
//  AddRecordVC.m
//  errand
//
//  Created by gravel on 16/2/27.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AddRecordVC.h"
#import "AddDailyViewController.h"
@interface AddRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddRecordVC{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = NSLocalizedString(@"addRecord", @"addRecord");
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView{
    _dataArray = @[NSLocalizedString(@"dailyRecord", @"dailyRecord"),NSLocalizedString(@"weekRecord", @"weekRecord"),NSLocalizedString(@"monthRecord", @"monthRecord"),NSLocalizedString(@"share", @"share")];
    _imageArray = @[@"dailylist_icon_day",@"dailylist_icon_week",@"dailylist_icon_month",@"dailylist_icon_share"];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH , SCREEN_HEIGHT-64)];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:_tableView];
    self.automaticallyAdjustsScrollViewInsets =YES;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

#pragma mark --- UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 0) {
        AddDailyViewController *addVC = [[AddDailyViewController alloc]init];
        addVC.type = indexPath.row;
        [self.navigationController pushViewController:addVC animated:YES];
//    }
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
