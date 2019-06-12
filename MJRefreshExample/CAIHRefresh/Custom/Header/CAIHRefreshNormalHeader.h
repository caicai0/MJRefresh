//
//  CAIHRefreshNormalHeader.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshStateHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAIHRefreshNormalHeader : CAIHRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (weak, nonatomic, readonly) UIActivityIndicatorView *loadingView;


/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle MJRefreshDeprecated("请使用 loadingView 进行设置");

@end

NS_ASSUME_NONNULL_END
