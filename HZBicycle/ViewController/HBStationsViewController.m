//
//  HBStationsViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBStationsViewController.h"
#import "AppDelegate.h"
#import "HBStationsFlowLayout.h"

#import "HBStationCell.h"

@interface HBStationsViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSUInteger _cardIndex;
}

#pragma mark - Views

/**
 毛玻璃背景
 */
@property (nonatomic, strong) UIImage *blurBackImage;

/**
 CollectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;

#pragma mark - Models

/**
 站点数据
 */
@property (nonatomic, strong) HBBicycleResultModel *resultStations;

@end

@implementation HBStationsViewController

#pragma mark - Init
- (instancetype)initWithStations:(HBBicycleResultModel *)stations index:(NSUInteger)index blurBackImage:(UIImage *)backImage {
    if (self = [super init]) {
        _cardIndex = index;
        self.blurBackImage = backImage;
        self.resultStations = stations;
    }
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //设置模糊背景
    [self setupBlurView];
    
//    设置collectionView
    [self setupCollectionView];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UserInterface
- (void)setupBlurView {
//    @WEAKSELF;
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.image = [self.blurBackImage coreBlurWithBlurLevel:1.2];
    [self.view addSubview:backView];
}

- (void)setupCollectionView {
    HBStationsFlowLayout *flowLayout = [[HBStationsFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:NibFromClass(HBStationCell) forCellWithReuseIdentifier:StrFromClass(HBStationCell)];
    [self.collectionView setContentOffset:CGPointMake((self.collectionView.frame.size.width - 30 * 3) *_cardIndex, self.collectionView.contentOffset.y) animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.resultStations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBStationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StrFromClass(HBStationCell) forIndexPath:indexPath];
    cell.station = self.resultStations.data[indexPath.row];
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if ([self.delegate respondsToSelector:@selector(stationViewController:didSelectedIndex:inStations:)]){
        [self.delegate stationViewController:self didSelectedIndex:indexPath.row inStations:self.resultStations];
    }
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
