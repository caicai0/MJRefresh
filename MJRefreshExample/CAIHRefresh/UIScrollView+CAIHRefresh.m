//
//  UIScrollView+CAIHRefresh.m
//  MJRefreshExample
//
//  Created by liyufeng on 2019/6/11.
//  Copyright © 2019 小码哥. All rights reserved.
//

#import "UIScrollView+CAIHRefresh.h"
#import "CAIHRefreshHeader.h"
#import "CAIHRefreshFooter.h"
#import <objc/runtime.h>

@implementation UIScrollView (CAIHRefresh)

#pragma mark - header
static const char CAIHRefreshHeaderKey = '\0';
- (void)setCaih_header:(CAIHRefreshHeader *)mj_header
{
    if (mj_header != self.caih_header) {
        // 删除旧的，添加新的
        [self.caih_header removeFromSuperview];
        [self insertSubview:mj_header atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &CAIHRefreshHeaderKey,
                                 mj_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (CAIHRefreshHeader *)caih_header
{
    return objc_getAssociatedObject(self, &CAIHRefreshHeaderKey);
}

#pragma mark - footer
static const char CAIHRefreshFooterKey = '\0';
- (void)setCaih_footer:(CAIHRefreshFooter *)mj_footer
{
    if (mj_footer != self.caih_footer) {
        // 删除旧的，添加新的
        [self.caih_footer removeFromSuperview];
        [self insertSubview:mj_footer atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &CAIHRefreshFooterKey,
                                 mj_footer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (CAIHRefreshFooter *)caih_footer
{
    return objc_getAssociatedObject(self, &CAIHRefreshFooterKey);
}

#pragma mark - other
- (NSInteger)mj_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end
