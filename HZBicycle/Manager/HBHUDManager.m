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
static NSString *const kNaviCalculateError = @"导航出错啦，请重试";

@implementation HBHUDManager

+ (void)config {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setFont:HB_FONT_MEDIUM_SIZE(15)];
    [SVProgressHUD setBackgroundColor:FHColorWithHexRGBA(0x4F6C87,0.5)];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
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

+ (void)showNaviCalculateError {
    [SVProgressHUD showErrorWithStatus:kNaviCalculateError];
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
