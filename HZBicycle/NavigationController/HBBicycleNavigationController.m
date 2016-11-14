//
//  HBBicycleNavigationController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/4.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleNavigationController.h"
#import "UINavigationBar+Awesome.h"

@interface HBBicycleNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HBBicycleNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面相关
    [self setupUserInterface];
    //开启侧滑返回
    self.interactivePopGestureRecognizer.enabled = YES;
    //不指定代理，会因为自定义按钮的原因造成侧滑失败
    self.interactivePopGestureRecognizer.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)setupUserInterface {
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar lt_setBackgroundColor:HB_COLOR_DARKBLUE];
    [self.navigationBar setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                                }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
