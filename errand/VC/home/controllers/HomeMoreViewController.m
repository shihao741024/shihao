//
//  HomeMoreViewController.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "HomeMoreViewController.h"
#import "AllFuncTableViewCell.h"
#import "SDHomeGridItemModel.h"
#import "ErrandItemBll.h"
@interface HomeMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIBarButtonItem *btnRight;
@end

@implementation HomeMoreViewController{
    UITableView *_tableView;
    NSMutableArray *_addArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COMMON_BACK_COLOR;
    self.title = NSLocalizedString(@"addTunction", @"addTunction");
    [self addBackButton];
    [self setupDataArray];
    
    // Do any additional setup after loading the view.
}
/**
 *  创建要添加项目的选项
 */
-(void)setupDataArray{
    NSArray *totalArr= [ErrandItemBll getAllItem];
    _addArray = [NSMutableArray arrayWithArray:totalArr];
    for (SDHomeGridItemModel *model in self.hadArray) {
        
        for (SDHomeGridItemModel *addMmodel in _addArray) {
            if ([addMmodel.title isEqual:model.title]) {
                [_addArray removeObject:addMmodel];
                break;
            }
        }
        
//        [_addArray removeObject:model];
//        NSLog(@"%lu",(unsigned long)_addArray.count);
    }
    if (_addArray.count > 0) {
        [self createTable];
    }else{
        
        [self showNoDataInfo:self.view];
    }
    
    
}
-(void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    for (int i = 0; i < _addArray.count; i++) {
 
        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1) * 70,SCREEN_WIDTH , 1)];

       separator.backgroundColor = [UIColor colorWithWhite:0.906 alpha:1.000];;

        [_tableView addSubview:separator];
        
        
        
    }
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
    return _addArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AllFuncTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    SDHomeGridItemModel *model = _addArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.titleImage.image = [UIImage imageNamed:model.imageResString];
    cell.selectImage.image = [UIImage imageNamed:@"itemchoice_checked"];
    if(model.ischecked){
        cell.selectImage.image = [UIImage imageNamed:@"itemchoice_checked"];
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"itemchoice_unchecked"];
    }
    //    cell.backView.backgroundColor = [UIColor whiteColor];
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
    SDHomeGridItemModel *model = _addArray[indexPath.row];
    if(model){
        if(model.ischecked){
            model.ischecked=false;
        }else{
            model.ischecked=true;
        }
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self addRightBtn];
}

-(void)addRightBtn{
    if(!_btnRight){
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"sure", @"sure") style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
        rightBar.tintColor=COMMON_RightBar_COLOR;
        self.navigationItem.rightBarButtonItem =rightBar;
    }
}
-(void)buttonClick{
    NSMutableArray *arr1=[NSMutableArray arrayWithArray:_hadArray];
    [_addArray enumerateObjectsUsingBlock:^(SDHomeGridItemModel *model1, NSUInteger idx1, BOOL *stop1) {
        if(model1.ischecked)
            [arr1 addObject:model1] ;
    }];
    self.setNewChangeClock([arr1 copy]);
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
