//
//  HBNaviMenuView.m
//  HZBicycle
//
//  Created by 胡翔 on 2016/12/7.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBNaviMenuView.h"

@interface  HBNaviMenuView()

/**
 目的地标签
 */
@property (nonatomic, strong) UILabel *lblDestination;

/**
 地址标签
 */
@property (nonatomic, strong) UILabel *lblAdress;

/**
 距离标签
 */
@property (nonatomic, strong) UILabel *lblDistance;

/**
 时间标签
 */
@property (nonatomic, strong) UILabel *lblTime;

/**
 开始导航按钮
 */
@property (nonatomic, strong) UIButton *btnStartNavi;

@end

#pragma mark - Constant
static CGFloat const kHeightDestination = 17.f; //目的地标签高度
static CGFloat const kWidthDistance = 100.f;    //距离标签宽度
static CGFloat const kWidthButton = 200.f;      //按钮宽度
static CGFloat const kHeightButton = 20.f;      //按钮高度
static CGFloat const kHeightDistance = 14.f;    //距离标签高度
static CGFloat const kInsetsNormal = 10.f;       //上下边距
static CGFloat const kInsetsLeft = 15.f;        //左右边距

@implementation HBNaviMenuView
#pragma mark - Initialize
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = HB_COLOR_DARKBLUE;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.lblDestination = [[UILabel alloc] init];
    self.lblDestination.textAlignment = NSTextAlignmentCenter;
    self.lblDestination.font = HB_FONT_MEDIUM_SIZE(17);
    self.lblDestination.textColor = [UIColor whiteColor];
    [self addSubview:self.lblDestination];
    
    self.lblDistance = [[UILabel alloc] init];
    self.lblDistance.textAlignment = NSTextAlignmentLeft;
    self.lblDistance.font = HB_FONT_LIGHT_SIZE(14);
    self.lblDistance.textColor = [UIColor whiteColor];
    [self addSubview:self.lblDistance];
    
    self.lblAdress = [[UILabel alloc] init];
    self.lblAdress.textAlignment = NSTextAlignmentLeft;
    self.lblAdress.font = HB_FONT_LIGHT_SIZE(14);
    self.lblAdress.textColor = [UIColor whiteColor];
    [self addSubview:self.lblAdress];
    
    self.lblTime = [[UILabel alloc] init];
    self.lblTime.textAlignment = NSTextAlignmentRight;
    self.lblTime.font = HB_FONT_LIGHT_SIZE(14);
    self.lblTime.textColor = [UIColor whiteColor];
    [self addSubview:self.lblTime];
    
    self.btnStartNavi = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.btnStartNavi];
    //约束
    [self makeConstraints];
}

- (void)makeConstraints {
    @WEAKSELF;
    [self.lblDestination mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(kInsetsNormal);
        make.left.equalTo(weakSelf.mas_left).with.offset(kInsetsLeft);
        make.right.equalTo(weakSelf.mas_right).with.offset(-kInsetsLeft);
        make.height.mas_equalTo(kHeightDestination);
    }];
    
    [self.lblAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.lblDestination);
        make.height.mas_equalTo(kHeightDistance);
        make.top.equalTo(weakSelf.lblDestination.mas_bottom).with.offset(kInsetsNormal);
    }];
    
    [self.lblDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblDestination);
        make.right.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(kHeightDistance);
        make.top.equalTo(weakSelf.lblAdress.mas_bottom).with.offset(kInsetsNormal);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.height.equalTo(weakSelf.lblDistance);
        make.right.equalTo(weakSelf.lblDestination);
    }];
    
    [self.btnStartNavi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(kWidthButton);
        make.height.mas_equalTo(kHeightButton);
        make.top.equalTo(weakSelf.lblTime.mas_bottom).with.offset(kInsetsLeft);
    }];
}

#pragma mark - Setter

- (void)setRoute:(AMapNaviRoute *)route {
    _route = route;
    self.lblDistance.text = [NSString stringWithFormat:@"距离：%ld米",(long)_route.routeLength];
    self.lblTime.text = [NSString stringWithFormat:@"需要：%ld秒",(long)_route.routeTime];
}

- (void)setStation:(HBBicycleStationModel *)station {
    _station = station;
    self.lblDestination.text = _station.name;
    self.lblAdress.text = _station.address;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
