//
//  HBUserDefultsManager.m
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBUserDefultsManager.h"
#import "NSDate+FHExtension.h"

//UserDefaultsKey
NSString *const kSearchDistanceKey = @"kSearchDistanceKey";
NSString *const kSearchRecentKey = @"kSearchRecentKey";

//RecentSearchKey
static NSString *const kRecentSearchContent = @"kRecentSearchContent";
static NSString *const kRecentSearchTimestamp = @"kRecentSearchTimestamp";

@implementation HBUserDefultsManager

#pragma mark - Search Distance
//搜索范围

+ (void)setSearchDistance:(CGFloat)searchDistance {
    [[NSUserDefaults standardUserDefaults] setObject:@(searchDistance) forKey:kSearchDistanceKey];
}

+ (CGFloat)searchDistance {
    NSNumber *searchDistance = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchDistanceKey];
    if (searchDistance == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(800) forKey:kSearchDistanceKey];
        return 800;
    }
    return [searchDistance floatValue];
}

#pragma mark - Recent Search
//搜索记录
+ (void)addSearchText:(NSString *)text {
    NSMutableArray *recentSearch = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:kSearchRecentKey];
    //MARK: 好像获取到的都不为nil，那么判断数量吧
    if (recentSearch.count == 0) {
        //没有则新建
        
        //最近搜索对象为字典对象，timestamp为生成时候的时间戳
        recentSearch = [NSMutableArray arrayWithObject:@{
                                                  kRecentSearchContent:text,
                                                  kRecentSearchTimestamp:[NSNumber numberWithLong:[NSDate fh_getTimeStamp]]
                                                  }];
        [[NSUserDefaults standardUserDefaults] setValue:recentSearch forKey:kSearchRecentKey];
    }else {
        //判断是否存在过，存在则更新timestamp
        //MARK: （数据数量少，直接遍历，如果多起来呢？用数据库还是寻找合适方法）
        for (NSDictionary *dic in recentSearch) {
            if ([dic[kRecentSearchContent] isEqualToString:text]) {
                //重复，更新timestamp
#warning directly using kvc, what will happen is unknown
                [dic setValue:[NSNumber numberWithLong:[NSDate fh_getTimeStamp]] forKey:kRecentSearchTimestamp];
            } else {
                [recentSearch addObject:@{kRecentSearchContent:text,
                                          kRecentSearchTimestamp:[NSNumber numberWithLong:[NSDate fh_getTimeStamp]]
                                          }];
            }
        }
    }
}

+ (NSArray *)recentSearchs {
    NSMutableArray *recentSearch = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:kSearchRecentKey];
    if (recentSearch == nil) {
        return recentSearch;
    } else {
        //排序
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kRecentSearchTimestamp ascending:NO];
        return [recentSearch sortedArrayUsingDescriptors:@[descriptor]];
    }
}
@end
