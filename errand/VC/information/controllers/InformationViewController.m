//
//  InformationViewController.m
//  errand
//
//  Created by gravel on 16/2/2.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "InformationViewController.h"
#import "InformatiionDetailVC.h"
@interface InformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation InformationViewController{
    UITableView *_tableView;
    NSArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    _dataArray = @[@"官方小秘书",@"待办事宜"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0.957 alpha:1.000];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = COMMON_BACK_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView  setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.imageView.image = [UIImage imageNamed:@"attendance"];
    
    if ([_dataArray[indexPath.row] isEqualToString:@"待办事宜"]) {
        id msgNum = [Function userDefaultsObjForKey:@"msgNum"];
        if (msgNum) {
            if ([msgNum isEqual:@0]) {
                cell.detailTextLabel.text = @"";
            }else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", msgNum];
            }
        }else {
            cell.detailTextLabel.text = @"";
        }
    }else {
        cell.detailTextLabel.text = @"";
    }
    
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InformatiionDetailVC *vc = [[InformatiionDetailVC alloc]init];
    vc.title = _dataArray[indexPath.row];
    vc.type = (int)indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
    [Function userDefaultsSetObj:[NSNumber numberWithInteger:0] forKey:@"msgNum"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
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
