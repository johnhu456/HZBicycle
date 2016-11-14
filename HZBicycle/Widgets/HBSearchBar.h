//
//  HBSearchBar.h
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBSearchBar;

@protocol HBSearchBarDelegete <NSObject>

/**
 处理searchBar开始编辑

 */
- (void)searchBarDidBeginEdit:(HBSearchBar *)searchBar;

/**
 处理searchBar输入文本变化。
 
 @param text      变化后的文本
 */
- (void)searchBar:(HBSearchBar *)searchBar textDidChanged:(NSString *)text;

/**
 处理searchBar结束编辑

 @param text      编辑结束时文本
 */
- (void)searchBar:(HBSearchBar *)searchBar didFinishEdit:(NSString *)text;

@end

@interface HBSearchBar : UIView

@property (nonatomic, weak) id<HBSearchBarDelegete> delegate;

@end
