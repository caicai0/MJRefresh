//
//  UIScrollView+CAIHRefresh.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CAIHRefreshHeader,CAIHRefreshFooter;
@interface UIScrollView (CAIHRefresh)

/** 下拉刷新控件 */
@property (strong, nonatomic) CAIHRefreshHeader *caih_header;
/** 上拉刷新控件 */
@property (strong, nonatomic) CAIHRefreshFooter *caih_footer;

#pragma mark - other
- (NSInteger)mj_totalDataCount;

@end

NS_ASSUME_NONNULL_END
