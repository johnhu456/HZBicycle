//
//  HBHUDManager.h
//  HZBicycle
//
//  Created by MADAO on 16/11/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>

@interface HBHUDManager : NSObject

/**
 项目配置
 */
+ (void)config;

/**
 提示没有找到自行车
 */
+ (void)showBicycleSearchResult;

/**
 提示没有搜索结果
 */
+ (void)showNoSearchResult;

/**
 提示网络不好
 */
+ (void)showNetworkError;

/**
 提示设置好邮箱
 */
+ (void)showMailSettingError;

/**
 提示路径规划错误
 */
+ (void)showNaviCalculateError;

/**
 网络加载中
 */
+ (void)showWaitProgress;

/**
 结束加载状态
 */
+ (void)dismissWaitProgress;

@end
