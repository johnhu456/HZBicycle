//
//  HBUserDefultsManager.m
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBUserDefultsManager.h"

NSString *const kSearchDistanceKey = @"kSearchDistanceKey";

@implementation HBUserDefultsManager

#pragma mark - Setter
+ (void)setSearchDistance:(CGFloat)searchDistance {
    [[NSUserDefaults standardUserDefaults] setObject:@(searchDistance) forKey:kSearchDistanceKey];
}

#pragma mark - Getter
+ (CGFloat)searchDistance {
    NSNumber *searchDistance = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchDistanceKey];
    if (searchDistance == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@(800) forKey:kSearchDistanceKey];
        return 800;
    }
    return [searchDistance floatValue];
}
@end
