//
//  HBLocationButton.m
//  HZBicycle
//
//  Created by MADAO on 16/10/31.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBLocationButton.h"

@interface HBLocationButton()

/**
 加载指示器
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end


@implementation HBLocationButton

- (instancetype)initWithIconImage:(UIImage *)image clickBlock:(void(^)())block {
    if (self = [super initWithIconImage:image clickBlock:block]) {
        [self setupActivityIndicator];
    }
    return self;
}

- (void)setupActivityIndicator {
    @WEAKSELF;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.activityIndicator];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).with.offset(kHBRoundButtonContentInsets);
        make.right.bottom.equalTo(weakSelf).with.offset(-kHBRoundButtonContentInsets);
    }];
    self.activityIndicator.hidden = YES;
}

#pragma mark - Public Method
- (void)startActivityAnimation {
    self.activityIndicator.hidden = NO;
    self.iconView.hidden = YES;
    [self.activityIndicator startAnimating];
}

- (void)endActivityAnimation {
    self.activityIndicator.hidden = YES;
    self.iconView.hidden = NO;
    [self.activityIndicator stopAnimating];
}

@end
