//
//  ReportDetailVC.m
//  errand
//
//  Created by gravel on 16/3/9.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "ReportDetailVC.h"
#import "SalesDailyBll.h"
#import "SalesDailyModel.h"
#import "CommentTableViewCell.h"
#import "HPGrowingTextView.h"
#import "CommentModel.h"
#import "AddRecordVC.h"
#import "DailyHeaderView.h"
#import "SelectStaffViewController.h"
#import "StaffModel.h"
#import "Node.h"
#import "CustomerVisitDetailViewController.h"

@interface ReportDetailVC ()<SRRefreshDelegate ,UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate>

@end

@implementation ReportDetailVC{
    UITableView *_tableView;
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
    //有透明度的背景
    UIView *_bgView;
    
    NSMutableArray *_staffSelectArray;
    
    NSMutableArray *_departmentSelectArray;
}
- ( void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    self.title = NSLocalizedString(@"reportDetail", @"reportDetail");
    [self addBackButton];
    [self createView];
    // Do any additional setup after loading the view.
}
//创建UI
- (void)createView{
    _departmentSelectArray = [[NSMutableArray alloc]init];
    _staffSelectArray = [[NSMutableArray alloc]init];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=COMMON_BACK_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets =NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
   
    [self initData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)initData{
    [self showHintInView:self.view];
    SalesDailyBll *dailyBll = [[SalesDailyBll alloc]init];
    [dailyBll getReportDetailData:^(SalesDailyModel *model) {
        _commentDailyModel = model;
          [self hideHud];
        [_tableView reloadData];
    } reportID:_reportID viewCtrl:self];
}

#pragma mark ----- UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_commentDailyModel.commentsArray.count == indexPath.row) {
        return 15;
    }else {
        CommentModel *commentModel = _commentDailyModel.commentsArray[indexPath.row];
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
//每组有n行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (_commentDailyModel.commentsArray.count == 0) {
        return 0;
    }else {
        return _commentDailyModel.commentsArray.count+1;
    }
}
//有1组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_commentDailyModel != nil) {
         return  1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    SalesDailyModel *model = _commentDailyModel;
    CGSize size = [self sizeWithString:model.content font:[UIFont systemFontOfSize:17]  maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
    CGSize size2 = [self sizeWithString:model.sendingPlace font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT)];
    if (model.picArray.count >0 ) {
        float imageWidth = (SCREEN_WIDTH- 70 - 30)/3;
        float collectionHeight;
        if (model.picArray.count %3 == 0) {
            collectionHeight = (imageWidth+10) *(model.picArray.count/3);
        }else{
            collectionHeight = (imageWidth+10) *((model.picArray.count/3)+1);
        }
        return 10+40+size.height+2+10+10 +10+20+size2.height+2+10+30+ collectionHeight ;
    }
    return 10+40+size.height+2+10+10+20+size2.height+2+10+30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//每组头部的view
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DailyHeaderView *headerView = [[DailyHeaderView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setSalesDailyModel:_commentDailyModel];
    //删除评论
    headerView.deleteBtn.hidden = YES;
    headerView.DailydeleteBtnClickBlock = ^{
        NSLog(@"DailydeleteBtnClickBlock");
    };
    //点击回复
    headerView.replyImgBtnClickBlock = ^{
        [self createSendView:nil];
        hasTid = NO;
    };
    [headerView setVisitDetailClick:^(NSString *idStr) {
        [self showVisitDetailCtrl:idStr];
    }];
    return headerView;
    
    
}
- (void)showVisitDetailCtrl:(NSString *)idStr
{
    CustomerVisitDetailViewController *viewCtrl = [[CustomerVisitDetailViewController alloc] init];
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, kWidth-60-15, 0)];
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
    
    if (_commentDailyModel.commentsArray.count == indexPath.row) {
        label.hidden = YES;
        cell.userInteractionEnabled = NO;
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
        
        label.hidden = NO;
        cell.userInteractionEnabled = YES;
        
        CommentModel *commentModel = _commentDailyModel.commentsArray[indexPath.row];
        
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
    _commentComentModel = _commentDailyModel.commentsArray[indexPath.row];
    [self createSendView:_commentComentModel.sname];
    hasTid = YES;
    
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
    NSMutableArray *staffDicArray = [NSMutableArray array];
    for (StaffModel *model in _staffSelectArray) {
        NSDictionary *dic = @{@"ID": model.ID, @"name": model.staffName};
        [staffDicArray addObject:dic];
    }
    vc.staffDicArray = staffDicArray;
    
    [_hpTextView resignFirstResponder];
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
    _bgView.backgroundColor = [UIColor orangeColor];
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
                
                SalesDailyModel *dailyModel = _commentDailyModel;
                dailyModel.acountStr = [NSString stringWithFormat:@"%ld", [dailyModel.acountStr integerValue]+1];
                
                [_commentDailyModel.commentsArray insertObject:model atIndex:0];
                [_tableView reloadData];
                [Dialog simpleToast:@"评论成功"];
                _hpTextView.text = @"";
            } sid:[user objectForKey:@"userID"] sname:[user objectForKey:@"name"] tid:_commentComentModel.sid tname:_commentComentModel.sname reportID:_commentDailyModel.ID content:_hpTextView.text selectStaffArray:_staffSelectArray selectDepartmentArray:_departmentSelectArray viewCtrl:self];
        }else{
            
            //是直接回复日报的
            [bll createCommentData:^(CommentModel *model) {
                
                SalesDailyModel *dailyModel = _commentDailyModel;
                dailyModel.acountStr = [NSString stringWithFormat:@"%ld", [dailyModel.acountStr integerValue]+1];
                
                [_commentDailyModel.commentsArray insertObject:model atIndex:0];
                
                [_tableView reloadData];
                
                [Dialog simpleToast:@"评论成功"];
                _hpTextView.text = @"";
                
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
}
-(void)KeyboardWillShow:(NSNotification *)noti
{
    keyRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    _backView.transform = CGAffineTransformMakeTranslation(0, -keyRect.size.height - 100);
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
