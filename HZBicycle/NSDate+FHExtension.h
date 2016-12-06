//
//  NSDate+FHExtension.h
//  FHKit
//
//  Created by MADAO on 16/9/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FHExtension)
#pragma mark - Normal 

/**
 Get timestamp using [NSDate date]

 @return long type timestamp
 */
+ (long)fh_getTimeStamp;

#pragma mark - Convert With String
/**
 *  return A string value representing the date;
 *
 *  @param format A string representing the date format
 *                e.g.@"yyyy-MM-dd HH:mm:ss"
 *
 *  @return The result string representing formatted date.
 */
- (NSString *)fh_stringWithFormat:(NSString *)format;
/**
 *  return Date value converted from the stirng
 *
 *  @param string String representing the date
 *  @param format  A string representing the date format
 *                e.g.@"yyyy-MM-dd HH:mm:ss"
 *
 *  @return The result date converted from the stirng
 */
+ (NSDate *)fh_dateWithString:(NSString *)string andFormat:(NSString *)format;

/*-------------------------- Chart of conversion control characters in strp/strf way --------------------------*/
/*  Year(specific)              : %Y                                                                           */
/*  Month                       : %m                                                                           */
/*  Day(In month 0-31)          : %d                                                                           */
/*  Hour(24-hour 00-23)         : %H                                                                           */
/*  Minutes(00-59)              : %M                                                                           */
/*  Seconds(00-60)              : %S                                                                           */
/*----------------------------------------------------Other----------------------------------------------------*/
/*  Year(simplified,00-99)      : %y                                                                           */
/*  Day(In year 001-366)        : %j                                                                           */
/*  Hour(12-hour 01-12)         : %I                                                                           */
/*  Week(1-7)                   : %u                                                                           */
/*  Week(0-6)                   : %w                                                                           */
/*  WeekName(sepcific)          : %A                                                                           */
/*  WeekName(simplified)        : %a                                                                           */
/*  MonthName(sepcific)         : %B                                                                           */
/*  MonthName(simplified)       : %b                                                                           */
/*  AM or PM                    : %p                                                                           */
/*  Date in local               : %x                                                                           */                                                
/*  Time in local               : %X                                                                           */
/*  Locale                      : %Z                                                                           */
/*-----------------------------------------------------END-----------------------------------------------------*/

/**
 Same as the method stringWithFormat: But use strftime function to convert date.
 if you seek for coverting quickly, this method is a good choice.

 @param format A string representing the date format
 *             e.g.@"%Y-%m-%dT%H:%M:%S%z""
 *
 @return The result string representing formatted date.
 */
- (NSString *)fh_strfTimeStringWithFormat:(NSString *)format;
/**
 Same as the methd dateWithString: But use strptime function to covert string.
 if you seek for coverting quickly, this method is a good choice.

 @param formatedString String representing the date
 @param format         A string representing the date format
                       e.g.@"%Y-%m-%dT%H:%M:%S%z"
 
 @return The result date converted from the stirng
 */
+ (NSDate *)fh_strpDateWithFormatString:(NSString *)formatedString inFormat:(NSString *)format;

@end
