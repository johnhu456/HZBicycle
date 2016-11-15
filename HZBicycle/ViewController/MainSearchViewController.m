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

@interface MainSearchViewController ()<UITableViewDelegate,UITableViewDataSource,HBSearchBarDelegete>
#pragma mark - Views
@property (nonatomic, strong) HBSearchBar *searchBar;

@property (nonatomic, strong) UITableView *tableView;
@end

#pragma mark - Constant
static CGFloat const kContentInsets = 15.f;

@implementation MainSearchViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HB_COLOR_TABLEVAIEWBACK;
    //设置搜索框
    [self setupSearchBar];
    
    //设置Tableview
    [self setupTableView];
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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.searchBar);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
        make.top.equalTo(weakSelf.searchBar.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning 待定
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#warning 待定
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = @"2423";
    return cell;
}

#pragma mark - HBSearchBarDelegate

- (void)searchBar:(HBSearchBar *)searchBar backButtonOnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarDidBeginEdit:(HBSearchBar *)searchBar {
    
}

- (void)searchBar:(HBSearchBar *)searchBar textDidChanged:(NSString *)text {
    
}

- (void)searchBar:(HBSearchBar *)searchBar didFinishEdit:(NSString *)text {
    
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
