//
//  HBAboutBicycleViewController.m
//  HZBicycle
//
//  Created by MADAO on 16/11/18.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBAboutBicycleViewController.h"

@interface HBAboutBicycleViewController ()

@end

//图标宽度
static CGFloat const kIconWidth = 70.f;

//图标上边距
static CGFloat const kInsets = 100.f;

@implementation HBAboutBicycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于PBicycles";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {
    @WEAKSELF;
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = ImageInName(@"main_appicon");
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.height.mas_equalTo(@(kInsets));
        make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).with.offset(kIconWidth);
    }];
    
    @WEAK_OBJ(iconView);
    
    UILabel *buildLabel = [[UILabel alloc] init];
    buildLabel.font = HB_FONT_MEDIUM_SIZE(19);
    buildLabel.textColor = HB_COLOR_DARKBLUE;
    buildLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:buildLabel];
    [buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(@19);
        make.top.equalTo(iconViewWeak.mas_bottom).with.offset(20);
    }];
    NSString *info = [NSString stringWithFormat:@"(Version:%@  Build:%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    buildLabel.text = info;
    
    @WEAK_OBJ(buildLabel);
    UITextView *introduce = [[UITextView alloc] init];
    introduce.font = HB_FONT_MEDIUM_SIZE(14);
    introduce.textColor = HB_COLOR_DARKBLUE;
    introduce.textAlignment = NSTextAlignmentLeft;
    introduce.text = [self getIntroduce];
    [self.view addSubview:introduce];
    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset (20.f);
        make.right.equalTo(weakSelf.view).with.offset (-20.f);
        make.bottom.equalTo(weakSelf.view);
        make.top.equalTo(buildLabelWeak.mas_bottom).with.offset(40);
    }];
}

- (NSString *)getIntroduce {
    return @"    PBicycles是一款面向杭州公共自行车的轻量级应用，它可以帮助你寻找附近的公共自行车租赁点，包括查询可以租借和归还的数量等功能。\n    由于个人开发，功能尚且不够完善，我也会一直关注使用者的反馈并不断地改进，感谢您的信任与使用。";
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
