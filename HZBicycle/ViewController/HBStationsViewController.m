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

@interface HBStationsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Init
- (instancetype)initWithStations:(HBBicycleResultModel *)stations index:(NSUInteger)index blurBackImage:(UIImage *)backImage {
    if (self = [super init]) {
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
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - UserInterface
- (void)setupBlurView {
//    @WEAKSELF;
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.image = [self.blurBackImage coreBlurWithBlurLevel:1.0];
    [self.view addSubview:backView];
}

- (void)setupCollectionView {
    HBStationsFlowLayout *flowLayout = [[HBStationsFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.resultStations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
#pragma mark <UICollectionViewDelegate>

#pragma mark - SnapShotView


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
