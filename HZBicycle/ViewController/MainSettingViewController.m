//
//  MainSettingViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/4.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainSettingViewController.h"
#import <MessageUI/MessageUI.h>
//Cells
#import "HBBicycleAccuracyCell.h"
#import "HBOfflineMapCell.h"
#import "HBDefaultSettingCell.h"

#import "HBAboutBicycleViewController.h"

@interface MainSettingViewController ()<UITableViewDelegate,UITableViewDataSource,PKDownloadButtonDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PKDownloadButton *downloadButton;

@property (nonatomic, weak) HBOfflineMapCell *offlineMapCell;

@end

static CGFloat const kAccuracyCellHeight = 115.f;
static CGFloat const kOfflineCellHeight = 135.f;
static CGFloat const kOffcialContactCellHeight = 59.f;
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
                self.offlineMapCell.lblSize.text = [NSString stringWithFormat:@"%.2f MB",offlineItem.size/kSizeAdapter];
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

- (void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = HB_COLOR_TABLEVAIEWBACK;
    
    //设置TableView
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            HBBicycleAccuracyCell *accuaryCell = [tableView dequeueReusableCellWithIdentifier:StrFromClass(HBBicycleAccuracyCell)];
            accuaryCell.handleSldValueChanged = ^(NSInteger intValue){
                [HBUserDefultsManager setSearchDistance:intValue];
            };
            accuaryCell.searchDistance = [HBUserDefultsManager searchDistance];
            return accuaryCell;
        }
            break;
        case 1:
        {
            HBOfflineMapCell *offlineMapCell = [tableView dequeueReusableCellWithIdentifier:StrFromClass(HBOfflineMapCell)];
            offlineMapCell.pkDownLoadButton.delegate = self;
            self.downloadButton = offlineMapCell.pkDownLoadButton;
            self.offlineMapCell = offlineMapCell;
            //设置下载按钮的显示状态
            [self setupDownloadButtonState];
            return offlineMapCell;
        }
            break;
        case 2:
        {
            HBDefaultSettingCell *officialContactCell = [[HBDefaultSettingCell alloc] initWithTitle:@"联系客服" icon:ImageInName(@"main_setting_dial") cellType:HBSettintCellTypeTop];
            return officialContactCell;
        }
            break;
        case 3:
        {
            HBDefaultSettingCell *feedBackCell = [[HBDefaultSettingCell alloc] initWithTitle:@"意见反馈" icon:ImageInName(@"main_setting_feedback") cellType:HBSettintCellTypeDefault];
            return feedBackCell;
        }
            break;
        case 4:
        {
            HBDefaultSettingCell *aboutMeCell = [[HBDefaultSettingCell alloc] initWithTitle:@"关于PBicycles" icon:ImageInName(@"main_setting_about") cellType:HBSettintCellTypeBottom];
            return aboutMeCell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: case 1:
            return;
            break;
        case 2:
            //联系客服
            [self dialServiceCall];
            break;
        case 3:
            //意见反馈
            [self gotFeedBack];
            break;
        case 4:
            //关于页面
        {
            HBAboutBicycleViewController *aboutVC = [[HBAboutBicycleViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return kAccuracyCellHeight;
            break;
        case 1:
            return kOfflineCellHeight;
            break;
        case 2:
            return kOffcialContactCellHeight;
            break;
        case 3: case 4:
            return kOffcialContactCellHeight - 10 ;
        default:
            return DBL_EPSILON;
            break;
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
            //处理删除按钮点击
            [self handleDeleteButtonOnClicked];
            break;
        default:
            NSAssert(NO, @"unsupported state");
            break;
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultCancelled) {
        //取消
    } else if (result == MFMailComposeResultSent) {
        //成功
    } else if (result == MFMailComposeResultFailed){
        //失败
    } else {
        
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

- (void)handleDeleteButtonOnClicked {
    @WEAKSELF;
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后下次使用地图将会消耗流量哦~" preferredStyle:UIAlertControllerStyleAlert];
    @WEAK_OBJ(tipAlert);
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tipAlertWeak dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.downloadButton.state = kPKDownloadButtonState_StartDownload;
        [[HBOfflineMapManager sharedManager] clearMap];
    }];
    [tipAlert addAction:cancel];
    [tipAlert addAction:confirm];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

- (void)dialServiceCall {
    //联系客服
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"联系客服" message:@"0571-85331122" preferredStyle:UIAlertControllerStyleAlert];
    @WEAK_OBJ(tipAlert);
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tipAlertWeak dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *dial = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneUrl = @"tel://0571-85331122";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
    }];
    [tipAlert addAction:cancel];
    [tipAlert addAction:dial];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

- (void)gotFeedBack {
    //意见反馈
    if (![MFMailComposeViewController canSendMail]) {
        [HBHUDManager showMailSettingError];
        return;
    }
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    //邮箱先写死
    [vc setToRecipients:@[@"johnhu456@163.com"]];
    vc.mailComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
