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
 按钮点击回调
 */
@property (nonatomic, copy) void(^buttonClickBlock)();

/**
 按钮图标
 */
@property (nonatomic, strong) UIImageView *iconView;

/**
 加载指示器
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

//icon大小
static CGFloat const kContentInsets = 10.f;

@implementation HBLocationButton

- (instancetype)initWithClickBlock:(void (^)())block {
    if (self = [super init]) {
        self.buttonClickBlock = block;
        //设置阴影
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self addTarget:self action:@selector(handleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        [self setupActivityIndicator];
    }
    return self;
}


/**
 设置子视图
 */
- (void)setupSubViews {
    self.iconView = [[UIImageView alloc] initWithImage:ImageInName(@"main_location")];
    [self addSubview:self.iconView];
    @WEAKSELF;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).with.offset(kContentInsets);
        make.right.bottom.equalTo(weakSelf).with.offset(-kContentInsets);
    }];
}

- (void)setupActivityIndicator {
    @WEAKSELF;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.activityIndicator];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).with.offset(kContentInsets);
        make.right.bottom.equalTo(weakSelf).with.offset(-kContentInsets);
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

#pragma mark - ButtonAction
- (void)handleButtonOnClick:(UIButton *)sender {
    [self startActivityAnimation];
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
}


@end
