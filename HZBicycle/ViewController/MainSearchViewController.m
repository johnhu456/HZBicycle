//
//  MainSearchViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "MainSearchViewController.h"

//Views
#import "HBSearchBar.h"
#import "HBSearchResultCell.h"

@interface MainSearchViewController ()<UITableViewDelegate,UITableViewDataSource,HBSearchBarDelegete>
{
    BOOL _showRecentSearch;
}
#pragma mark - Views
@property (nonatomic, strong) HBSearchBar *searchBar;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UITableView *tableView;

#pragma mark - Models

@property (nonatomic, strong) HBBicycleResultModel *searchResult;

/**
 最近搜索
 */
@property (nonatomic, strong) NSArray *recentSearch;

@end

#pragma mark - Constant
static CGFloat const kContentInsets = 15.f;
static NSString *const kCellReuseIdentifier = @"kCellReuseIdentifier";
static NSString *const kTipRecentSearch = @"最近搜索";
static NSString *const kTipSearchResult = @"搜索结果";
static NSString *const kTitleClearButton = @"清空历史";

@implementation MainSearchViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //默认先显示最近搜索
    _showRecentSearch = YES;
    //设置搜索框
    [self setupSearchBar];
    //设置提示框
    [self setupTipLabel];
    //设置Tableview
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor lightGrayColor];
    }];

    [self.searchBar registerFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    }];
}

#pragma mark - Layout
- (void)setupSearchBar {
    @WEAKSELF;
    self.searchBar = [[HBSearchBar alloc] initWithShowType:HBSearchBarShowTypeBack];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).with.offset(kContentInsets);
        make.height.mas_equalTo(@50);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-kContentInsets);
    }];
}

- (void)setupTipLabel {
    @WEAKSELF;
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    self.tipLabel.font = HB_FONT_MEDIUM_SIZE(14);
    self.tipLabel.textColor = HB_COLOR_DARKBLUE;
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchBar.mas_bottom).with.offset(kContentInsets);
        make.height.mas_equalTo(@14);
        make.left.right.equalTo(weakSelf.searchBar);
    }];
    [self reloadTip];
}

- (void)setupTableView {
    @WEAKSELF;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 5.f;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.searchBar);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
        make.top.equalTo(weakSelf.tipLabel.mas_bottom).with.offset(kContentInsets/2.f);
    }];
    [self.tableView registerNib:NibFromClass(HBSearchResultCell) forCellReuseIdentifier:StrFromClass(HBSearchResultCell)];
}

/**
 刷新提示
 */
- (void)reloadTip {
    self.recentSearch = [[HBUserDefultsManager recentSearchs] copy];
    self.tipLabel.text = _showRecentSearch ? kTipRecentSearch : kTipSearchResult;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showRecentSearch ? self.recentSearch.count + 1: self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchResultCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:StrFromClass(HBSearchResultCell)];
    searchResultCell.bottomCornered = NO;
    //根据状态更改cell显示内容
    if (_showRecentSearch) {
        if (indexPath.row == self.recentSearch.count) {
            UITableViewCell *clearCell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
            if (clearCell == nil) {
                clearCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
                clearCell.backgroundColor = [UIColor clearColor];
                clearCell.selectionStyle = UITableViewCellSelectionStyleNone;
                clearCell.textLabel.font = [UIFont systemFontOfSize:13];
                clearCell.textLabel.textColor = [UIColor darkGrayColor];
                clearCell.textLabel.textAlignment = NSTextAlignmentRight;
            }
            clearCell.textLabel.text = kTitleClearButton;
            return clearCell;
        }else {
            NSDictionary *recentSearch = self.recentSearch[indexPath.row];
            [searchResultCell setRecentSearchText:recentSearch[kRecentSearchContent]];
            searchResultCell.bottomCornered = indexPath.row == self.recentSearch.count - 1? YES : NO;
        }
    }else {
        searchResultCell.stationModel = self.searchResult.data[indexPath.row];
        searchResultCell.bottomCornered = indexPath.row == self.searchResult.count - 1? YES : NO;
    }
    searchResultCell.topCornered = indexPath.row == 0 ? YES: NO;
    return searchResultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //分最近搜索还是搜索结果
    if (_showRecentSearch) {
        if (indexPath.row == self.recentSearch.count) {
            //清空历史
            [HBUserDefultsManager clearRecentSearchs];
            self.recentSearch = nil;
            [self.tableView reloadData];
        }else {
            NSDictionary *recentSearch = self.recentSearch[indexPath.row];
            [self searchBar:self.searchBar didFinishEdit:recentSearch[kRecentSearchContent]];
        }
    }else {
        @WEAKSELF;
        //第二次请求选中目的地周围的自行车
        [HBHUDManager showWaitProgress];
        HBBicycleStationModel *selectedStation = self.searchResult.data[indexPath.row];
        CLLocationCoordinate2D wgs84Coordinate = [DFLocationConverter bd09ToWgs84:CLLocationCoordinate2DMake(selectedStation.lat, selectedStation.lon)];
        [HBRequestManager sendNearBicycleRequestWithLatitude:@(wgs84Coordinate.latitude)
                                                  longtitude:@(wgs84Coordinate.longitude)
                                                      length:@([HBUserDefultsManager searchDistance])
                                           successJsonObject:^(NSDictionary *jsonDict) {
                                               [HBHUDManager dismissWaitProgress];
                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                               HBBicycleResultModel *stationResult = [HBBicycleResultModel mj_objectWithKeyValues:jsonDict];
                                               if ([weakSelf.delegate respondsToSelector:@selector(searchViewController:didChooseIndex:inResults:)]) {
                                                   [weakSelf.delegate searchViewController:self didChooseIndex:0 inResults:stationResult];
                                               }
                                           } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                [HBHUDManager showNetworkError];
                                           }];
    }
}

#pragma mark - HBSearchBarDelegate
- (void)searchBar:(HBSearchBar *)searchBar backButtonOnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarDidBeginEdit:(HBSearchBar *)searchBar {
    
}

- (void)searchBar:(HBSearchBar *)searchBar textDidChanged:(NSString *)text {
   
}

-(void)searchBar:(HBSearchBar *)searchBar didFinishEdit:(NSString *)text {
    @WEAKSELF;
    [HBUserDefultsManager addSearchText:text];
    //显示网络加载
    [HBHUDManager showWaitProgress];
    [HBRequestManager sendSearchBicycleStationRequestWithOptions:text
                                               successJsonObject:^(NSDictionary *jsonDict) {
                                                   //因为返回结构不一致 需要做转换。
                                                   NSMutableArray *result = [[NSMutableArray alloc] init];
                                                   for (NSDictionary *stationDic in jsonDict[@"data"]) {
                                                   //结束加载状态
                                                   [HBHUDManager dismissWaitProgress];
                                                       HBBicycleStationModel *stationModel = [HBBicycleStationModel mj_objectWithKeyValues:stationDic[@"result"]];
                                                       [result addObject:stationModel];
                                                   }
                                                   weakSelf.searchResult = [[HBBicycleResultModel alloc] init];
                                                   weakSelf.searchResult.data = [result copy];
                                                   weakSelf.searchResult.count = result.count;
                                                   if (weakSelf.searchResult.data.count == 0) {
                                                       [HBHUDManager showNoSearchResult];
                                                       _showRecentSearch = YES;
                                                   }else {
                                                       _showRecentSearch = NO;
                                                   }
                                                   [weakSelf reloadTip];
                                                   [weakSelf.tableView reloadData];
                                               } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                   [HBHUDManager showNetworkError];
                                               }];
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
