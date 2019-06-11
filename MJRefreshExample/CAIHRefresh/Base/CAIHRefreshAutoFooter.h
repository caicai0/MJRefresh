//
//  CAIHRefreshAutoFooter.h
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAIHRefreshAutoFooter : CAIHRefreshFooter

/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("请使用triggerAutomaticallyRefreshPercent属性");

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

/** 是否每一次拖拽只发一次请求 */
@property (assign, nonatomic, getter=isOnlyRefreshPerDrag) BOOL onlyRefreshPerDrag;

@end

NS_ASSUME_NONNULL_END
