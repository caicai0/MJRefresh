//
//  CAIHRefreshGifHeader.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshStateHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAIHRefreshGifHeader : CAIHRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end

NS_ASSUME_NONNULL_END
