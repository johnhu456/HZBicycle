//
//  HBUserDefultsManager.m
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBUserDefultsManager.h"
#import "NSDate+FHExtension.h"

#pragma mark - Constant
/*最大搜索条数*/
static NSUInteger const kMaxRecentSearch = 6;

/*Group ID*/
static NSString *const kGroupId = @"group.com.madao.HZBicycle";

//UserDefaultsKey
NSString *const kSearchDistanceKey = @"kSearchDistanceKey";
NSString *const kSearchRecentKey = @"kSearchRecentKey";

//RecentSearchKey
NSString *const kRecentSearchContent = @"kRecentSearchContent";
static NSString *const kRecentSearchTimestamp = @"kRecentSearchTimestamp";
static NSString *const kLastExtensionSearch = @"kLastExtensionSearch";

@implementation HBUserDefultsManager

#pragma mark - Search Distance
//搜索范围

+ (void)setSearchDistance:(CGFloat)searchDistance {
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupId];
    [groupDefaults setObject:@(searchDistance) forKey:kSearchDistanceKey];
}

+ (CGFloat)searchDistance {
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupId];
    NSNumber *searchDistance = [groupDefaults objectForKey:kSearchDistanceKey];
    if (searchDistance == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(800) forKey:kSearchDistanceKey];
        return 800;
    }
    return [searchDistance floatValue];
}

#pragma mark - Recent Search
//搜索记录
+ (void)addSearchText:(NSString *)text {
    if (text.length == 0) {
        return;
    }
    //去除空格
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *recentSearch = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:kSearchRecentKey];
    //MARK: 好像获取到的都不为nil，那么判断数量吧
    if (recentSearch.count == 0) {
        //没有则新建
        
        //最近搜索对象为字典对象，timestamp为生成时候的时间戳
        recentSearch = [NSMutableArray arrayWithObject:@{kRecentSearchContent:text,
                                                         kRecentSearchTimestamp: [NSNumber numberWithLong:[NSDate fh_getTimeStamp]]                                                                                   }];
        [[NSUserDefaults standardUserDefaults] setValue:recentSearch forKey:kSearchRecentKey];
    }else {
        //判断是否存在过，存在则更新timestamp
        //MARK: （数据数量少，直接遍历，如果多起来呢？用数据库还是寻找合适方法）
        NSDictionary *tempDic;
        for (NSMutableDictionary *dic in recentSearch) {
            if ([dic[kRecentSearchContent] isEqualToString:text]) {
                //重复，更新timestamp行不通，重新构建对象
                tempDic = dic;
            }
        }
        [recentSearch removeObject:tempDic];
        [recentSearch addObject:@{kRecentSearchContent:text,
                                   kRecentSearchTimestamp: [NSNumber numberWithLong:[NSDate fh_getTimeStamp]]                                                                                   }];
        if (recentSearch.count > kMaxRecentSearch) {
            //删除多余
            [recentSearch removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, recentSearch.count - kMaxRecentSearch)]];
        }
    }
}

+ (NSArray *)recentSearchs {
    NSMutableArray *recentSearch = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:kSearchRecentKey];
    if (recentSearch.count == 0 ) {
        return recentSearch;
    } else {
        //排序
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kRecentSearchTimestamp ascending:NO];
        return [recentSearch sortedArrayUsingDescriptors:@[descriptor]];
    }
}

+ (void)clearRecentSearchs {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSearchRecentKey];
}

#pragma mark - Extension
+ (void)saveLastExtensionSearchWithResult:(HBBicycleResultModel *)result {
    NSData *resultsData = [result mj_JSONData];
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupId];
    [groupDefaults setValue:resultsData forKey:kLastExtensionSearch];
}

+ (HBBicycleResultModel *)lastExtensionSearch {
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupId];
    NSData *data = [groupDefaults valueForKey:kLastExtensionSearch];
    return [HBBicycleResultModel mj_objectWithKeyValues:data];
}
@end
