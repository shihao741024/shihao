//
//  JurisdictionVC.m
//  errand
//
//  Created by gravel on 16/2/29.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "JurisdictionVC.h"
#import "JurisdictionTableViewCell.h"
@interface JurisdictionVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JurisdictionVC{
    UITableView *_tableView;
    NSArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = NSLocalizedString(@"jurisdiction", @"jurisdiction");
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView{
    
    _dataArray = @[@"仅自己和领导可见",@"所在部门和领导可见",@"全公司可见"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JurisdictionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[JurisdictionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([_jurisdictionStr isEqualToString:_dataArray[indexPath.row]]) {
        cell.titleLabel.text = _dataArray[indexPath.row];
        cell.selectImage.image = [UIImage imageNamed:@"img_isselect"];
    }else{
        cell.titleLabel.text = _dataArray[indexPath.row];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.jurisdictionClickBlock(_dataArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
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
