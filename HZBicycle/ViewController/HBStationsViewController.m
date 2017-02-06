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

@interface HBStationsViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate> {
    NSUInteger _cardIndex;
}

#pragma mark - Views

/**
 毛玻璃背景
 */
@property (nonatomic, strong) UIImage *blurBackImage;

@property (nonatomic, strong) UIImageView *blurView;

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

#pragma mark - Constant
static NSString *const kDistrictNumber = @"0571-";

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
    
    //设置点击手势
    [self setupTapGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UserInterface
- (void)setupBlurView {
//    @WEAKSELF;
    self.blurView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.blurView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurView.image = [self.blurBackImage coreBlurWithBlurLevel:1.2];
    [self.view addSubview:self.blurView];
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

- (void)setupTapGestureRecognizer {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGes.delegate = self;
    [self.collectionView addGestureRecognizer:tapGes];
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
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //ACTionsheet 选择
    HBBicycleStationModel *station = self.resultStations.data[indexPath.row];
    NSString *phone1 = [self getDistrictNumberWithPhone:[[station.stationPhone mutableCopy] substringFromIndex:13]];
    NSString *phone2 = [self getDistrictNumberWithPhone:[[station.stationPhone2 mutableCopy] substringFromIndex:14]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *show = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(stationViewController:didSelectedIndex:inStations:)]){
            [self.delegate stationViewController:self didSelectedIndex:indexPath.row inStations:self.resultStations];
        }
        [self handleDismiss];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertController addAction:cancel];
    [alertController addAction:show];
    if (phone2) {
        //Phone2有时候不存在
        UIAlertAction *callPhone1 = [UIAlertAction actionWithTitle:@"联系(白天)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone1]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        
        UIAlertAction *callPhone2 = [UIAlertAction actionWithTitle:@"联系(晚上)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone2]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:callPhone1];
        [alertController addAction:callPhone2];
    } else {
        UIAlertAction *callPhone1 = [UIAlertAction actionWithTitle:@"联系(全天)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone1]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:callPhone1];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private Method 
- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    [self handleDismiss];
}

//从父视图移除
- (void)handleDismiss {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

//添加电话区号
- (NSString *)getDistrictNumberWithPhone:(NSString *)phoneNumber {
    if (phoneNumber.length == 8) {
        NSString *resultNumber = [[kDistrictNumber mutableCopy] stringByAppendingString:phoneNumber];
        return resultNumber;
    }else {
        return phoneNumber;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.collectionView) {
        return NO;
    }
    return YES;
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
