//
//  CommentTableViewCell.m
//  errand
//
//  Created by gravel on 15/12/24.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell{
    UILabel *userLabel;
    UILabel *commentLabel;
    UILabel *userLabel2;
    UILabel *commentLabel2;
    UILabel *moreLabel;
    UILabel *colorLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
- (void)createCell{
    
    self.headImgView = [[UIImageView alloc]init];
    [self addSubview:self.headImgView];
    self.userNameLabel = [self createLabelWithFont:17 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.kindNameLabel = [self createLabelWithFont:15 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentRight];
    self.contentLabel = [self createLabelWithFont:17 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    self.dateLabel = [self createLabelWithFont:14 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];
    self.phoneModelLabel = [self createLabelWithFont:14 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];
    self.addressImgView = [[UIImageView alloc]init];
    [self addSubview:self.addressImgView];
    self.addressLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];
    self.writeImgView = [[AmotButton alloc]init];
    [self addSubview:self.writeImgView];
    self.acountLabel = [self createLabelWithFont:15 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentLeft];
    self.sanJiaoImgView = [[UIImageView alloc]init];
    [self addSubview:self.sanJiaoImgView];
    
    //pinglun bufen
   userLabel = [self createLabelWithFont:15 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:userLabel];
    commentLabel = [self createLabelWithFont:15 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    
    [self addSubview:commentLabel];
    commentLabel.numberOfLines = 0;
    commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    userLabel2 = [self createLabelWithFont:15 andTextColor:COMMON_BLUE_COLOR andTextAlignment:NSTextAlignmentLeft];
   
    [self addSubview:userLabel2];
    commentLabel2 = [self createLabelWithFont:15 andTextColor:[UIColor blackColor] andTextAlignment:NSTextAlignmentLeft];
    [self addSubview:commentLabel2];
    commentLabel2.numberOfLines = 0;
    commentLabel2.lineBreakMode = NSLineBreakByCharWrapping;
    
    moreLabel = [self createLabelWithFont:30 andTextColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentCenter];
       [self addSubview:moreLabel];
    colorLabel = [[UILabel alloc]init];
    colorLabel.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    [self addSubview:colorLabel];
    
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
   
    
}
//
//- (void)setSalesDailyModel:(SalesDailyModel *)model{
//    //如果用户头像存在
//    if ([model.headImgStr  isEqual:[NSNull null]]) {
//        self.headImgView.backgroundColor = COMMON_FONT_GRAY_COLOR;
//    }else{
//        self.headImgView.backgroundColor = COMMON_FONT_GRAY_COLOR;
//        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgStr] placeholderImage:nil];
//    }
//    self.headImgView.layer.cornerRadius = 20;
//    self.headImgView.layer.masksToBounds = YES;
//    self.userNameLabel.text = model.userName;
//    self.kindNameLabel.text = model.kindName;
//    self.contentLabel.text = model.contentStr;
//    
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYYMMdd"];
//    //换成今天的24点的YYYYMMddHHmmss 字符串
//    NSString *  endString=[NSString stringWithFormat:@"%@%@",[dateformatter stringFromDate:[NSDate date]],@"235959"];
//    NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
//    [dateformatter2 setDateFormat:@"YYYYMMddHHmmss"];
//    //    把今天24点的字符串换成时间格式
//    NSDate *endtDate = [dateformatter2 dateFromString:endString];
//    double endSecond = [endtDate timeIntervalSince1970];
//    
//    //发表的时间
//    double sendSecond = [model.dateStr doubleValue]/1000;
//    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:sendSecond];
//    NSDateFormatter  *dateformatter3=[[NSDateFormatter alloc] init];
//    [dateformatter3 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *sendStr = [dateformatter3 stringFromDate:sendDate];
//    
////    暂时没用 看需求需要不
////    long value = endSecond - sendSecond;
////    int day = value / 86400;
//     if (endSecond - sendSecond <  86400){
//       self.dateLabel.text = [NSString stringWithFormat:@"今天%@",[sendStr substringWithRange:NSMakeRange(11, 5)]];
//    }else if (endSecond - sendSecond  < 86400*2 ){
//         self.dateLabel.text = [NSString stringWithFormat:@"昨天%@",[sendStr substringWithRange:NSMakeRange(11, 5)]];
//    }else if (endSecond - sendSecond < 86400*3){
//        self.dateLabel.text = [NSString stringWithFormat:@"前天%@",[sendStr substringWithRange:NSMakeRange(11, 5)]];
//    }else{
//     self.dateLabel.text = [NSString stringWithFormat:@"%@",[sendStr substringToIndex:16]];
//        NSLog(@"%@",self.dateLabel.text);
//    }
//
////
//    self.phoneModelLabel.text = [NSString stringWithFormat:@"来自%@",model.phoneModelStr] ;
////    [self.addressImgView sd_setImageWithURL:[NSURL URLWithString:@"http://hcroad.hicp.net:8888/f001.jpg"]];
//    [self.addressImgView setImage:[UIImage imageNamed:@"location"]];
//    self.addressLabel.text = model.addressStr;
//    [self.writeImgView setBackgroundImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
//    [self.writeImgView addTarget:self action:@selector(writeClick) forControlEvents:UIControlEventTouchUpInside];
//    self.acountLabel.text = model.acountStr;
//    [self.sanJiaoImgView setImage:[UIImage imageNamed:@"sanJiao"]];
//  
//    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        CGSize size = [self sizeWithString:model.contentStr font:[UIFont systemFontOfSize:17]   maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headImgView.mas_right).offset(10);
//        make.top.equalTo(self.headImgView.mas_bottom).offset(0);
//        make.width.equalTo(SCREEN_WIDTH - 85);
//        make.height.equalTo(size.height+2);
//    }];
//    CGSize size1 = [self sizeWithString:self.dateLabel.text  font:[UIFont systemFontOfSize:14                                                                                                                                                                                                                                                                                                                                                                                                             ] maxSize:CGSizeMake(MAXFLOAT, 10)];
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.headImgView.mas_right).offset(10);
//        make.height.equalTo(10);
//        make.width.equalTo(size1.width+2);
//    }];
//    [self.phoneModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.dateLabel.mas_right).offset(10);
//        make.height.equalTo(10);
//        make.width.equalTo(100);
//    }];
//    [self.addressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.headImgView.mas_right).offset(10);
//        make.height.equalTo(20);
//        make.width.equalTo(20);
//    } ];
////    self.addressLabel.numberOfLines = 0;
////    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize size2 = [self sizeWithString:model.addressStr font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT)];
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.addressImgView.mas_right).offset(5);
//        make.height.equalTo(size2.height+5);
//        make.width.equalTo(SCREEN_WIDTH - 100);
//        
//    }];
//    [self.writeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.headImgView.mas_right).offset(10);
//        make.width.equalTo(30);
//        make.height.equalTo(30);
//    }];
//    [self.acountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.writeImgView.mas_right).offset(5);
//        make.width.equalTo(30);
//        make.height.equalTo(30);
//    }];
//    if ([model.acountStr intValue] != 0) {
//        [self.sanJiaoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.writeImgView.mas_bottom).offset(10);
//            make.left.equalTo(self.headImgView.mas_right).offset(20);
//            make.width.equalTo(16);
//            make.height.equalTo(10);
//        }];
//    }
//    switch ([model.acountStr intValue]) {
//        case 0:
//            
//            break;
//        case 1:{
//            UIView *footerView = [[UIView alloc]init];
//            footerView.backgroundColor = [UIColor colorWithWhite:0.965 alpha:1.000];
//            [self addSubview:footerView];
//            [self sendSubviewToBack:footerView];
//            CGSize size2 = [self sizeWithString:[NSString stringWithFormat:@"%@:%@",[model.commentsArray[0] userName],[model.commentsArray[0] commentStr]] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
//            [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_sanJiaoImgView.mas_bottom).offset(5);
//                make.left.equalTo(self.headImgView.mas_right).offset(10);
//                make.height.equalTo(size2.height+2);
//                make.width.equalTo(SCREEN_WIDTH - 85);
//            }];
//            NSString *string = [NSString stringWithFormat:@"%@:%@",[model.commentsArray[0] userName],[model.commentsArray[0] commentStr]];
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
//            [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, [[NSString stringWithFormat:@"%@:",[model.commentsArray[0] name]] length])];
//            commentLabel.attributedText = str;
//            [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(10);
//                make.bottom.equalTo(self.mas_bottom).equalTo(0);
//                make.width.equalTo(SCREEN_WIDTH);
//                make.left.equalTo(self.mas_left).offset(0);
//            }];
//            [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.sanJiaoImgView.mas_bottom).offset(0);
//                make.bottom.equalTo(colorLabel.mas_top).offset(0);
//                make.left.equalTo(self.mas_left).offset(0);
//                make.width.width.equalTo(SCREEN_WIDTH);
//            }];
//        }
//            
//            break;
//            
//        default:{
//            UIView *footerView = [[UIView alloc]init];
//            footerView.backgroundColor = [UIColor colorWithWhite:0.965 alpha:1.000];
//            [self addSubview:footerView];
//            [self sendSubviewToBack:footerView];
//            moreLabel.text = @"...";
//            CGSize size2 = [self sizeWithString:[NSString stringWithFormat:@"%@:%@",[model.commentsArray[0] userName],[model.commentsArray[0] commentStr]] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
//            [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_sanJiaoImgView.mas_bottom).offset(5);
//                make.left.equalTo(self.headImgView.mas_right).offset(10);
//                make.height.equalTo(size2.height+2);
//                make.width.equalTo(SCREEN_WIDTH - 85);
//            }];
//            NSString *string = [NSString stringWithFormat:@"%@:%@",[model.commentsArray[0] userName],[model.commentsArray[0] commentStr]];
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
//            [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, [[NSString stringWithFormat:@"%@:",[model.commentsArray[0] userName]] length])];
//            commentLabel.attributedText = str;
//    
//            CGSize size4 = [self sizeWithString:[NSString stringWithFormat:@"%@:%@",[model.commentsArray[1] userName],[model.commentsArray[1] commentStr]] font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 85, MAXFLOAT)];
//            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",[model.commentsArray[0] userName],[model.commentsArray[0] commentStr]]];
//            [str2 addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, [[NSString stringWithFormat:@"%@:",[model.commentsArray[0] userName]] length])];
//            commentLabel2.attributedText = str2;
//            [commentLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(commentLabel.mas_bottom).offset(5);
//                make.left.equalTo(self.headImgView.mas_right).offset(10);
//                make.height.equalTo(size4.height+2);
//                make.width.equalTo(SCREEN_WIDTH - 85);
//                
//            }];
//            [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self);
//                make.top.equalTo(commentLabel2.mas_bottom).offset(-5);
//                make.width.equalTo(50);
//                make.height.equalTo(25);
//            }];
//            [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(10);
//                make.bottom.equalTo(self.mas_bottom).equalTo(0);
//                make.width.equalTo(SCREEN_WIDTH);
//                make.left.equalTo(self.mas_left).offset(0);
//            }];
//            [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.sanJiaoImgView.mas_bottom).offset(0);
//                make.bottom.equalTo(colorLabel.mas_top).offset(0);
//                make.left.equalTo(self.mas_left).offset(0);
//                make.width.width.equalTo(SCREEN_WIDTH);
//            }];
//       
//        }
//            break;
//    }
//
//    
//}
- (void)writeClick{
    self.writeBlock();
}
#pragma mark - 计算动态高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
