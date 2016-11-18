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

@optional
/**
 处理返回按钮点击事件
 
 */
- (void)searchBar:(HBSearchBar *)searchBar backButtonOnClicked:(UIButton *)sender;

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


/**
 初始化SearchBar类型
 */
typedef NS_ENUM(NSUInteger){
    HBSearchBarShowTypeSearch = 0,//默认显示搜索图标
    HBSearchBarShowTypeBack //返回按钮
}HBSearchBarShowType;

@interface HBSearchBar : UIView

@property (nonatomic, weak) id<HBSearchBarDelegete> delegate;

- (instancetype)initWithShowType:(HBSearchBarShowType)type;
/**
 结束搜索编辑装填

 @param finished 是否调用代理
 */
- (void)resignSearchBarWithFinish:(BOOL)finished;

/**
 呼出键盘
 */
- (void)registerFirstResponder;

/**
 显示返回按钮

 @param animated 是否使用动画
 */
- (void)showBackButtonWithAnimated:(BOOL)animated;

/**
 显示搜索ICON

 @param animated 是否使用动画
 */
- (void)showSearchIconWithAnimated:(BOOL)animated;
@end
