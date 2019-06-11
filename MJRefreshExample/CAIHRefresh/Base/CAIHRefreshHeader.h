//
//  CAIHRefreshHeader.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "CAIHRefreshComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAIHRefreshHeader : CAIHRefreshComponent

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的Left */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetLeft;

@end

NS_ASSUME_NONNULL_END
