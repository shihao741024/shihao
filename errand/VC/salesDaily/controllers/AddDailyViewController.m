//
//  AddDailyViewController.m
//  errand
//
//  Created by gravel on 16/2/18.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "AddDailyViewController.h"
#import "PicCollectionViewCell.h"
#import "LocalPhotoViewController.h"
#import "JurisdictionVC.h"
#import "PictureViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "SelectStaffViewController.h"
#import "StaffModel.h"
#import "Node.h"
#import "SalesDailyBll.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface AddDailyViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SelectPhotoDelegate,UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@end

@implementation AddDailyViewController{
    UIScrollView *_bgScrollView;
    //第一个文本框
    UITextView *_contentTextView;
    //第二个文本框 周报 月报的时候用
    UITextView *_contentTextView2;
    //第一个文本框的placeholder
    UILabel *_placeHoderLabel;
    //第二个文本框的placeholder
    UILabel *_placeHoderLabel2;
    UICollectionView *_collectionView;
    //图片的宽度
    float imageWidth;
    //选中的图片
    NSMutableArray *_selectPhotos;
    
    UIButton *_positionBtn;
    
    float collectionHeight;
    
    float picturePosition;
    
    UIView *_bgPositionView;
    
    UITableView *_tableView;
    
    UILabel *_jurisdictionLabel;
    
    AMapLocationManager *_locationManager;
    
    AMapSearchAPI *_search;
    
    //选中的员工
    NSMutableArray *_staffSelectArray;
//    选中的部门
    NSMutableArray *_departmentSelectArray;
  //定位的地址
    NSString *_sendingPlace;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BACK_COLOR;
    
   
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self addBackButton];
    [self createSendNav];
    [self createMainView];
    _sendingPlace = @"";
    // Do any additional setup after loading the view.
}
- (void)createSendNav{
    //标题
     NSArray *titleArray = @[NSLocalizedString(@"dailyRecord", @"dailyRecord"),NSLocalizedString(@"weekRecord", @"weekRecord"),NSLocalizedString(@"monthRecord", @"monthRecord"),NSLocalizedString(@"share", @"share")];
     self.title = titleArray[_type];
    
    //发送的点击事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"send", @"send") style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonClick)];

}

- (void)sendButtonClick{
    
    if (((_type == 0 )|| (_type == 3))&&(_contentTextView.text.length == 0)) {
        [Dialog simpleToast:@"内容不能为空"];
    }else if (((_type == 1 )|| (_type == 2))&&((_contentTextView.text.length == 0)||(_contentTextView2.text.length == 0))){
        [Dialog simpleToast:@"内容不能为空"];
    }else if ([_sendingPlace isEqualToString:@""]){
       [Dialog simpleToast:@"请定位"];
    }
    else{
        [self showHintInView:self.view];
        
        SalesDailyBll *dailyBll = [[SalesDailyBll alloc]init];
        
        NSNumber *open ;
        if ([_jurisdictionLabel.text isEqualToString:@"全公司可见"]) {
            
            open = @2;
            
        }else if ([_jurisdictionLabel.text isEqualToString:@"所在部门和领导可见"]){
            
            open = @1;
        }
        else{
            
            open = @0;
        }
        NSString *content;
        if ((_type == 1)||(_type == 2)) {
            
            content  = [NSString stringWithFormat:@"%@%@%@",_contentTextView.text,@"#ylx#",_contentTextView2.text];
            
        }else{
            
            content = _contentTextView.text;
        }
        
        //如果有图片就先上传七牛
        if (_selectPhotos.count > 0 ) {
            NSMutableArray *imgDataArray = [NSMutableArray array];
            for (ALAsset *asset in _selectPhotos) {
                //获取资源图片的详细资源信息
                ALAssetRepresentation* representation = [asset defaultRepresentation];
                //             直接复制图片的字节数据
                //
//                Byte *buffer = (Byte*)malloc((long)representation.size);
//                NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:(NSUInteger)representation.size error:nil];
//                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                UIImage *fullScreenImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                //压缩图片
                float kCompressionQuality = 0.1;
                NSData *data = UIImageJPEGRepresentation(fullScreenImage, kCompressionQuality);
                
                [imgDataArray addObject:data];
            }
            
            
            [dailyBll getQiniuTokenWithImgArray:imgDataArray successArrBlock:^(NSArray *arr) {
                
                [dailyBll addsalesDailyData:^(SalesDailyModel *model) {
                    
                    [self hideHud];
                    
                    NSData *salesDailyData = [NSKeyedArchiver archivedDataWithRootObject:model];
                    NSUserDefaults *salesDaily = [NSUserDefaults standardUserDefaults];
                    [salesDaily setObject:salesDailyData forKey:@"salesDailyData"];
                    
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -3] animated:YES];
                    
                } content:content selectStaffArray:_staffSelectArray selectDepartmentArray:_departmentSelectArray category:[NSNumber numberWithInt:_type] sendingPlace:_sendingPlace open:open pics:arr viewCtrl:self organization:nil organID:nil];
                
            } viewCtrl:self];
        }else{
            [dailyBll addsalesDailyData:^(SalesDailyModel *model) {
                
                [self hideHud];
                
                NSData *salesDailyData = [NSKeyedArchiver archivedDataWithRootObject:model];
                NSUserDefaults *salesDaily = [NSUserDefaults standardUserDefaults];
                [salesDaily setObject:salesDailyData forKey:@"salesDailyData"];
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
                
            } content:content selectStaffArray:_staffSelectArray selectDepartmentArray:_departmentSelectArray category:[NSNumber numberWithInt:_type] sendingPlace:_sendingPlace open:open pics:[NSArray array] viewCtrl:self organization:nil organID:nil];
            
        }
 
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createMainView{
    
    _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _bgScrollView.backgroundColor = COMMON_BACK_COLOR;
    [self.view addSubview:_bgScrollView];
    _bgScrollView.alwaysBounceVertical = YES;
    _bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
   
    //正文
    if ((_type == 1)||(_type == 2)) {
        UILabel *sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        sumLabel.backgroundColor = COMMON_BACK_COLOR;
        sumLabel.font = [UIFont systemFontOfSize:15];
        sumLabel.textAlignment = NSTextAlignmentLeft;
        [_bgScrollView addSubview:sumLabel];
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 80)];
        _contentTextView.delegate = self;
        _contentTextView.font = [UIFont systemFontOfSize:15];
        [_bgScrollView addSubview:_contentTextView];
        //placeHoder
        _placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 45, SCREEN_WIDTH - 10, 20)];
        _placeHoderLabel.text = @"请输入内容";
        _placeHoderLabel.font = [UIFont systemFontOfSize:15];
        _placeHoderLabel.textColor = COMMON_FONT_GRAY_COLOR;
        [_bgScrollView addSubview:_placeHoderLabel];
        
        UILabel *planLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 40)];
        planLabel.backgroundColor = COMMON_BACK_COLOR;
        if (_type == 1) {
            sumLabel.text = @" * 本周工作总结";
            planLabel.text = @" * 下周工作计划";
        }else{
            sumLabel.text = @" * 本月工作总结";
            planLabel.text = @" * 下月工作计划";
        }

        planLabel.font = [UIFont systemFontOfSize:15];
        planLabel.textAlignment = NSTextAlignmentLeft;
        [_bgScrollView addSubview:planLabel];
        
        _contentTextView2 = [[UITextView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 80)];
        _contentTextView2.delegate = self;
        _contentTextView2.font = [UIFont systemFontOfSize:15];
        [_bgScrollView addSubview:_contentTextView2];
        //placeHoder
        _placeHoderLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 165, SCREEN_WIDTH - 10, 20)];
        _placeHoderLabel2.text = @"请输入内容";
        _placeHoderLabel2.font = [UIFont systemFontOfSize:15];
        _placeHoderLabel2.textColor = COMMON_FONT_GRAY_COLOR;
        [_bgScrollView addSubview:_placeHoderLabel2];
        picturePosition = 255;
        
    }else{
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _contentTextView.delegate = self;
        _contentTextView.font = [UIFont systemFontOfSize:15];
        [_bgScrollView addSubview:_contentTextView];
        //placeHoder
        _placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, 20)];
        _placeHoderLabel.text = @"请输入内容";
        _placeHoderLabel.font = [UIFont systemFontOfSize:15];
        _placeHoderLabel.textColor = COMMON_FONT_GRAY_COLOR;
        [_bgScrollView addSubview:_placeHoderLabel];
        picturePosition = 150;
    }
   
    //放图片
    [self createCollection];
    
}

-(void)createCollection{
     //约束类 进行布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
      imageWidth = (SCREEN_WIDTH-50)/4;
     flowLayout.itemSize = CGSizeMake(imageWidth, imageWidth);
     flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //创建的时候必须用约束类来初始化  高度根据图片的数量来定
    
    if ((_selectPhotos.count+1) %4 == 0) {
        collectionHeight = (imageWidth+10) *((_selectPhotos.count+1)/4);
    }else{
         collectionHeight = (imageWidth+10) *(((_selectPhotos.count+1)/4)+1);
    }
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, picturePosition, SCREEN_WIDTH, collectionHeight) collectionViewLayout:flowLayout];
   
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PicCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_bgScrollView addSubview:_collectionView];
    
    [self createBottom];
    
}

//定位 @ 权限
- (void)createBottom{
    
    if (_bgPositionView == nil) {
        //定位
        CGSize size = [self sizeWithString:@"我的位置" font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, 20)];
       
         _bgPositionView = [[UIView alloc]initWithFrame:CGRectMake(0, picturePosition + collectionHeight, SCREEN_WIDTH, 40)];
         _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, picturePosition + collectionHeight + 40 , SCREEN_WIDTH, (10+44)*2)];
        _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, picturePosition + collectionHeight + 40 + (10+44)*2 + 10);
       
        _bgPositionView.backgroundColor = [UIColor whiteColor];
        [_bgScrollView addSubview:_bgPositionView];
        
        _positionBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, size.width+20, 20)];
        _positionBtn.backgroundColor = [UIColor whiteColor];
        [_positionBtn setImage:[UIImage imageNamed:@"map_icon"] forState:UIControlStateNormal];
        [_positionBtn setImage:[UIImage imageNamed:@"map_icon"] forState:UIControlStateHighlighted];
        [_positionBtn setTitle:@"我的位置" forState:UIControlStateNormal];
        [_positionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_positionBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _positionBtn.contentHorizontalAlignment = NSTextAlignmentLeft;
        _positionBtn.backgroundColor = COMMON_BACK_COLOR;
        _positionBtn.clipsToBounds = YES;
        _positionBtn.layer.cornerRadius = 10;
        [_bgPositionView addSubview:_positionBtn];
        [_positionBtn addTarget:self action:@selector(positionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //@ 和 权限
       
        [_bgScrollView addSubview:_tableView];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=COMMON_BACK_COLOR;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.bounces = NO;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
    }else{
       
            _bgPositionView.frame = CGRectMake(0, picturePosition + collectionHeight, SCREEN_WIDTH, 40);
            _tableView.frame = CGRectMake(0, picturePosition + collectionHeight + 40 , SCREEN_WIDTH, (10+44)*2);
            _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, picturePosition + collectionHeight + 40 +(10+44)*2 + 10);
          }
}

//获取位置
- (void)positionBtnClick{
    // 配置用户KEY
    [self.view endEditing:YES];
    CGSize size = [self sizeWithString:@"定位中..." font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, 20)];
    _positionBtn.frame = CGRectMake(5, 10, size.width+20, 20);
    [_positionBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    
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
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //发起逆地理编码
    [_search AMapReGoecodeSearch:regeoRequest];
    
}
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [_positionBtn setTitle:@"获取失败" forState:UIControlStateNormal];
    [Function alertUserDeniedLocation:error delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LocationErrorAlertTag) {
        [Function isShowSystemLocationSetupPage:buttonIndex];
    }
}

// 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        CGSize size = [self sizeWithString:result font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, 20)];
        if (size.width + 20 < SCREEN_WIDTH - 10) {
            _positionBtn.frame = CGRectMake(5, 10, size.width+20, 20);
        }else{
            _positionBtn.frame = CGRectMake(5, 10, SCREEN_WIDTH - 10, 20) ;
        }
        
        
        [_positionBtn setTitle:result forState:UIControlStateNormal];
        _sendingPlace = result;

//
//          [NSString stringWithFormat:@"%f",request.location.longitude] latitude:[NSString stringWithFormat:@"%f",request.location.latitude] name:result];
//    }
    }
}
#pragma mark --- UICollectionViewDelegate  UICollectionViewDataSource
//返回cell对象的个数
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectPhotos.count +1;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[PicCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        }
    if (indexPath.item < _selectPhotos.count ) {
        
        //获取缩略图
        ALAsset *asset=[_selectPhotos objectAtIndex:indexPath.item];
        CGImageRef posterImageRef=[asset thumbnail];
        UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
        [cell.picImageView setImage:posterImage];
        [cell.deleteBtn setImage:[UIImage imageNamed:@"index_item_detele"] forState:UIControlStateNormal];
    }else{
        
        cell.picImageView.image = [UIImage imageNamed:@"addpic"];
         [cell.deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    //删除图片
   
    cell.deleteBtnClickBlock = ^{
        if (indexPath.item != _selectPhotos.count) {
            [_selectPhotos removeObjectAtIndex:indexPath.item];
            
            //根据图片数量改变collectionview的高度
            if ((_selectPhotos.count+1) %4 == 0) {
                collectionHeight = (imageWidth+10) *((_selectPhotos.count+1)/4);
            }else{
                collectionHeight = (imageWidth+10) *(((_selectPhotos.count+1)/4)+1);
            }
     
            _collectionView.frame = CGRectMake(0, picturePosition, SCREEN_WIDTH, collectionHeight);
            
            [self createBottom];
            
            [_collectionView reloadData];
           } 
        };
    
  //   点击图片 进行放大
    cell.tapClickBlock = ^{
         if (indexPath.item != _selectPhotos.count) {
            
        PictureViewController *vc = [[PictureViewController alloc]init];
        ALAsset *asset =  _selectPhotos[indexPath.item];
             //获取资源图片的详细资源信息
             ALAssetRepresentation* representation = [asset defaultRepresentation];
//             直接复制图片的字节数据
//
//             Byte *buffer = (Byte*)malloc((long)representation.size);
//             NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:(NSUInteger)representation.size error:nil];
//             NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//             vc.image = [UIImage imageWithData:data];
//             //获取资源图片的长宽
//             CGSize dimension = [representation dimensions];
           
              //获取资源图片的高清图   必须有方向和尺寸
//        vc.image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];
             
             //获取资源图片的全屏图
             vc.image = [UIImage imageWithCGImage:[representation fullScreenImage]];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
         }else{
             [self.view endEditing:YES];
             LocalPhotoViewController *pick=[[LocalPhotoViewController alloc] init];
             self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
             pick.selectPhotoDelegate=self;
             pick.selectPhotos= _selectPhotos;
             [self.navigationController pushViewController:pick animated:YES];
         }
    };
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == _selectPhotos.count ) {
//        LocalPhotoViewController *pick=[[LocalPhotoViewController alloc] init];
//        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
//        pick.selectPhotoDelegate=self;
//        pick.selectPhotos= _selectPhotos;
//        [self.navigationController pushViewController:pick animated:YES];
//    }
//    
//}
#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
        
         cell.imageView.image = [UIImage imageNamed:@"aboutOther"];
        
    }else{
      
        cell.imageView.image = [UIImage imageNamed:@"daily_send_fanwei"];
        cell.textLabel.text = @"可见范围";
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        
        _jurisdictionLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150-30, 0 , 150, 44)];
        _jurisdictionLabel.text = @"仅自己和领导可见";
        _jurisdictionLabel.font = [UIFont systemFontOfSize:14];
        _jurisdictionLabel.textColor = [UIColor blackColor];
        _jurisdictionLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_jurisdictionLabel];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        SelectStaffViewController *vc = [[SelectStaffViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSMutableArray *staffDicArray = [NSMutableArray array];
        for (StaffModel *model in _staffSelectArray) {
            NSDictionary *dic = @{@"ID": model.ID, @"name": model.staffName};
            [staffDicArray addObject:dic];
        }
        vc.staffDicArray = staffDicArray;
        
        
        vc.selectArrayBlock = ^(NSMutableArray *staffSelectArray,NSMutableArray *departmentArray){
            
            _staffSelectArray = [NSMutableArray arrayWithArray:staffSelectArray];
            _departmentSelectArray = [NSMutableArray arrayWithArray:departmentArray];
            
             _placeHoderLabel.text = @"";
            
            if (_type == 1 || _type == 2) {
                for (StaffModel *model in staffSelectArray) {
                    
                    NSRange staffNameRange = [_contentTextView2.text rangeOfString:[NSString stringWithFormat:@"@%@", model.staffName]];
                    if (staffNameRange.location == NSNotFound) {
                        _contentTextView2.text = [NSString stringWithFormat:@"%@ @%@",_contentTextView2.text,model.staffName];
                    }
                    
                }
                for (Node *node in departmentArray) {
                    
                    NSRange departmentRange = [_contentTextView2.text rangeOfString:[NSString stringWithFormat:@"#%@", node.name]];
                    if (departmentRange.location == NSNotFound) {
                        _contentTextView2.text = [NSString stringWithFormat:@"%@ #%@",_contentTextView2.text,node.name];
                    }
                    
                }
            }else {
                for (StaffModel *model in staffSelectArray) {
                    NSRange staffNameRange = [_contentTextView.text rangeOfString:[NSString stringWithFormat:@"@%@", model.staffName]];
                    if (staffNameRange.location == NSNotFound) {
                        _contentTextView.text = [NSString stringWithFormat:@"%@ @%@",_contentTextView.text,model.staffName];
                    }
                }
                for (Node *node in departmentArray) {
                    NSRange departmentRange = [_contentTextView.text rangeOfString:[NSString stringWithFormat:@"#%@", node.name]];
                    if (departmentRange.location == NSNotFound) {
                        _contentTextView.text = [NSString stringWithFormat:@"%@ #%@",_contentTextView.text,node.name];
                    }
                }
            }
            
            
            
        };
    }else{
        JurisdictionVC *vc = [[JurisdictionVC alloc]init];
        vc.jurisdictionStr = _jurisdictionLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
        vc.jurisdictionClickBlock = ^(NSString *str){
            _jurisdictionLabel.text = str;
        };
    }
   
}
#pragma mark ---- SelectPhotoDelegate
- (void)getSelectedPhoto:(NSMutableArray *)photos{
    _selectPhotos = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_selectPhotos addObject:obj];
    }];
    
    //根据图片数量改变collectionview的高度
    if ((_selectPhotos.count+1) %4 == 0) {
        collectionHeight = (imageWidth+10) *((_selectPhotos.count+1)/4);
    }else{
        collectionHeight = (imageWidth+10) *(((_selectPhotos.count+1)/4)+1);
    }

    _collectionView.frame = CGRectMake(0, picturePosition, SCREEN_WIDTH, collectionHeight);
    
    [self createBottom];
    
    [_collectionView reloadData];
    
    
}
#pragma mark ---- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (_contentTextView.text.length == 0) {
        _placeHoderLabel.text=@"请输入内容";
        
    }else{
        _placeHoderLabel.text = @"";
       
    }
    if (_contentTextView2.text.length == 0) {
        _placeHoderLabel2.text = @"请输入内容";
    }else{
         _placeHoderLabel2.text = @"";
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
