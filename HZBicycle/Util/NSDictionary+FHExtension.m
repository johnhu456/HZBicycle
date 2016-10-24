//
//  NSDictionary+FHExtension.m
//  FHKit
//
//  Created by MADAO on 16/8/30.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "NSDictionary+FHExtension.h"

@implementation NSDictionary (FHExtension)

+ (NSDictionary *)fh_dictionaryWithData:(NSData *)data;
{
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        return result;
    }
    return nil;
}

@end

@implementation NSMutableDictionary (FHExtension)

- (void)setObjectOrNil:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == nil) {
        return ;
    }else{
        [self setObject:anObject forKey:aKey];
    }
}

@end
