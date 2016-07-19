//
//  DailyHeaderView.m
//  errand
//
//  Created by gravel on 16/3/4.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "DailyHeaderView.h"
#import "CommentPicCollectionViewCell.h"
#import "PictureViewController.h"
@implementation DailyHeaderView{
    //图片的宽度
    float imageWidth;
    //collectview的高度
    float collectionHeight;
    
    SalesDailyModel *_dailyModel;
    
    NSString *_idStr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView{
    self.headImgView = [[UIImageView alloc]init];
    [self addSubview:self.headImgView];
    self.userNameLabel = [self createLabelWithFont:17 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.kindNameLabel = [self createLabelWithFont:15 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentRight];
    self.contentLabel = [self createLabelWithFont:17 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    _contentLabel.hidden = YES;
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.delegate = self;
    _contentTextView.scrollEnabled = NO;
    _contentTextView.editable = NO;
    _contentTextView.font = GDBFont(17);
    _contentTextView.textColor = COMMON_FONT_BLACK_COLOR;
    _contentTextView.layoutManager.allowsNonContiguousLayout = NO;
    [self addSubview:_contentTextView];
    
    
    
    self.dateLabel = [self createLabelWithFont:14 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.phoneModelLabel = [self createLabelWithFont:14 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.addressImgView = [[UIImageView alloc]init];
    [self addSubview:self.addressImgView];
    self.addressLabel = [self createLabelWithFont:15 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.writeImgView = [[UIImageView alloc]init];
    [self addSubview:self.writeImgView];
    self.acountLabel = [self createLabelWithFont:17 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    
    self.replyImgBtn = [[UIButton alloc]init];
    [self addSubview:self.replyImgBtn];
    [self.replyImgBtn addTarget:self action:@selector(replyImgBtnClick) forControlEvents:UIControlEventTouchUpInside];

}
-(void)createCollectionWithArray:(NSArray*)picArray{
    //约束类 进行布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    imageWidth =  (SCREEN_WIDTH- 70 - 30)/3;
    flowLayout.itemSize = CGSizeMake(imageWidth, imageWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    //创建的时候必须用约束类来初始化  高度根据图片的数量来定
    
    if (picArray.count %3 == 0) {
        collectionHeight = (imageWidth+10) *(picArray.count/3);
    }else{
        collectionHeight = (imageWidth+10) *((picArray.count/3)+1);
    }
     _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//    _collectionView.collectionViewLayout = ;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CommentPicCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.height.equalTo(collectionHeight);
        make.width.equalTo(SCREEN_WIDTH - 70);
    }];
    
}

- (NSString *)isVisitRecord:(NSString *)content
{
    
    NSRange range = [content rangeOfString:@"\\*(.+):\\d+\\*" options:NSRegularExpressionSearch];
    
    if (range.location != NSNotFound) {
        NSLog(@"content=%@", [content substringWithRange:range]);
        return [content substringWithRange:range];
    }else {
        return nil;
    }
}

- (void)setSalesDailyModel:(SalesDailyModel *)model{
    _dailyModel = model;
    //如果用户头像存在
    if ([model.headImgStr  isEqual:[NSNull null]]) {
        self.headImgView.image = [UIImage imageNamed:@"headerImg_default"];
    }else{
        
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgStr] placeholderImage:[UIImage imageNamed:@"headerImg_default"]];
    }
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
    self.userNameLabel.text = model.userName;
    
//    if ([model.category intValue] == 4) {
//        
//    }
    if ([self isVisitRecord:model.content]) {
        NSString *visitStr = [self isVisitRecord:model.content];
        NSString *afterStr = [[visitStr componentsSeparatedByString:@":"] objectAtIndex:1];
        NSString *idStr = [afterStr substringToIndex:afterStr.length-1];
        _idStr = idStr;
        NSString *subStr = [model.content stringByReplacingOccurrencesOfString:visitStr withString:@""];
        subStr = [subStr stringByAppendingString:@" 查看详情拜访"];
//        NSRange range = [subStr rangeOfString:@"^(\\s*)\\n" options:NSRegularExpressionSearch];
//        if (range.location != NSNotFound) {
//            subStr = [subStr substringWithRange:range];
//        }
        NSMutableAttributedString *contentAttributed = [[NSMutableAttributedString alloc] initWithString:subStr];
        NSRange detailRange = [subStr rangeOfString:@"查看详情拜访"];
        NSURL *url = [NSURL URLWithString:@"https://www.visitContentClick.com"];
        [contentAttributed addAttribute:NSLinkAttributeName value:url range:detailRange];
        [contentAttributed addAttribute:NSFontAttributeName value:GDBFont(17) range:NSMakeRange(0, contentAttributed.length)];
        
        _contentTextView.attributedText = contentAttributed;
        _contentTextView.hidden = NO;
        _contentLabel.hidden = YES;
    }else {
        _contentTextView.hidden = YES;
        _contentLabel.hidden = NO;
        
        //发表的种类 0 日报 1 周报 2 月报 3 分享
        if ([model.category intValue] == 0) {
            self.kindNameLabel.text = @"日报";
            self.contentLabel.text = model.content;
            
            _contentTextView.text = model.content;
            
            
        }else if ([model.category intValue] == 1){
            self.kindNameLabel.text = @"周报";
            NSMutableAttributedString *contentAttributed = [[NSMutableAttributedString alloc]initWithString:model.content];
            if (model.content.length > 6 ) {
                [contentAttributed addAttribute:NSForegroundColorAttributeName value:COMMON_FONT_GRAY_COLOR range:NSMakeRange(0, 6)];
                NSArray *arr = [model.content componentsSeparatedByString:@"下周计划总结"];
                [contentAttributed addAttribute:NSForegroundColorAttributeName value:COMMON_FONT_GRAY_COLOR range:NSMakeRange([arr[0] length], 6)];
                self.contentLabel.attributedText = contentAttributed;
                
                _contentTextView.attributedText = contentAttributed;
            }else{
                self.contentLabel.text = model.content;
                
                _contentTextView.text = model.content;
            }
            
        }else if ([model.category intValue] == 2){
            self.kindNameLabel.text = @"月报";
            if (model.content.length > 6 ) {
                NSMutableAttributedString *contentAttributed = [[NSMutableAttributedString alloc]initWithString:model.content];
                [contentAttributed addAttribute:NSForegroundColorAttributeName value:COMMON_FONT_GRAY_COLOR range:NSMakeRange(0, 6)];
                NSArray *arr = [model.content componentsSeparatedByString:@"下月计划总结"];
                [contentAttributed addAttribute:NSForegroundColorAttributeName value:COMMON_FONT_GRAY_COLOR range:NSMakeRange([arr[0] length], 6)];
                self.contentLabel.attributedText = contentAttributed;
                
                
                _contentTextView.attributedText = contentAttributed;
            }else{
                self.contentLabel.text = model.content;
                
                _contentTextView.text = model.content;
            }
            
            
        }else{
            self.kindNameLabel.text = @"分享";
            self.contentLabel.text = model.content;
            
            _contentTextView.text = model.content;
        }
        
    }
    
    if (model.picArray.count > 0) {
        [self createCollectionWithArray:model.picArray];
    }

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    //换成今天的24点的YYYYMMddHHmmss 字符串
    NSString *  endString=[NSString stringWithFormat:@"%@%@",[dateformatter stringFromDate:[NSDate date]],@"235959"];
    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
    [dateformatter2 setDateFormat:@"YYYYMMddHHmmss"];
    //把今天24点的字符串换成时间格式
    NSDate *endtDate = [dateformatter2 dateFromString:endString];
    double endSecond = [endtDate timeIntervalSince1970];

    //发表的时间
    double sendSecond = [model.publishedDate doubleValue]/1000;
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:sendSecond];
    NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
    [dateformatter3 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *sendStr = [dateformatter3 stringFromDate:sendDate];

//    暂时没用 看需求需要不
//    long value = endSecond - sendSecond;
//    int day = value / 86400;
     if (endSecond - sendSecond <  86400){
       self.dateLabel.text = [NSString stringWithFormat:@"今天%@",[sendStr substringWithRange:NSMakeRange(11, 5)]];
    }else if (endSecond - sendSecond  < 86400*2 ){
         self.dateLabel.text = [NSString stringWithFormat:@"昨天%@",[sendStr substringWithRange:NSMakeRange(11, 5)]];
    }else if (endSecond - sendSecond < 86400*3){
        self.dateLabel.text = [NSString stringWithFormat:@"前天%@",[sendStr substringWithRange:NSMakeRange(11, 5)]];
    }else{
     self.dateLabel.text = [NSString stringWithFormat:@"%@",[sendStr substringToIndex:16]];
//        NSLog(@"%@",self.dateLabel.text);
    }
    self.phoneModelLabel.text = [NSString stringWithFormat:@"来自%@",model.deviceName] ;
    [self.addressImgView setImage:[UIImage imageNamed:@"location"]];
    self.addressLabel.text = model.sendingPlace;
    self.writeImgView.image = [UIImage imageNamed:@"write"];
    self.acountLabel.text = model.acountStr;
    
    [self.replyImgBtn setImage:[UIImage imageNamed:@"daily_replyImg_comment_normal"] forState:UIControlStateNormal];
    UIView *superView = self;
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(10);
        make.left.equalTo(superView.mas_left).offset(15);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(10);
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.height.equalTo(40);
        make.right.equalTo(self.kindNameLabel.mas_left).offset(-5);
    }];
    [self.kindNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(15);
        make.right.equalTo(superView.mas_right).offset(-10);
        make.height.equalTo(20);
        make.width.equalTo(30);
    }];
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self sizeWithString:model.content font:[UIFont systemFontOfSize:17]  maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView.mas_bottom).offset(0);
        make.width.equalTo(SCREEN_WIDTH - 85);
        make.height.equalTo(size.height+2);
    }];
//    
//    NSString *subStr = [model.content stringByAppendingString:@"\n查看详情拜访"];
//    CGSize size0 = [self sizeWithString:subStr font:[UIFont systemFontOfSize:17]  maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(6);
        make.top.equalTo(self.headImgView.mas_bottom).offset(-8);
        make.width.equalTo(SCREEN_WIDTH - 85);
        make.height.equalTo(size.height+20);
    }];
    
//    _contentTextView.backgroundColor = [UIColor cyanColor];
    //求时间标签的长度
   
    CGSize size1 = [self sizeWithString:self.dateLabel.text  font:[UIFont systemFontOfSize:14                                                                                                                                                                                                                                                                                                                                                                                                             ] maxSize:CGSizeMake(MAXFLOAT, 10)];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //如果有图片 适配要变
        if (model.picArray.count > 0) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        }else{
           make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        }
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.height.equalTo(10);
        make.width.equalTo(size1.width+2);
    }];
    
    [self.phoneModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //如果有图片 适配要变
        if (model.picArray.count > 0) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        }else{
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        }
        make.left.equalTo(self.dateLabel.mas_right).offset(10);
        make.height.equalTo(10);
        make.right.equalTo(superView.mas_right).offset(-10);
    }];
    [self.addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.height.equalTo(20);
        make.width.equalTo(20);
    } ];
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size2 = [self sizeWithString:model.sendingPlace font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT)];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.left.equalTo(self.addressImgView.mas_right).offset(5);
        make.height.equalTo(size2.height+2);
        make.width.equalTo(SCREEN_WIDTH - 100);

    }];
   [self.writeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
       make.left.equalTo(self.headImgView.mas_right).offset(10);
       make.height.equalTo(30);
       make.width.equalTo(30);

   }];
    [self.acountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.left.equalTo(self.writeImgView.mas_right).offset(5);
        make.height.equalTo(30);
        make.width.equalTo(50);
        
    }];
    
    //如果是用户发表的 才能删除
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([model.userID isEqual:[user objectForKey:@"userID"]] ) {
        self.deleteBtn = [[UIButton alloc]init];
        [self addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(DailydeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:COMMON_BLUE_COLOR forState:UIControlStateNormal];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
            make.right.equalTo(self.replyImgBtn.mas_left).offset(-10);
            make.height.equalTo(30);
            make.width.equalTo(40);
        }];
        
        
    }
    [self.replyImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(14);
         make.right.equalTo(superView.mas_right).offset(-10);
        make.height.equalTo(24);
        make.width.equalTo(40);
    }];
    
    if ([model.category isEqual:@4]) {
        self.deleteBtn.hidden = YES;
    }else {
        self.deleteBtn.hidden = NO;
    }
}
- (void)DailydeleteBtnClick{
    
    self.DailydeleteBtnClickBlock();
}
- (void)replyImgBtnClick{
    self.replyImgBtnClickBlock();
}

#pragma mark --- UICollectionViewDelegate  UICollectionViewDataSource
//返回cell对象的个数
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dailyModel.picArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CommentPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CommentPicCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    }
   
    [cell.picImageView sd_setImageWithURL:_dailyModel.picArray[indexPath.item] placeholderImage:[UIImage imageNamed:@"Img_default"]];
    cell.picImageView.tag = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    PictureViewController *vc = [[PictureViewController alloc]init];
//    vc.image = [UIImage imageNamed:@"write"];
//    UIViewController *superviewVC = [self getCurrentVC];
//    [superviewVC.navigationController presentViewController:vc animated:YES completion:nil];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = _dailyModel.picArray.count; // 图片总数
    browser.currentImageIndex =indexPath.item;
    browser.delegate = self;
    [browser show];
   
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    CommentPicCollectionViewCell * cell = (CommentPicCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.picImageView.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return _dailyModel.picArray[index];
}

#pragma mark - 计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return size;
}
//封装的标签
-(UILabel *)createLabelWithFont:(float)size andTextColor:(UIColor *)color andTextAlignment:(NSTextAlignment )alignment{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    [self addSubview:label];
    return label;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    _visitDetailClick(_idStr);
//    [[UIApplication sharedApplication] openURL:URL];
    return NO;
}

@end
