//
//  CommentMeTableViewCell.m
//  errand
//
//  Created by gravel on 16/3/8.
//  Copyright © 2016年 weishi. All rights reserved.
//

#import "CommentMeTableViewCell.h"

@implementation CommentMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (void)createCell{
    self.headImgView = [[UIImageView alloc]init];
    [self addSubview:self.headImgView];
    self.titleLabel = [self createLabelWithFont:16 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.dateLabel = [self createLabelWithFont:14 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.commentLabel = [self createLabelWithFont:16 andTextColor:COMMON_FONT_BLACK_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.baseContentLabel = [self createLabelWithFont:16 andTextColor:COMMON_FONT_GRAY_COLOR andTextAlignment:NSTextAlignmentLeft];
    self.bottomLabel = [[UILabel alloc]init];
    [self addSubview:self.bottomLabel];
}

- (void)setCommentMeModel:(CommentMeModel *)model{
    
    //如果用户头像存在
    if ([model.headImgStr  isEqual:[NSNull null]]) {
        self.headImgView.image = [UIImage imageNamed:@"headerImg_default"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgStr] placeholderImage:[UIImage imageNamed:@"headerImg_default"]];
    }
    self.headImgView.layer.cornerRadius = 20;
    self.headImgView.layer.masksToBounds = YES;
   
    //发表的种类 0 日报 1 周报 2 月报 3 分享
     NSString *title ;
    if ([model.category intValue] == 0) {
        title = [NSString stringWithFormat:@"%@评论了%@的%@", model.sname,model.baseName,@"日报"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, model.sname.length)];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(model.sname.length + 3, model.baseName.length)];
       self.titleLabel.attributedText = str;
    }else if ([model.category intValue] == 1){
       title = [NSString stringWithFormat:@"%@评论%@的%@", model.sname,model.baseName,@"周报"];
    
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, model.sname.length)];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(model.sname.length + 3, model.baseName.length)];
        self.titleLabel.attributedText = str;
    }else if ([model.category intValue] == 2){
       title = [NSString stringWithFormat:@"%@评论%@的%@", model.sname,model.baseName,@"月报"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, model.sname.length)];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(model.sname.length + 3, model.baseName.length)];
        self.titleLabel.attributedText = str;
    }else{
       title = [NSString stringWithFormat:@"%@评论%@的%@", model.sname,model.baseName,@"分享"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, model.sname.length)];
        [str addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(model.sname.length + 3, model.baseName.length)];
        self.titleLabel.attributedText = str;
    }
    
    self.commentLabel.text = model.content;
    
    
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
    double sendSecond = [model.createDate doubleValue]/1000;
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
    }
  
    NSString *baseContent = [NSString stringWithFormat:@"%@:%@",model.sname,model.baseContent];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:baseContent];
        [str2 addAttribute:NSForegroundColorAttributeName value:COMMON_BLUE_COLOR range:NSMakeRange(0, model.sname.length+1)];
    
    _baseContentLabel.attributedText = str2;
    _baseContentLabel.backgroundColor = COMMON_BACK_COLOR;
    
    self.bottomLabel.backgroundColor = COMMON_BACK_COLOR;
    
    //适配
    self.headImgView.frame = CGRectMake(10, 10, 40, 40);
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.frame = CGRectMake(60, 10, SCREEN_WIDTH - 70, 40);

    self.dateLabel.frame = CGRectMake(60, 55, SCREEN_WIDTH - 70, 10);

    CGSize size = [self sizeWithString:model.content font:[UIFont systemFontOfSize:16]  maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    self.commentLabel.frame = CGRectMake(10, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height + 5, SCREEN_WIDTH - 20, size.height + 2);


    self.baseContentLabel.numberOfLines = 0;
    self.baseContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size2 = [self sizeWithString:baseContent font:[UIFont systemFontOfSize:16]  maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    self.baseContentLabel.frame = CGRectMake(10, self.commentLabel.frame.origin.y + size.height + 2 + 5, SCREEN_WIDTH - 20, size2.height + 20);
    
    self.bottomLabel.frame = CGRectMake(0, self.commentLabel.frame.origin.y + size.height + 2 + 5 + size2.height + 20 +10 , SCREEN_WIDTH, 10);
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
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
