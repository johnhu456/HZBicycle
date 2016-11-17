//
//  MainSearchViewController.h
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBaseViewController.h"
@class MainSearchViewController;

@protocol SeachViewControllerDelegate <NSObject>

/**
 点击搜索结果的代理方法
 
 @param searchVC 搜索页面
 @param index    选中的Index
 @param results  搜索结果
 */
- (void)searchViewController:(MainSearchViewController *)searchVC didChooseIndex:(NSUInteger)index inResults:(HBBicycleResultModel *)results;

@end

@interface MainSearchViewController : HBBaseViewController

@property (nonatomic, weak) id<SeachViewControllerDelegate>delegate;

@end
