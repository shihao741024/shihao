//
//  CommentModel.h
//  errand
//
//  Created by gravel on 15/12/26.
//  Copyright © 2015年 weishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

//每条评论的id
@property (nonatomic, strong)NSNumber *ID;
//发评论的人
@property (nonatomic, strong)NSString *sname;
@property (nonatomic, strong)NSNumber *sid;
//被评论的人
@property (nonatomic,strong)NSString *tname;
@property (nonatomic, strong)NSNumber *tid;
//评论的内容
@property (nonatomic, strong)NSString *content;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
