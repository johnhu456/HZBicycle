//
//  HBSearchTransition.m
//  HZBicycle
//
//  Created by MADAO on 16/11/15.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBSearchTransition.h"
#import "MainBicycleViewController.h"
#import "MainSearchViewController.h"

#pragma mark - Constant
static NSTimeInterval const kAnimationDuration = 0.25f;

@implementation HBSearchTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    MainBicycleViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainSearchViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Push
    if ([fromVC isKindOfClass:[MainBicycleViewController class]]) {
        //做一个假搜索框
        [containerView addSubview:fromVC.view];
        HBSearchBar *searchBar = [[HBSearchBar alloc] initWithShowType:HBSearchBarShowTypeSearch];
        [containerView addSubview:searchBar];
        @weakify(containerView);
        [searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).with.offset(35.f);
            make.height.mas_equalTo(@50);
            make.left.equalTo(weak_containerView.mas_left).with.offset(15);
            make.right.equalTo(weak_containerView.mas_right).with.offset(-15);
        }];
        [containerView addSubview:toVC.view];
        toVC.view.alpha = 0;
        [searchBar showBackButtonWithAnimated:YES];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            fromVC.view.alpha = 1;
            toVC.view.alpha = 1;
            [searchBar removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}
@end
