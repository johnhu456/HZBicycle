//
//  MainNaviViewController.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/6.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainNaviViewController.h"

@interface MainNaviViewController ()<AMapNaviDriveViewDelegate>

@property (nonatomic, strong) AMapNaviDriveView *naviDriveView;

@property (nonatomic, weak) HBBicycleResultModel *stationResult;

@property (nonatomic, assign) NSUInteger targetIndex;

@end

@implementation MainNaviViewController

#pragma mark - Initialize
- (instancetype)initWithStations:(HBBicycleResultModel *)staion
                     targetIndex:(NSUInteger)index {
    if (self = [super init]) {
        self.stationResult = staion;
        _targetIndex = index;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupNaviDriveView {
    self.naviDriveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
    self.naviDriveView.delegate = self;
    [self.view addSubview:self.naviDriveView];
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
