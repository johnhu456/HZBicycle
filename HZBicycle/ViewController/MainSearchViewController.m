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

#pragma mark - Views
@property (nonatomic, strong) HBSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;

#pragma mark - Models

@property (nonatomic, strong) HBBicycleResultModel *searchResult;

@end

#pragma mark - Constant
static CGFloat const kContentInsets = 15.f;

@implementation MainSearchViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置搜索框
    [self setupSearchBar];
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

#pragma mark - Layout
- (void)setupSearchBar {
    @WEAKSELF;
    self.searchBar = [[HBSearchBar alloc] initWithShowType:HBSearchBarShowTypeBack];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).with.offset(15.f);
        make.height.mas_equalTo(@50);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(kContentInsets);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-kContentInsets);
    }];
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
        make.top.equalTo(weakSelf.searchBar.mas_bottom).with.offset(kContentInsets);
    }];
    [self.tableView registerNib:NibFromClass(HBSearchResultCell) forCellReuseIdentifier:StrFromClass(HBSearchResultCell)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchResultCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:StrFromClass(HBSearchResultCell)];
    searchResultCell.stationModel = self.searchResult.data[indexPath.row];
    searchResultCell.topCornered = indexPath.row == 0 ? YES: NO;
    searchResultCell.bottomCornered = indexPath.row == self.searchResult.count - 1? YES : NO;
    return searchResultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @WEAKSELF;
    //第二次请求选中目的地周围的自行车
    [HBHUDManager showWaitProgress];
    HBBicycleStationModel *selectedStation = self.searchResult.data[indexPath.row];
    CLLocationCoordinate2D wgs84Coordinate = [DFLocationConverter bd09ToWgs84:CLLocationCoordinate2DMake(selectedStation.lat, selectedStation.lon)];
    [HBRequestManager sendNearBicycleRequestWithLatitude:@(wgs84Coordinate.latitude)
                                              longtitude:@(wgs84Coordinate.longitude)
                                                  length:@([HBUserDefultsManager searchDistance])
                                       successJsonObject:^(NSDictionary *jsonDict) {
                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                           HBBicycleResultModel *stationResult = [HBBicycleResultModel mj_objectWithKeyValues:jsonDict];
                                           if ([weakSelf.delegate respondsToSelector:@selector(searchViewController:didChooseIndex:inResults:)]) {
                                               [weakSelf.delegate searchViewController:self didChooseIndex:0 inResults:stationResult];
                                           }
                                       } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
#warning 错误处理。
                                       }];
}

#pragma mark - HBSearchBarDelegate
- (void)searchBar:(HBSearchBar *)searchBar backButtonOnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarDidBeginEdit:(HBSearchBar *)searchBar {
    
}

- (void)searchBar:(HBSearchBar *)searchBar textDidChanged:(NSString *)text {
    NSLog(@"start %@ ",text);
}

-(void)searchBar:(HBSearchBar *)searchBar didFinishEdit:(NSString *)text {
    @WEAKSELF;
    [HBRequestManager sendSearchBicycleStationRequestWithOptions:text
                                               successJsonObject:^(NSDictionary *jsonDict) {
                                                   //因为返回结构不一致 需要做转换。
                                                   NSMutableArray *result = [[NSMutableArray alloc] init];
                                                   for (NSDictionary *stationDic in jsonDict[@"data"]) {
                                                       HBBicycleStationModel *stationModel = [HBBicycleStationModel mj_objectWithKeyValues:stationDic[@"result"]];
                                                       [result addObject:stationModel];
                                                   }
                                                   weakSelf.searchResult = [[HBBicycleResultModel alloc] init];
                                                   weakSelf.searchResult.data = [result copy];
                                                   weakSelf.searchResult.count = result.count;
                                                   [weakSelf.tableView reloadData];
                                               } failureCompletion:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                   NSLog(@"%@",request);
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
