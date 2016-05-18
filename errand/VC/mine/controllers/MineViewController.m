//
//  MineViewController.m
//  errand
//
//  Created by gravel on 15/12/17.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "MineViewController.h"
#import "ModifyPWViewController.h"
#import "MMAlertView.h"
#import "MMAlertView.h"
#import "MMPopupWindow.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "UserBLL.h"
#import "AppDelegate.h"
#import "AboutUsViewController.h"
#import "ChangePwdViewController.h"

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate , UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 用户头像 */
@property (nonatomic, strong) UIImageView     *headerImage;
/** 用户姓名 */
@property (nonatomic, strong) UILabel         *nameLabel;
/** 用户职位 */
@property (nonatomic, strong) UILabel         *positionLabel;

//显示内存的标签
@property(strong,nonatomic)UILabel *lblCache;

@end

@implementation MineViewController {
    
    UITableView    *_tableView;
    NSMutableArray *_dataArray;
    MineViewController *mine ;
    NSString * _fullPathToFile;
    UIImage *_headImage;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=COMMON_BACK_COLOR;
    self.title=NSLocalizedString(@"my", @"my");
    [self setNavRightBtn];
    [self createTabelView];
 
}

/**
 *  设置 navgationBar 右侧退出按钮
 */
- (void)setNavRightBtn {
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"quit", @"quit") style:UIBarButtonItemStylePlain target:self action:@selector(quitBtnClick:)];
    rightBar.tintColor=COMMON_RightBar_COLOR;
    self.navigationItem.rightBarButtonItem =rightBar;
}
- (void)quitBtnClick:(UIButton*)button{
    
    MMPopupItemHandler block = ^(NSInteger index){
        if(index==1){
            [self showHudInView:[[UIApplication sharedApplication].delegate window] hint:nil];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            UserBLL *userBLL = [[UserBLL alloc]init];
            [userBLL logout:^(int result) {
                
                AppDelegate  *del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                [del login];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user removeObjectForKey:@"userName"];
                [user synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:loginOutNotification object:self userInfo:nil];
                
                [MobClick profileSignOff];
            } username:[user objectForKey:@"userName"]  viewCtrl:self];
        }
    };
    
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeHighlight, block),
      MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                         detail:@"确定要退出吗?"
                                                          items:items];
    [alertView show];

   
}

- (void)createTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _tableView.tableHeaderView = [self createTableViewHeaderView];
    [self.view addSubview:_tableView];
    // 隐藏多余 cell 行
    [self setExtraCellLineHidden:_tableView];
    // 初始化数组
    _dataArray = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"   modifyPW", @"   modifyPW"), NSLocalizedString(@"   clearCache", @"   clearCache"), NSLocalizedString(@"   abountOur", @"   abountOur")]];
    
    SDImageCache *sd=[[SDImageCache alloc] init];
    float size=[sd checkTmpSize];
    NSString *siz=[NSString stringWithFormat:@"%0.2fM",size];
      _lblCache=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-[MyAdapter aDapter:25], 30)];
    _lblCache.textAlignment=NSTextAlignmentRight;
    _lblCache.textColor=COMMON_FONT_BLACK_COLOR;
    _lblCache.font = [UIFont systemFontOfSize:14];
    _lblCache.text=siz;
}
/**

 *  定制 tableview 的 headerview
 *
 *  @return 返回 view
 */
- (UIView *)createTableViewHeaderView {
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    // 头像
    self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, 20, 80, 80)];
    self.headerImage.backgroundColor = [UIColor whiteColor];
    self.headerImage.layer.cornerRadius = 40;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.userInteractionEnabled = YES;
    if ([user objectForKey:@"avatar"]) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"headerImg_default"] options:SDWebImageRetryFailed];
//        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"avatar"]]];

    }else {
        self.headerImage.image = [UIImage imageNamed:@"headerImg_default"];
    }
      [headerView addSubview:self.headerImage];
    
    
    // 通过手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeaderImg)];
//        tapGesture.cancelsTouchesInView = NO;
        [self.headerImage addGestureRecognizer:tapGesture];
    // 姓名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, 110, 300, 20)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    NSInteger position = [[Function userDefaultsObjForKey:@"position"] integerValue];
    self.nameLabel.text = [NSString stringWithFormat:@"%@—%@", [Function userDefaultsObjForKey:@"name"], [ConfigFile positionArray][position]];
    [headerView addSubview:self.nameLabel];
    
    // 职位
    self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, 135, 200, 20)];
    self.positionLabel.textAlignment = NSTextAlignmentCenter;
    self.positionLabel.font = [UIFont systemFontOfSize:18];
    self.positionLabel.text = [Function userDefaultsObjForKey:@"organizationName"];
    [headerView addSubview:self.positionLabel];
    _positionLabel.hidden = YES;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, SCREEN_WIDTH, 0.5)];
    label.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:label];
    
    
    return headerView;
}
- (void)changeHeaderImg{
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                if (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//                    
//                }else{
//                    NSLog(@"不支持摄像头");
//                }
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            case 1://本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                if (imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                }else{
                    NSLog(@"不支持相册");
                }
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    };
    NSArray *items =
    @[MMItemMake(@"照相机", MMItemTypeNormal, block),
      
      MMItemMake(@"本地相簿", MMItemTypeNormal, block)];
    
    
    [[[MMSheetView alloc] initWithTitle:@"请选择来源"
                                  items:items] showWithBlock:nil];

}

//点击取消按钮调用
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _headImage = [self scaleFromImage:image toSize:CGSizeMake(80, 80)];
    
    NSData *imageData = UIImagePNGRepresentation(_headImage);
    
//    [self showHintInView:self.view];
    
    UserBLL *userBLL = [[UserBLL alloc]init];
    [userBLL getQiniuTokenWithData:imageData result:^(int result) {
        [self hideHud];
        [_headerImage setImage:_headImage];
    }  viewCtrl:self];
  
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    if (![user objectForKey:@"avatar"]) {
//        UserBLL *userBll = [[UserBLL alloc]init];
//        [userBll uploadImage:^(int result) {
//           [self hideHud];
//        } data:imageData];
//    }else{
//        _fullPathToFile = [user objectForKey:@"avatar"];
//        UserBLL *userBll = [[UserBLL alloc]init];
//        [userBll updateHeaderImage:^(int result) {
//            [self hideHud];
//            [_headerImage setImage:_headImage];
//        } avatar:_fullPathToFile data:imageData];
//         [self updateHead];
//    }
     [self dismissViewControllerAnimated:YES completion:nil];
    
   
}

#pragma mark 保存图片到document
//- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
//    NSData *imageData = UIImagePNGRepresentation(tempImage);
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    _fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    [imageData writeToFile:_fullPathToFile atomically:NO];
//    
//}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//头像更新
-(void)updateHead{
    
   
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
    cell.textLabel.text = _dataArray[indexPath.item];
    cell.textLabel.textColor = COMMON_FONT_BLACK_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 1) {
        [cell.contentView addSubview:_lblCache];
    }
    // cell 箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.item) {
        case 0: {
//            ModifyPWViewController *modifyPWVC = [[ModifyPWViewController alloc] init];
//            [self.navigationController pushViewController:modifyPWVC animated:YES];
//            NSLog(@"%@", _dataArray[indexPath.item]);
            
            ChangePwdViewController *changePwdCtrl = [[ChangePwdViewController alloc] init];
            [self.navigationController pushViewController:changePwdCtrl animated:YES];
        }
            break;
        case 1: {
//
            MMPopupItemHandler block = ^(NSInteger index){
                if(index==1){
                    SDImageCache *sd=[SDImageCache sharedImageCache];
                    
                    [sd clearMemory];
                    [sd clearDiskOnCompletion:^{
                        float size=[sd checkTmpSize];
                        
                        NSString *siz=[NSString stringWithFormat:@"%0.2fM",size];
                        _lblCache.text=siz;
                    }];
                }
            };

            NSArray *items =
            @[MMItemMake(@"取消", MMItemTypeHighlight, block),
              MMItemMake(@"确定", MMItemTypeHighlight, block)];
            MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                                 detail:@"确定要清除缓存吗?"
                                                                  items:items];
//            alertView.attachedView = self.view;
            [alertView show];
            NSLog(@"%@", _dataArray[indexPath.item]);
        }
            break;
        case 2: {
            AboutUsViewController *aboutUs = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUs animated:YES];
            
            NSLog(@"%@", _dataArray[indexPath.item]);
        }
            break;

        default:
            break;
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
