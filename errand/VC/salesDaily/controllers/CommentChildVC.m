//
//  CommentChildVC.m
//  errand
//
//  Created by gravel on 16/3/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CommentChildVC.h"
#import "SalesDailyBll.h"
#import "CommentMeTableViewCell.h"
#import "CommentMeModel.h"
#import "ReportDetailVC.h"
@interface CommentChildVC ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>


@end

@implementation CommentChildVC{
    NSMutableArray *dataArray;
    UITableView *_tableView;
    int pageIndex;
    SRRefreshView *_slimeView;
    
    NSMutableArray *_staffSelectArray;
    
    NSMutableArray *_departmentSelectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    [self createView];
    // Do any additional setup after loading the view.
}
//创建UI
- (void)createView{
    dataArray=[[NSMutableArray alloc] init];
    _staffSelectArray = [[NSMutableArray alloc]init];
    _departmentSelectArray = [[NSMutableArray alloc]init];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT-64-49-40 ) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
//    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self createSlime];
    [self createMJ];
    [self initData];
    
    
}

//请求数据
- (void)initData{
    
    if(!pageIndex){
        [self showHintInView:self.view];
        pageIndex=1;
        
    }else if(pageIndex==1){
        
        [self showInfica];
    }else{
        [self showInfica];
    }
    SalesDailyBll *dailyBll = [[SalesDailyBll alloc]init];
    [dailyBll getCommentmeData:^(NSArray *arr) {
        
        if(pageIndex==1){
            
            [dataArray removeAllObjects];
        }
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataArray addObject:obj];
        }];
        [_tableView reloadData];
        [self hideHud];
        [_slimeView endRefresh];
        [_tableView footerEndRefreshing];
        
    } pageIndex:pageIndex type:_type viewCtrl:self];
    
}
//创建下拉刷新
-(void)createSlime{
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset =0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor grayColor];
    _slimeView.slime.skinColor = [UIColor grayColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor grayColor];
    
    [_tableView addSubview:_slimeView];
}

#pragma mark ----- UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentMeModel *model = dataArray[indexPath.row];
     NSString *baseContent = [NSString stringWithFormat:@"%@:%@",model.sname,model.baseContent];
     CGSize size = [self sizeWithString:model.content font:[UIFont systemFontOfSize:16]  maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    CGSize size2 = [self sizeWithString:baseContent font:[UIFont systemFontOfSize:16]  maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    return 10 + 40+ 5 + 10 +5 +size.height +2 +5 + size2.height + 20 +10 + 10 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CommentMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CommentMeModel *commentModel = dataArray[indexPath.row];
    [cell setCommentMeModel:commentModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReportDetailVC *reportDetailVC = [[ReportDetailVC alloc]init];
    CommentMeModel *commentModel = dataArray[indexPath.row];
    reportDetailVC.reportID = commentModel.baseID;
    reportDetailVC.automaticallyAdjustsScrollViewInsets = NO;
    reportDetailVC.edgesForExtendedLayout = UIRectEdgeTop;
    reportDetailVC.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController pushViewController:reportDetailVC animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    pageIndex=1;
    [self initData];
}

#pragma mark 上拉加载
-(void)createMJ{
    __block  CommentChildVC *salesVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [salesVC initData];
    }];
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
