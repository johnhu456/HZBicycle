//
//  HBHUDManager.m
//  HZBicycle
//
//  Created by MADAO on 16/11/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBHUDManager.h"

static NSString *const kNoBicycleSearchResult = @"当前范围没有搜索到租赁点";
static NSString *const kNoSearchResult = @"没有搜索到结果";
static NSString *const kBadNetwork = @"网络错误，请检查网络";
static NSString *const kMailSettingError = @"请先在手机上设置邮箱";

@implementation HBHUDManager

+ (void)config {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD setRingThickness:10.f];
    [SVProgressHUD setFont:HB_FONT_MEDIUM_SIZE(15)];
    [SVProgressHUD setBackgroundColor:FHColorWithHexRGBA(0x4F6C87,0.5)];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    
    
//    + (void)setRingThickness:(CGFloat)width;                            // default is 2 pt
//    + (void)setRingRadius:(CGFloat)radius;                              // default is 18 pt
//    + (void)setRingNoTextRadius:(CGFloat)radius;                        // default is 24 pt
//    + (void)setCornerRadius:(CGFloat)cornerRadius;                      // default is 14 pt
//    + (void)setFont:(UIFont*)font;                                      // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
//    + (void)setForegroundColor:(UIColor*)color;                         // default is [UIColor blackColor], only used for SVProgressHUDStyleCustom
//    + (void)setBackgroundColor:(UIColor*)color;                         // default is [UIColor whiteColor], only used for SVProgressHUDStyleCustom
//    + (void)setBackgroundLayerColor:(UIColor*)color;                    // default is [UIColor colorWithWhite:0 alpha:0.4], only used for SVProgressHUDMaskTypeCustom
//    + (void)setInfoImage:(UIImage*)image;                               // default is the bundled info image provided by Freepik
//    + (void)setSuccessImage:(UIImage*)image;                            // default is bundled success image from Freepik
//    + (void)setErrorImage:(UIImage*)image;                              // default is bundled error image from Freepik
//    + (void)setViewForExtension:(UIView*)view;                          // default is nil, only used if #define SV_APP_EXTENSIONS is set
//    + (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;     // default is 5.0 seconds
//    + (void)setFadeInAnimationDuration:(NSTimeInterval)duration;        // default is 0.15 seconds
//    + (void)setFadeOutAnimationDuration:(NSTimeInterval)duration;       // default is 0.15 seconds
//    + (void)setMaxSupportedWindowLevel:(UIWindowLevel)windowLevel;      // default is UIWindowLevelNormal
}
+ (void)showBicycleSearchResult {
    [SVProgressHUD showErrorWithStatus:kNoBicycleSearchResult];
}

+ (void)showNoSearchResult {
    [SVProgressHUD showErrorWithStatus:kNoSearchResult];
}

+ (void)showNetworkError {
    [SVProgressHUD showErrorWithStatus:kBadNetwork];
}

+ (void)showMailSettingError {
    [SVProgressHUD showErrorWithStatus:kMailSettingError];
}

+ (void)showWaitProgress {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [SVProgressHUD show];
}

+ (void)dismissWaitProgress {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [SVProgressHUD dismiss];
}
@end
