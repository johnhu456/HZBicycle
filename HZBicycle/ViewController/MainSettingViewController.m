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

@property (nonatomic, weak) HBOfflineMapCell *offlineMapCell;

@end

static CGFloat const kAccuracyCellHeight = 115.f;
static CGFloat const kOfflineCellHeight = 135.f;
static CGFloat const kSizeAdapter = 1024.f * 1024.f;

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
    MAOfflineItem *offlineItem = [[HBOfflineMapManager sharedManager] selectedCity];
    MAOfflineItemStatus downloadStatus = offlineItem.itemStatus;
    switch (downloadStatus) {
        case MAOfflineItemStatusNone:
            //下载到一半
            if ([[HBOfflineMapManager sharedManager] isDownloading]) {
                //可能正在下载
                self.downloadButton.state = kPKDownloadButtonState_Downloading;
                [self startDownloadTask];
            }else{
                //可下载状态
                self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            }
            break;
        case MAOfflineItemStatusCached: {
            //下载到一半
            if ([[HBOfflineMapManager sharedManager] isDownloading]) {
                //可能正在下载
                self.downloadButton.state = kPKDownloadButtonState_Downloading;
                [self startDownloadTask];
            }else{
                self.downloadButton.state = kPKDownloadButtonState_StartDownload;
                //设置显示下载量
                self.offlineMapCell.lblSize.text = [NSString stringWithFormat:@"%.2f/%.2f MB",offlineItem.downloadedSize/kSizeAdapter,offlineItem.size/kSizeAdapter];
            }
        }
            break;
        case MAOfflineItemStatusInstalled: {
            //可删除
            self.downloadButton.state = kPKDownloadButtonState_Downloaded;
            //设置显示下载量
            self.offlineMapCell.lblSize.text = [NSString stringWithFormat:@"%.2f MB",offlineItem.size/kSizeAdapter];
        }
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        self.offlineMapCell = offlineMapCell;
        //设置下载按钮的显示状态
        [self setupDownloadButtonState];
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
        {
            self.downloadButton.state = kPKDownloadButtonState_Downloading;
            //开始下载任务
            [self startDownloadTask];
        }
            break;
        case kPKDownloadButtonState_Pending:
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            //开始下载任务
            [self startDownloadTask];
            break;
        case kPKDownloadButtonState_Downloading:
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            [[HBOfflineMapManager sharedManager] stopDownload];
            break;
        case kPKDownloadButtonState_Downloaded:
            //清空地图数据
#warning 做个弹窗
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
            [[HBOfflineMapManager sharedManager] clearMap];
            break;
        default:
            NSAssert(NO, @"unsupported state");
            break;
    }
}

#pragma mark - Private Method
- (void)startDownloadTask {
    @WEAKSELF;
    [[HBOfflineMapManager sharedManager] startDownloadWithBlock:^(MAOfflineItem *downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info) {
        if (downloadStatus == MAOfflineMapDownloadStatusProgress) {
            NSDictionary *infoDic = (NSDictionary *)info;
            CGFloat received = [infoDic[MAOfflineMapDownloadReceivedSizeKey] floatValue];
            CGFloat expected = [infoDic[MAOfflineMapDownloadExpectedSizeKey] floatValue];
            CGFloat downPrecent = received/expected/1.f;
            //更新按钮下载进度
            weakSelf.downloadButton.stopDownloadButton.progress = downPrecent;
            //更新离线包大小显示
            weakSelf.offlineMapCell.lblSize.text = [NSString stringWithFormat:@"%.2f/%.2f MB",received/kSizeAdapter,expected/kSizeAdapter];
        }
        if (downloadStatus == MAOfflineMapDownloadStatusCompleted) {
            //下载完成
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.downloadButton.stopDownloadButton.progress = 1;
                weakSelf.downloadButton.state = kPKDownloadButtonState_Downloaded;
                //更新离线包大小显示
                weakSelf.offlineMapCell.lblSize.text = [NSString stringWithFormat:@"%.2f MB",downloadItem.size/kSizeAdapter];
                [weakSelf.downloadButton setNeedsDisplay];
            });
        }
    }];
}

- (void)dealloc {
    NSLog(@"dealloced");
}
@end
