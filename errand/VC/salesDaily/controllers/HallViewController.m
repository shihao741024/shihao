//
//  salesDailyViewController.m
//  errand
//
//  Created by gravel on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "HallViewController.h"
#import "SalesDailyBll.h"
#import "CommentTableViewCell.h"
#import "HPGrowingTextView.h"
#import "CommentModel.h"
#import "AddRecordVC.h"
#import "DailyHeaderView.h"
#import "SelectStaffViewController.h"
#import "StaffModel.h"
#import "Node.h"
#import "SearchReportVC.h"
#import "TextViewToolbar.h"
//#import "CustomerVisitDetailViewController.h"
#import "VisitRecordDetailViewController.h"

@interface HallViewController ()<SRRefreshDelegate ,UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate>{
    NSMutableArray *dataArray;
    int pageIndex;
    //有透明度的背景
    UIView *_bgView;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SRRefreshView *slimeView;


@end

@implementation HallViewController{
    UIView *_backView;
    
    HPGrowingTextView *_hpTextView;
    
    CGRect keyRect;
    
    UIButton *_sendButton;
    
    UINavigationBar *_navigationBar;
    //用来判断是直接回复日报 还是回复他人的回复
    BOOL hasTid;
    //评论的那个日报
    SalesDailyModel *_commentDailyModel;
    //评论评论的评论
    CommentModel *_commentComentModel;
    //评论的组
    NSInteger commentSection;
    
    NSMutableArray *_staffSelectArray;
    
    NSMutableArray *_departmentSelectArray;
    
    BOOL isSearch;
    
    //用于搜索
    NSNumber *_category;
    NSString *_content;
    NSString *_beginDate;
    NSString *_endDate;
    NSArray *_oids;
    NSArray *_ids;
    NSString *_department;
    NSString *_publisher;
    NSString *_kindStr;
    NSArray *_searchArray;
    
//    TextViewToolbar *_toolbar;
//    CGFloat _keyBoardY;
}

- ( void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITabBarController *tbc = self.tabBarController;
    tbc.navigationController.navigationBar.translucent = NO;
    _navigationBar = tbc.navigationController.navigationBar;
    tbc.title = NSLocalizedString(@"total", @"total");
    [self createRightItems];
    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSUserDefaults *salesDailyData = [NSUserDefaults standardUserDefaults];
    
    if ([salesDailyData objectForKey:@"salesDailyData"]) {
//       SalesDailyModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[salesDailyData objectForKey:@"salesDailyData"]];
//        [dataArray insertObject:model atIndex:0];
//        [_tableView reloadData];
        pageIndex = 1;
        isSearch = NO;
        [self initData];
        [salesDailyData removeObjectForKey:@"salesDailyData"];
    }
    
//    // 禁用 iOS7 返回手势
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // 开启
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

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
    UITabBarController *tbc = self.tabBarController;
    tbc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
}
//右上角的两个button
- (void)addClick{
    AddRecordVC *addRecordVC = [[AddRecordVC alloc]init];
    [self.navigationController pushViewController:addRecordVC animated:YES];
}

- (void)searchClick{
    
    SearchReportVC *vc = [[SearchReportVC alloc]init];
    vc.searchArray = _searchArray;
    [self.navigationController pushViewController:vc animated:YES];
    vc.feedBackHallSearchDataBlock = ^(NSNumber *category,NSString *beginDate,NSString *endDate,NSString *content,NSArray *oids,NSArray *ids,NSString *publisher,NSString *kindStr, NSMutableArray *staffModelArray){
        pageIndex = 0;
        isSearch = YES;
        _category = category;
        _beginDate = beginDate;
        _endDate = endDate;
        _content = content;
        _oids = [NSArray arrayWithArray:oids];
        _ids = [NSArray arrayWithArray:ids];
        
        _publisher = publisher;
        _kindStr = kindStr;
        _searchArray = @[category,beginDate,endDate,content,oids,ids,publisher,kindStr,staffModelArray];
        [self initData];
    };
}

//tbc上的backbutton
- (void)createBackButton
{
    UITabBarController *tbc = self.tabBarController;
    UIImage* img=[UIImage imageNamed:@"title_back.png"];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(leftNavBtnClick) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    tbc.navigationItem.leftBarButtonItem = item;
}
- (void)leftNavBtnClick{
    [_hpTextView resignFirstResponder];
    UITabBarController *tbc = self.tabBarController;
        tbc.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.rdv_tabBarController.tabBarHidden == NO) {
        _navigationBar.translucent = YES;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    [self createBackButton];
    [self createView];
    // Do any additional setup after loading the view.
}

//创建UI
- (void)createView{
  
    _searchArray = [[NSArray alloc]init];
    dataArray=[[NSMutableArray alloc] init];
    _departmentSelectArray = [[NSMutableArray alloc] init];
    _staffSelectArray = [[NSMutableArray alloc] init];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
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

    //是否是搜索的结果
    if (isSearch == 0) {
        [dailyBll getAllStatisticsData:^(NSArray *arr) {
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
        } pageIndex:pageIndex category:@0 viewCtrl:self];//category 暂时传0
    }else{
        [dailyBll getHallSearchData:^(NSArray *arr) {
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
            
        } pageIndex:pageIndex category:_category content:_content beingDate:_beginDate endDate:_endDate oids:_oids ids:_ids viewCtrl:self];
        
    }
   
        
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
    
    if ([[dataArray[indexPath.section]commentsArray] count] == indexPath.row) {
        return 15;
    }else {
        CommentModel *commentModel = [dataArray[indexPath.section]commentsArray][indexPath.row];
        
        NSString *str2;
        if ([commentModel.tname isEqualToString:@""]) {
            str2 = [NSString stringWithFormat:@"%@:%@",commentModel.sname,commentModel.content];
        }else{
            str2 = [NSString stringWithFormat:@"%@回复%@:%@",commentModel.sname,commentModel.tname,commentModel.content];
            
        }
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGSize size = [str2 boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -60-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        return size.height + 7;
    }
    
    
}
//每组有1行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    for (int i = 0; i < dataArray.count; i ++) {
        if (section == i) {
            SalesDailyModel *model = dataArray[section];
            
            if (model.commentsArray.count == 0) {
                return 0;
            }else {
                return model.commentsArray.count+1;
            }
            
        }
    }
    return 0;
}
//有dataArray.count组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return  dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    SalesDailyModel *model = dataArray[section];
    NSString *subStr = [model.content stringByAppendingString:@"\n查看详情拜访"];
    
    CGSize size = [self sizeWithString:subStr font:[UIFont systemFontOfSize:17]  maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
   CGSize size2 = [self sizeWithString:model.sendingPlace font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT)];
    
    //计算collection的高度
    if (model.picArray.count >0 ) {
       float imageWidth = (SCREEN_WIDTH- 70 - 30)/3;
        float collectionHeight;
        if (model.picArray.count %3 == 0) {
            collectionHeight = (imageWidth+10) *(model.picArray.count/3);
        }else{
            collectionHeight = (imageWidth+10) *((model.picArray.count/3)+1);
        }
        return 10+40+size.height+2+10+10+10+size2.height+2+10+30+ collectionHeight ;
    }
    return 10+20+size.height+2+10+10+20+size2.height+2+10+30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//每组头部的view
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DailyHeaderView *headerView = [[DailyHeaderView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    SalesDailyModel *model = dataArray[section];
    [headerView setSalesDailyModel:dataArray[section]];
    //删除评论
    headerView.DailydeleteBtnClickBlock = ^{
        SalesDailyBll *bll = [[SalesDailyBll alloc]init];
        [bll deleteReport:^(int result) {
            [Dialog simpleToast:@"删除成功"];
            [dataArray removeObject:model];
            [_tableView reloadData];
        } reportID:model.ID viewCtrl:self];
    };
    //点击回复
    headerView.replyImgBtnClickBlock = ^{
        [self createSendView:nil];
        hasTid = NO;
        _commentDailyModel = dataArray[section];
        commentSection = section;
    };
    
    [headerView setVisitDetailClick:^(NSString *idStr) {
        [self showVisitDetailCtrl:idStr];
    }];
    
    return headerView;
}

- (void)showVisitDetailCtrl:(NSString *)idStr
{
    VisitRecordDetailViewController *viewCtrl = [[VisitRecordDetailViewController alloc] init];
    viewCtrl.visitID = [NSNumber numberWithInteger:[idStr integerValue]];
    viewCtrl.automaticallyAdjustsScrollViewInsets = NO;
    viewCtrl.edgesForExtendedLayout = UIRectEdgeTop;
    viewCtrl.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController pushViewController:viewCtrl animated:YES];
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footerLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    return footerLabel;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, kWidth-60-15, 0)];
//        cell.selectionStyle = 0;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = COMMON_BACK_COLOR;
        [cell.contentView addSubview:view];
        view.tag = 232534;
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = GDBFont(15);
        [cell.contentView addSubview:label];
        label.tag = 14324;
//        label.backgroundColor = [UIColor cyanColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.left.equalTo(cell.contentView).offset(60);
            make.right.equalTo(cell.contentView).offset(-15);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
    }
    
    
    UIView *view = [cell.contentView viewWithTag:232534];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:14324];
    
    if ([[dataArray[indexPath.section] commentsArray] count] == indexPath.row) {
        cell.userInteractionEnabled = NO;
        label.hidden = YES;
//        view.backgroundColor = [UIColor whiteColor];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-8);
        }];
    }else {
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.left.equalTo(cell.contentView).offset(15);
            make.right.equalTo(cell.contentView).offset(-15);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        cell.userInteractionEnabled = YES;
        label.hidden = NO;
        CommentModel *commentModel = [dataArray[indexPath.section]commentsArray][indexPath.row];
        NSMutableAttributedString *str2;
        if ([commentModel.tname isEqualToString:@""]) {
            str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",commentModel.sname,commentModel.content]];
            [str2 addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, commentModel.sname.length+1)];
        }else{
            str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@:%@",commentModel.sname,commentModel.tname,commentModel.content]];
            [str2 addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, commentModel.sname.length)];
            [str2 addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(commentModel.sname.length+2, commentModel.tname.length+1)];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //    cell.textLabel.attributedText = str2;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        
        label.attributedText = str2;
    }
    
    
    
    //cell de frame
//    NSString *str = [NSString stringWithFormat:@"%@",str2];
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
//    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
//    cell.textLabel.frame = CGRectMake(60, 0, SCREEN_WIDTH - 70, size.height +2);
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    _commentComentModel = [dataArray[indexPath.section] commentsArray][indexPath.row];
    [self createSendView:_commentComentModel.sname];
    hasTid = YES;
    
    _commentDailyModel = dataArray[indexPath.section];
    commentSection = indexPath.section;
}

#pragma mark ----输入框视图
- (void)createSendView:(NSString *)name{
   
    if (_backView == nil) {
        //有透明度的背景
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_bgView];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTap)];
        [_bgView addGestureRecognizer:bgViewTap];
        
        //创建底部 view
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 50, SCREEN_WIDTH, 50)];
        _backView.backgroundColor = [UIColor whiteColor];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_backView];
        
        //@
        UIButton *Atbutton = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
        [Atbutton setImage:[UIImage imageNamed:@"aboutOther"] forState:UIControlStateNormal];
        [_backView addSubview:Atbutton];
        [Atbutton addTarget:self action:@selector(AtbuttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        //输入框
        _hpTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(40 ,5, SCREEN_WIDTH-60-40, 40)];
        _hpTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _hpTextView.backgroundColor = COMMON_BACK_COLOR;
        _hpTextView.delegate = self;
        [_hpTextView setFont:[UIFont systemFontOfSize:17]];
        [_hpTextView becomeFirstResponder];
        _hpTextView.minNumberOfLines = 1;
        _hpTextView.maxNumberOfLines = 3;
        [_backView addSubview:_hpTextView];
        
        //创建发送按钮
        _sendButton  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 5, 50, 40)];
        [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sendButton.backgroundColor = COMMON_BLUE_COLOR;
        [_backView addSubview:_sendButton];
        
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }else{
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_hpTextView becomeFirstResponder];
//        _hpTextView.text = _hpTextViewString;
    }
    
    _hpTextView.text = @"";
    [_departmentSelectArray removeAllObjects];
    [_staffSelectArray removeAllObjects];
    
    if (name) {
        _hpTextView.placeholder = [NSString stringWithFormat:@"回复%@", name];
    }else {
        _hpTextView.placeholder = @"我来说几句";
    }
    
}

- (void)AtbuttonClick{
    SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    _bgView.frame = CGRectZero;
    [_hpTextView resignFirstResponder];
    
    NSMutableArray *staffDicArray = [NSMutableArray array];
    for (StaffModel *model in _staffSelectArray) {
        NSDictionary *dic = @{@"ID": model.ID, @"name": model.staffName};
        [staffDicArray addObject:dic];
    }
    vc.staffDicArray = staffDicArray;

    vc.selectArrayBlock = ^(NSMutableArray *staffSelectArray,NSMutableArray *departmentArray){
         _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_hpTextView becomeFirstResponder];
        [_staffSelectArray removeAllObjects];
        [_departmentSelectArray removeAllObjects];
        
        [staffSelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_staffSelectArray addObject:obj];
        }];
        [departmentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_departmentSelectArray addObject:obj];
        }];

        for (StaffModel *model in staffSelectArray) {
            NSRange staffNameRange = [_hpTextView.text rangeOfString:[NSString stringWithFormat:@"@%@", model.staffName]];
            if (staffNameRange.location == NSNotFound) {
                _hpTextView.text = [NSString stringWithFormat:@"%@ @%@",_hpTextView.text,model.staffName];
            }
            
        }
        for (Node *node in departmentArray) {
            NSRange departmentRange = [_hpTextView.text rangeOfString:[NSString stringWithFormat:@"#%@", node.name]];
            if (departmentRange.location == NSNotFound) {
                _hpTextView.text = [NSString stringWithFormat:@"%@ #%@",_hpTextView.text,node.name];
            }
            
        }
    };
}
////有透明度的背景的点击事件
- (void)bgViewTap{
    [_hpTextView resignFirstResponder];
//    _hpTextViewString = _hpTextView.text;
    _bgView.frame = CGRectZero;
}
#pragma mark --- 发送评论
- (void)sendButtonClick{
    if ( ![_hpTextView.text isEqualToString:@""] ) {
//        _hpTextViewString = _hpTextView.text;
    [_hpTextView resignFirstResponder];
    _bgView.frame = CGRectZero;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        SalesDailyBll *bll = [[SalesDailyBll alloc]init];
        if (hasTid == YES) {
            //回复他人回复的
            [bll createCommentData:^(CommentModel *model) {
                
                SalesDailyModel *dailyModel = dataArray[commentSection];
                dailyModel.acountStr = [NSString stringWithFormat:@"%ld", [dailyModel.acountStr integerValue]+1];
                
                [[dataArray[commentSection] commentsArray] insertObject:model atIndex:0];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:commentSection] withRowAnimation:UITableViewRowAnimationNone];
                [Dialog simpleToast:@"评论成功"];
                _hpTextView.text = @"";
                
                
                [_departmentSelectArray removeAllObjects];
                [_staffSelectArray removeAllObjects];
                
            } sid:[user objectForKey:@"userID"] sname:[user objectForKey:@"name"] tid:_commentComentModel.sid tname:_commentComentModel.sname reportID:_commentDailyModel.ID content:_hpTextView.text selectStaffArray:_staffSelectArray selectDepartmentArray:_departmentSelectArray viewCtrl:self];
        }else{
          
            //是直接回复日报的
            [bll createCommentData:^(CommentModel *model) {
                
                SalesDailyModel *dailyModel = dataArray[commentSection];
                dailyModel.acountStr = [NSString stringWithFormat:@"%ld", [dailyModel.acountStr integerValue]+1];
                
                [[dataArray[commentSection] commentsArray] insertObject:model atIndex:0];

                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:commentSection] withRowAnimation:UITableViewRowAnimationNone];
                
                [Dialog simpleToast:@"评论成功"];
                _hpTextView.text = @"";
                
                
                [_departmentSelectArray removeAllObjects];
                [_staffSelectArray removeAllObjects];
                
            } sid:[user objectForKey:@"userID"] sname:[user objectForKey:@"name"] tid:@-1 tname:@"" reportID:_commentDailyModel.ID content:_hpTextView.text selectStaffArray:_staffSelectArray selectDepartmentArray:_departmentSelectArray viewCtrl:self];
        }
       
    }else{
        [Dialog simpleToast:@"回复不能为空"];
    }
    
}

#pragma mark --- HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
     float changeHeight = height - growingTextView.frame.size.height;
     _backView.frame = CGRectMake(_backView.frame.origin.x, _backView.frame.origin.y- changeHeight, _backView.frame.size.width, _backView.frame.size.height+changeHeight);
//    _sendButton.frame = CGRectMake(_sendButton.frame.origin.x, _sendButton.frame.origin.y + (changeHeight/2), _sendButton.frame.size.width, _sendButton.frame.size.height);
    
}

#pragma mark---- 键盘监听事件
-(void)KeyboardWillHide:(NSNotification *)noti
{
     //在主线程里刷新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        _bgView.frame = CGRectZero;
    });

    _backView.transform = CGAffineTransformIdentity;//回到最初状态
    [_hpTextView resignFirstResponder];
//    [UIView animateWithDuration:0.2 animations:^{
//        _toolbar.center = CGPointMake(_toolbar.center.x, kHeight - _toolbar.frame.size.height/2.0);
//        _tableView.frame = CGRectMake(kFrameX(_tableView), 64, kWidth, kHeight-64-kFrameH(_toolbar));
//    }];
}
-(void)KeyboardWillShow:(NSNotification *)noti
{
    keyRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    _backView.transform = CGAffineTransformMakeTranslation(0, -keyRect.size.height - 100);
    
//    float y = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
//    _keyBoardY = y;
//    [UIView animateWithDuration:0.2 animations:^{
//        _toolbar.center = CGPointMake(_toolbar.center.x, y - _toolbar.frame.size.height/2.0);
//        _tableView.frame = CGRectMake(kFrameX(_tableView), 64-(kHeight-49-kFrameY(_toolbar)), kWidth, kFrameH(_tableView));
//        
//    }];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    __block HallViewController *salesVC = self;
    [_tableView addFooterWithCallback:^{
        pageIndex=pageIndex + 1;
        [salesVC initData];
    }];
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_hpTextView removeFromSuperview];
    [_hpTextView resignFirstResponder];
    _hpTextView.hidden = YES;
    _hpTextView = nil;
    
    [_backView removeFromSuperview];
    _backView.hidden = YES;
    _backView = nil;
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
