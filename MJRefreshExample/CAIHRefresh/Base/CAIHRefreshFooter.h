//
//  CAIHRefreshFooter.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "CAIHRefreshComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAIHRefreshFooter : CAIHRefreshComponent

/** 创建footer */
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建footer */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)endRefreshingWithNoMoreData;

/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 忽略多少scrollView的contentInset的right */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetRight;

@end

NS_ASSUME_NONNULL_END
