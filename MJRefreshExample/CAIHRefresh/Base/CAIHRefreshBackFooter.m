//
//  CAIHRightRefreshBackFooter.m
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshBackFooter.h"

@interface CAIHRefreshBackFooter()

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastRightDelta;

@end

@implementation CAIHRefreshBackFooter
#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self scrollViewContentSizeDidChange:nil];
}

#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 如果正在刷新，直接返回
    if (self.state == MJRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.mj_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetX = self.scrollView.mj_offsetX;
    // 尾部控件刚好出现的offsetX
    CGFloat happenOffsetX = [self happenOffsetX];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetX <= happenOffsetX) return;
    
    CGFloat pullingPercent = (currentOffsetX - happenOffsetX) / self.mj_w;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == MJRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetX = happenOffsetX + self.mj_w;
        
        if (self.state == MJRefreshStateIdle && currentOffsetX > normal2pullingOffsetX) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && currentOffsetX <= normal2pullingOffsetX) {
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

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentWidth = self.scrollView.mj_contentW + self.ignoredScrollViewContentInsetRight;
    // 表格的高度
    CGFloat scrollWidth = self.scrollView.mj_w - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right + self.ignoredScrollViewContentInsetRight;
    // 设置位置和尺寸
    self.mj_x = MAX(contentWidth, scrollWidth);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态来设置属性
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        // 刷新完毕
        if (MJRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.scrollView.mj_insetR -= self.lastRightDelta;
                
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
        }
        
        CGFloat deltaW = [self WidthForContentBreakView];
        // 刚刷新完毕
        if (MJRefreshStateRefreshing == oldState && deltaW > 0 && self.scrollView.mj_totalDataCount != self.lastRefreshCount) {
            self.scrollView.mj_offsetX = self.scrollView.mj_offsetX;
        }
    } else if (state == MJRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.mj_totalDataCount;
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            CGFloat right = self.mj_w + self.scrollViewOriginalInset.right;
            CGFloat deltaW = [self WidthForContentBreakView];
            if (deltaW < 0) { // 如果内容高度小于view的高度
                right -= deltaW;
            }
            self.lastRightDelta = right - self.scrollView.mj_insetR;
            self.scrollView.mj_insetR = right;
            self.scrollView.mj_offsetX = [self happenOffsetX] + self.mj_w;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}
#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)WidthForContentBreakView
{
    CGFloat w = self.scrollView.frame.size.width - self.scrollViewOriginalInset.right - self.scrollViewOriginalInset.left;
    return self.scrollView.contentSize.width - w;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.x
- (CGFloat)happenOffsetX
{
    CGFloat deltaW = [self WidthForContentBreakView];
    if (deltaW > 0) {
        return deltaW - self.scrollViewOriginalInset.left;
    } else {
        return - self.scrollViewOriginalInset.left;
    }
}

@end
