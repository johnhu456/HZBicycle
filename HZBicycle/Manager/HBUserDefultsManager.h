//
//  HBUserDefultsManager.h
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HBBicycleResultModel.h"

extern NSString *const kSearchDistanceKey;  //查找范围Key;
extern NSString *const kSearchRecentKey; //最近搜索Key;

extern NSString *const kRecentSearchContent; //搜索内容key
/**
 管理UserDefaults
 */
@interface HBUserDefultsManager : NSObject
#pragma mark - Search Distance
/**
 定位查找范围
 */
+ (void)setSearchDistance:(CGFloat)searchDistance;

+ (CGFloat)searchDistance;

#pragma mark - Recent Search
/**
 添加最近搜索条目

 @param text 搜索内容
 */
+ (void)addSearchText:(NSString *)text;

/**
 最近搜索
 
 @return 最近的搜索记录，String类型
 */
+ (NSArray *)recentSearchs;

/**
 清空最近搜索
 */
+ (void)clearRecentSearchs;

/**
 保存上一次扩展应用的搜索结果记录

 @param result 搜索结果
 */
+ (void)saveLastExtensionSearchWithResult:(HBBicycleResultModel *)result;


/**
 获取上一次扩展应用的搜索结果记录
 */
+ (HBBicycleResultModel *)lastExtensionSearch;

@end
