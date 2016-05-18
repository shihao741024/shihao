//
//  AllFuncViewController.m
//  errand
//
//  Created by gravel on 15/12/9.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "AddMoreViewController.h"
#import "AllFuncTableViewCell.h"
#import "ErrandItemBll.h"
#import "SDHomeGridItemModel.h"
#import "RDVTabBarController.h"
@interface AddMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIBarButtonItem *btnRight;
@end

@implementation AddMoreViewController{
    UITableView *_tableView;
     NSArray *_dataArray;
}

@synthesize choicedArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"添加";
       [self createTable];
    [self createData];
    // Do any additional setup after loading the view.
}
-(void)createData{
    _dataArray= [ErrandItemBll getAllItem];
    if(!choicedArr||choicedArr.count==0)
        return;
    [choicedArr enumerateObjectsUsingBlock:^(SDHomeGridItemModel *model1, NSUInteger idx1, BOOL *stop1) {
        model1.ischecked=YES;
        [_dataArray enumerateObjectsUsingBlock:^(SDHomeGridItemModel *model, NSUInteger idx, BOOL *stop) {
            if([model.itemId isEqualToString:model1.itemId])
            {
                model.ischecked=true;
                stop=YES;
            }
        }];
    }];
}
-(void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
-(void)addRightBtn{
    if(!_btnRight){
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"sure", @"sure") style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
        rightBar.tintColor=COMMON_RightBar_COLOR;
        self.navigationItem.rightBarButtonItem =rightBar;
    }
}
-(void)buttonClick{
      NSMutableArray *arr1=[NSMutableArray new];
     [choicedArr enumerateObjectsUsingBlock:^(SDHomeGridItemModel *model1, NSUInteger idx1, BOOL *stop1) {
        if(model1.ischecked)
            [arr1 addObject:model1] ;
     }];
    self.setNewChangeClock([arr1 copy]);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AllFuncTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    SDHomeGridItemModel *model = _dataArray[indexPath.row];
    if(model){
        if(model.ischecked){
            model.ischecked=false;
        }else{
            model.ischecked=true;
        }
        BOOL flag=NO;
        for(SDHomeGridItemModel *model1 in choicedArr){
            if([model1.itemId isEqualToString:model.itemId]){
                if(model1.ischecked){
                    model1.ischecked=false;
                }else{
                    model1.ischecked=true;
                }
                flag=YES;
                break;
            }
        }
        if(!flag){
            NSMutableArray *arr1=[NSMutableArray arrayWithArray:choicedArr];
            SDHomeGridItemModel *mo=[SDHomeGridItemModel new];
            mo.imageResString=model.imageResString;
             mo.title=model.title;
             mo.itemId=model.itemId;
             mo.toClassSeg=model.toClassSeg;
            mo.ischecked=YES;
            [arr1 addObject:mo];
            choicedArr=[arr1 copy];
        }
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self addRightBtn];
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
