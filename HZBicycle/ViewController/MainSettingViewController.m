//
//  MainSettingViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/4.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainSettingViewController.h"

//Cells
#import "HBBicycleAccuracyCell.h"
#import "HBOfflineMapCell.h"

@interface MainSettingViewController ()<UITableViewDelegate,UITableViewDataSource,PKDownloadButtonDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) PKDownloadButton *downloadButton;

@end

static CGFloat const kAccuracyCellHeight = 115.f;
static CGFloat const kOfflineCellHeight = 135.f;

@implementation MainSettingViewController

#pragma mark - UserInterface
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //注册Cell
    [self.tableView registerNib:NibFromClass(HBBicycleAccuracyCell) forCellReuseIdentifier:StrFromClass(HBBicycleAccuracyCell)];
    [self.tableView registerNib:NibFromClass(HBOfflineMapCell) forCellReuseIdentifier:StrFromClass(HBOfflineMapCell)];
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置TableView
    [self setupTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning  to change;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HBBicycleAccuracyCell *accuaryCell = [tableView dequeueReusableCellWithIdentifier:StrFromClass(HBBicycleAccuracyCell)];
        return accuaryCell;
    }else {
        HBOfflineMapCell *offlineMapCell = [tableView dequeueReusableCellWithIdentifier:StrFromClass(HBOfflineMapCell)];
        offlineMapCell.pkDownLoadButton.delegate = self;
//        offlineMapCell.downLoadButton.stopButton.
        return offlineMapCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kAccuracyCellHeight;
    }else {
        return kOfflineCellHeight;
    }

}

#pragma mark - PKDownloadButtonDelegate
- (void)downloadButtonTapped:(PKDownloadButton *)downloadButton
                currentState:(PKDownloadButtonState)state {
    switch (state) {
        case kPKDownloadButtonState_StartDownload:
            self.downloadButton.state = kPKDownloadButtonState_Pending;
//            [self.pendingSimulator startDownload];
            break;
        case kPKDownloadButtonState_Pending:
//            [self.pendingSimulator cancelDownload];
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case kPKDownloadButtonState_Downloading:
//            [self.downloaderSimulator cancelDownload];
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case kPKDownloadButtonState_Downloaded:
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
//            self.imageView.hidden = YES;
            break;
        default:
            NSAssert(NO, @"unsupported state");
            break;
    }
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
