//
//  HBUserDefultsManager.h
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSearchDistanceKey;  //查找范围Key;
/**
 管理UserDefaults
 */
@interface HBUserDefultsManager : NSObject

/**
 定位查找范围
 */
+ (void)setSearchDistance:(CGFloat)searchDistance;

+ (CGFloat)searchDistance;
@end
