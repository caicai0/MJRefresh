//
//  CAIHRefreshComponent.m
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "CAIHRefreshComponent.h"

@interface MJRefreshComponent()

- (void)removeObservers;
- (void)addObservers;

@end

@implementation CAIHRefreshComponent

//重写 而且不调用super方法
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        
        // 设置宽度
        self.mj_h = _scrollView.mj_h;
        // 设置位置
        self.mj_y = -_scrollView.mj_insetT;
        
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceHorizontal = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.mj_inset;
        // 添加监听
        [self addObservers];
    }
}

@end
