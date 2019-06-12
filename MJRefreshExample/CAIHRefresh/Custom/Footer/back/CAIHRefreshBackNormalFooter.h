//
//  CAIHRefreshBackNormalFooter.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshBackStateFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAIHRefreshBackNormalFooter : CAIHRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end

NS_ASSUME_NONNULL_END
