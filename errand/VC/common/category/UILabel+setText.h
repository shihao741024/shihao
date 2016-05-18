//
//  UILabel+setText.h
//  test
//
//  Created by 徐祥 on 16/3/17.
//  Copyright © 2016年 徐祥. All rights reserved.
//

/**
 *  注：此类中的image大小为30的正方形，在动态获取字符串长度来确定label长度时不能忽略这30的长度
 */

#import <UIKit/UIKit.h>



@interface UILabel (setText)

- (void)setTextWithString:(NSString *)string;

@end
