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

@property (nonatomic, strong) PKDownloadButton *downloadButton;

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

- (void)setupDownloadButtonState {
    MAOfflineItemStatus downloadStatus = [[HBOfflineMapManager sharedManager] selectedCity].itemStatus;
    switch (downloadStatus) {
        case MAOfflineItemStatusNone:
            //可下载状态
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            break;
        case MAOfflineItemStatusCached:
            //下载到一半
            self.downloadButton.state = kPKDownloadButtonState_Pending;
            break;
        case MAOfflineItemStatusInstalled:
            //可删除
            self.downloadButton.state = kPKDownloadButtonState_Downloaded;
            break;
        case MAOfflineItemStatusExpired:
            //已过期
            break;
        default:
            break;
    }
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置TableView
    [self setupTableView];
    
    //设置下载按钮的状态
    [self setupDownloadButtonState];
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
        self.downloadButton = offlineMapCell.pkDownLoadButton;
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
    @WEAKSELF;
    switch (state) {
        case kPKDownloadButtonState_StartDownload:
        {
            self.downloadButton.state = kPKDownloadButtonState_Downloading;
            [[HBOfflineMapManager sharedManager] startDownloadWithBlock:^(MAOfflineItem *downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info) {
                if (downloadStatus == MAOfflineMapDownloadStatusProgress) {
//                    NSLog(@"===%ld,  info:%@",(long)downloadStatus,info);
                    NSDictionary *infoDic = (NSDictionary *)info;
                    CGFloat downPrecent = [infoDic[MAOfflineMapDownloadReceivedSizeKey] floatValue]/[infoDic[MAOfflineMapDownloadExpectedSizeKey] floatValue]/1.f;
                    weakSelf.downloadButton.stopDownloadButton.progress = downPrecent;
                }
                if (downloadStatus == MAOfflineMapDownloadStatusCompleted) {
                    //下载完成
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.downloadButton.stopDownloadButton.progress = 1;
                        weakSelf.downloadButton.state = kPKDownloadButtonState_Downloaded;
                        [weakSelf.downloadButton setNeedsDisplay];
                    });

                }
            }];
        }
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
            [[HBOfflineMapManager sharedManager] clearMap];
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
