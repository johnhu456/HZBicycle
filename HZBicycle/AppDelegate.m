//
//  AppDelegate.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "AppDelegate.h"
#import "MainBicycleViewController.h"
#import "HBBicycleNavigationController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

static NSString *const kAMapAppKey = @"46e4a0f82fe002fffd0cf4391f2b5cc9";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册高德地图
    [AMapServices sharedServices].apiKey = kAMapAppKey;
    //改用Https
#warning enable https after 2017.1.1
//    [[AMapServices sharedServices] setEnableHTTPS:YES]; 暂时不开启：http://lbs.amap.com/api/ios-navi-sdk/guide/create-project/https-guide/#enable-https
    
    //初始化请求中心
    [HBRequestManager config];
    //初始化下载中心,默认杭州
    [[HBOfflineMapManager sharedManager] config];
    //初始化HUD风格
    [HBHUDManager config];

    //创建根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainBicycleViewController *bicycleVC = [[MainBicycleViewController alloc] init];
    HBBicycleNavigationController *navigationController = [[HBBicycleNavigationController alloc] initWithRootViewController:bicycleVC];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
