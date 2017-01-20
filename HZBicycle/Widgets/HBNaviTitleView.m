//
//  HBNaviTitleView.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBNaviTitleView.h"

@interface HBNaviTitleView () {
    
}
/**
 选块指示View
 */
@property (nonatomic, strong) UIView *selectIndicator;

/**
 步行导航按钮
 */
@property (nonatomic, strong) UIButton *btnNaviWalk;

/**
 骑行导航按钮
 */
@property (nonatomic, strong) UIButton *btnNaviRide;

/**
 按钮点击回调
 */
@property (nonatomic, copy) void(^buttonOnClickBlock)(NSUInteger buttonIndex);

@end

#pragma mark - Constant

static CGFloat const kCornerRadius = 5.f;        //圆角半径常数
static NSTimeInterval const kAnimationDuration = 0.25f;        //动画时间

@implementation HBNaviTitleView

#pragma mark - Init
- (instancetype)init {
    return [self initWithButtonOnClicked:nil];
}

- (instancetype)initWithButtonOnClicked:(void (^)(NSUInteger))buttonClicked {
    if (self = [super init]) {
        self.buttonOnClickBlock = buttonClicked;
        self.bounds = CGRectMake(0, 0, 80, 30);
        [self defaultInitialize];
    }
    return self;
}

- (void)defaultInitialize {
    [self setupSubViews];
    [self setupConstraints];
}

#pragma mark - User Interface 
- (void)setupSubViews {
    self.backgroundColor = HB_COLOR_SLDMID;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    self.selectIndicator = [[UIView alloc] init];
    self.selectIndicator.backgroundColor = HB_COLOR_SLDMIN;
    self.selectIndicator.layer.cornerRadius = kCornerRadius;
    self.selectIndicator.layer.masksToBounds = YES;
    [self addSubview:self.selectIndicator];
    self.selectIndicator.frame = CGRectMake(0, 0, self.bounds.size.width/2.f, self.bounds.size.height);
    
    self.btnNaviWalk = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnNaviWalk setBackgroundColor:[UIColor clearColor]];
    [self.btnNaviWalk addTarget:self action:@selector(handleButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnNaviWalk.tag = 0;
    [self.btnNaviWalk setBackgroundImage:ImageInName(@"navi_title_walk_default") forState:UIControlStateNormal];
    [self.btnNaviWalk setBackgroundImage:ImageInName(@"navi_title_walk_highlighted") forState:UIControlStateHighlighted];
    [self addSubview:self.btnNaviWalk];
    
    self.btnNaviRide = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnNaviRide setBackgroundColor:[UIColor clearColor]];
    [self.btnNaviRide addTarget:self action:@selector(handleButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNaviRide setBackgroundImage:ImageInName(@"navi_title_ride_default") forState:UIControlStateNormal];
    [self.btnNaviRide setBackgroundImage:ImageInName(@"navi_title_ride_default") forState:UIControlStateHighlighted];
    self.btnNaviRide.tag = 1;
    [self addSubview:self.btnNaviRide];
    
    
}

- (void)setupConstraints {
    @WEAKSELF;
    [self.btnNaviWalk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).with.offset(5.f);
        make.right.equalTo(weakSelf.mas_centerX).with.offset(-5.f);
    }];
    
    [self.btnNaviRide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.height.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_centerX).with.offset(5.f);
        make.right.equalTo(weakSelf.mas_right).with.offset(-5.f);
    }];
}

#pragma mark - Private Method
- (void)handleButtonOnClicked:(UIButton *)sender {
    if(self.buttonOnClickBlock){
        //执行选块动画
        [self performAnimationWithTag:sender.tag];
        self.buttonOnClickBlock(sender.tag);
    }
}

- (void)performAnimationWithTag:(NSUInteger)tag {
    @WEAKSELF;
    [UIView animateWithDuration:kAnimationDuration delay:0.f usingSpringWithDamping:0.6 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.selectIndicator.x = weakSelf.bounds.size.width/2.f * tag;
    } completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
