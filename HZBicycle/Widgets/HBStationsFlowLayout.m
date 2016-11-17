//
//  HBStationsFlowLayout.m
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBStationsFlowLayout.h"

@interface HBStationsFlowLayout()

@property (nonatomic, assign) CGFloat previousOffsetX;

@end

#pragma mark - Constant
static CGFloat const kItemSpacing = 30.f;
static CGFloat const kEdgeInsets = 60.f;
static CGFloat const kConstantParams = 0.2; //缩放常数

@implementation HBStationsFlowLayout

#pragma mark - Initialize
- (instancetype)init {
    if (self = [super init]) {
        [self defaultInitialize];
    }
    return self;
}

- (void)defaultInitialize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.itemSize = CGSizeMake(screenWidth - 120, 300);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = kItemSpacing;
    self.sectionInset = UIEdgeInsetsMake((screenHeight-300)/2.f, kEdgeInsets, (screenHeight-300)/2.f, kEdgeInsets);

}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.frame.size.width,
                                    self.collectionView.frame.size.height);
    CGFloat offset = CGRectGetMidX(visibleRect);
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnullstop) {
        CGFloat distance = offset - attribute.center.x;
        //缩放
        CGFloat scaleForDistance = distance / self.itemSize.height;
        // 0.2可调整，值越大，显示就越大
        CGFloat scaleForCell = 0.8 + kConstantParams * (1 - fabs(scaleForDistance));
        
        attribute.transform3D = CATransform3DMakeScale(1, scaleForCell, 1);
        attribute.zIndex = 1;
    }];
    
    return attributes;
}


-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
        self.previousOffsetX += self.collectionView.frame.size.width - self.minimumLineSpacing* 3;
    } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
        self.previousOffsetX -= self.collectionView.frame.size.width - self.minimumLineSpacing* 3;
    }
    proposedContentOffset.x = self.previousOffsetX;
    return proposedContentOffset;
}
@end
