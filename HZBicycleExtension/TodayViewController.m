//
//  TodayViewController.m
//  HZBicycleExtension
//
//  Created by 胡翔 on 2017/1/22.
//  Copyright © 2017年 MADAO. All rights reserved.
//

#import "TodayViewController.h"
#import "HBUserDefultsManager.h"

#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@",[HBUserDefultsManager recentSearchs]);
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%f",[HBUserDefultsManager searchDistance]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%f",[HBUserDefultsManager searchDistance]);
//    self.extensionContext openURL:<#(nonnull NSURL *)#> completionHandler:<#^(BOOL success)completionHandler#>
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
