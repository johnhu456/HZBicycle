//
//  HBBaseViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBaseViewController.h"

@interface HBBaseViewController ()

@end

@implementation HBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏按钮
    [self setupNavigationBar];
}

#pragma mark - UserInterface
- (void)setupNavigationBar {
    UIButton *cusLeftBtn = [[UIButton alloc] init];
    [cusLeftBtn setBackgroundImage:[UIImage imageNamed:@"main_navi_back"] forState:UIControlStateNormal];
    // 设置高亮状态图片
    [cusLeftBtn setBackgroundImage:[UIImage imageNamed:@"main_navi_back"] forState:UIControlStateHighlighted];
    // 设置frame
    cusLeftBtn.frame = (CGRect){CGPointZero,cusLeftBtn.currentBackgroundImage.size};
    // 添加监听事件
    [cusLeftBtn addTarget:self action:@selector(backBarButtonItemOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cusLeftBtn];

}

#pragma mark - Actions
- (void)backBarButtonItemOnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
