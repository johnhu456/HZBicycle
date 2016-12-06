//
//  NSDate+FHExtension.m
//  FHKit
//
//  Created by MADAO on 16/9/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "NSDate+FHExtension.h"
#import <xlocale.h>

@implementation NSDate (FHExtension)

#pragma mark - Normal
+ (long)fh_getTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}

#pragma mark - Convert With String

- (NSString *)fh_stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)fh_dateWithString:(NSString *)string andFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return [dateFormatter dateFromString:string];
}

- (NSString *)fh_strfTimeStringWithFormat:(NSString *)format {
    const char *aCstr = [format cStringUsingEncoding:NSNonLossyASCIIStringEncoding];
    struct tm time;
    char buffer[80];
    //Time -> String :strftime
    time_t timeInterval = [self timeIntervalSince1970];
    time = *(localtime(&timeInterval));
    strftime_l(buffer, sizeof(buffer), aCstr, &time, NULL);
    return [NSString stringWithCString:buffer encoding:NSNonLossyASCIIStringEncoding];
}

+ (NSDate *)fh_strpDateWithFormatString:(NSString *)formatedString inFormat:(NSString *)format {
    struct tm time;
    time_t timeInterval;
    
    //String -> Time : strptime
    strptime_l([formatedString cStringUsingEncoding:NSASCIIStringEncoding], [format cStringUsingEncoding:NSASCIIStringEncoding], &time, NULL);
    
    timeInterval = mktime(&time);
    NSDate *standardDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeInterval localTimeInterval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:standardDate];
    return [standardDate dateByAddingTimeInterval:localTimeInterval];
}
@end
