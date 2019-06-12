//
//  CAIHRefreshHeader.m
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshHeader.h"

@interface CAIHRefreshHeader()

@property (assign, nonatomic) CGFloat insetLDelta;

@end

@implementation CAIHRefreshHeader

#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    CAIHRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    CAIHRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    // 设置key
    self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    // 设置高度
    self.mj_w = MJRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置X值(当自己的高度发生改变了，肯定要重新调整X值，所以放到placeSubviews方法中设置X值)
    self.mj_x = - self.mj_w - self.ignoredScrollViewContentInsetLeft;
}

- (void)resetInset {
    if (@available(iOS 11.0, *)) {
    } else {
        // 如果 iOS 10 及以下系统在刷新时, push 新的 VC, 等待刷新完成后回来, 会导致顶部 Insets.top 异常, 不能 resetInset, 检查一下这种特殊情况
        if (!self.window) { return; }
    }
    
    // sectionheader停留解决
    CGFloat insetL = - self.scrollView.mj_offsetX > _scrollViewOriginalInset.left ? - self.scrollView.mj_offsetX : _scrollViewOriginalInset.left;
    insetL = insetL > self.mj_w + _scrollViewOriginalInset.left ? self.mj_w + _scrollViewOriginalInset.left : insetL;
    self.scrollView.mj_insetL = insetL;
    
    self.insetLDelta = _scrollViewOriginalInset.left - insetL;
}


- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        [self resetInset];
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.mj_inset;
    
    // 当前的contentOffset
    CGFloat offsetX = self.scrollView.mj_offsetX;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetX = - self.scrollViewOriginalInset.left;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetX > happenOffsetX) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetX = happenOffsetX - self.mj_w;
    CGFloat pullingPercent = (happenOffsetX - offsetX) / self.mj_w;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetX < normal2pullingOffsetX) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetX >= normal2pullingOffsetX) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing) return;
        
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetL += self.insetLDelta;
            
            if (self.endRefreshingAnimateCompletionBlock) {
                self.endRefreshingAnimateCompletionBlock();
            }
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
    } else if (state == MJRefreshStateRefreshing) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(weakSelf) self = weakSelf;
            {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                        CGFloat left = self.scrollViewOriginalInset.left + self.mj_w;
                        // 增加滚动区域top
                        self.scrollView.mj_insetL = left;
                        // 设置滚动位置
                        CGPoint offset = self.scrollView.contentOffset;
                        offset.x = -left;
                        NSLog(@"%@",@(offset));
                        [self.scrollView setContentOffset:offset animated:NO];
                    }
                } completion:^(BOOL finished) {
                    [self executeRefreshingCallback];
                }];
            }
        });
    }
}

#pragma mark - 公共方法
- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}

- (void)setIgnoredScrollViewContentInsetLeft:(CGFloat)ignoredScrollViewContentInsetLeft{
    _ignoredScrollViewContentInsetLeft = ignoredScrollViewContentInsetLeft;
    self.mj_x = - self.mj_h - _ignoredScrollViewContentInsetLeft;
}

@end
