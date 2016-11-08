//
//  FHMarco.h
//  FHKit
//
//  Created by MADAO on 16/8/25.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#ifndef FHMarco_h
#define FHMarco_h

#import <UIKit/UIKit.h>
#import <objc/runtime.h>




















/*==========================================*/
#pragma mark - Font

#define FHFontSystemSize(x) [UIFont systemFontOfSize:x]

#pragma mark - Color

#define FHColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define FHColorWithRGB(r,g,b) FHColorWithRGBA(r,g,b,1.f)
#define FHColorWithHexRGBA(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define FHColorWithHexRGB(hexValue) FHColorWithHexRGBA(hexValue,1)

/*==========================================*/
#pragma mark - WeakSelf

#define WEAKSELF autoreleasepool{} __weak typeof(self) weakSelf = self;

#define WEAK_OBJ(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
*/
/*From YYCategories*/
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


/*==========================================*/
#pragma mark - Image

#define ImageInName(name) [UIImage imageNamed:name]

/*==========================================*/
#pragma mark - Class
#define StrFromClass(aClass) NSStringFromClass([aClass class])
#define NibFromClass(aClass) [UINib nibWithNibName:NSStringFromClass([aClass class]) bundle:nil]

/*==========================================*/
#pragma mark - Log

#ifndef __OPTIMIZE__
# define MYLog(format,...) NSLog((@ "%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define MYLog(...)
#endif

/*==========================================*/
#pragma mark - OSVersionCompile

#define IOSVersion [[UIDevice currentDevice] systemVersion]
#define FHiOS6After floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_0
#define FHiOS7After floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_0
#define FHiOS8After floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_0

/**文字对齐方式*/
#ifdef __IPHONE_6_0
#define FHTextAlignmentCenter NSTextAlignmentCenter
#define FHTextAlignmentLeft NSTextAlignmentLeft
#define FHTextAlignmentRight NSTextAlignmentRight
#else
#define FHTextAlignmentCenter UITextAlignmentCenter
#define FHTextAlignmentLeft UITextAlignmentLeft
#define FHTextAlignmentRight UITextAlignmentRight
#endif

/**文字大小*/
#ifdef __IPHONE_7_0
    #define FHGetTextSize(text,font)  [text length]>0?[text sizeWithAttributes:@{NSFontAttributeName:font}]:CGSizeZero
#else
    #define FHGetTextSize(text,font)  [text length]>0?[text sizeWithFont:font]:CGSizeZero
#endif

/**获取最大的文字大小*/
#if __IPHONE_OS_VERSION_MAX_REQUIRED >= __IPHONE_7_0
#define FHGetMaxTextSize(text,maxSize,font) [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil]
#endif

/*==========================================*/
#pragma mark - GCD

/**
 Returns a dispatch_time delay from now.
 */
/*From YYCategories*/
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}




/*==========================================*/
#pragma mark - Runtime

/**动态获取类的属性*/
#define GET_IVAR_WITH_CLASS(x) NSLog(@"Getting Ivar List In Class:%@================",NSStringFromClass(x));\
unsigned int count1 = 0;\
Ivar *var1 = class_copyIvarList([x class], &count1);\
for (int i = 0 ;i < count1 ;i++) {\
Ivar _var = *(var1 + i);\
NSLog(@"Name:%s----- Type:%s",ivar_getName(_var),ivar_getTypeEncoding(_var));\
}


#endif /* FHMarco_h */
