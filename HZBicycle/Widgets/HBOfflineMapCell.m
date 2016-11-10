//
//  HBOfflineMapCell.m
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBOfflineMapCell.h"


@implementation HBOfflineMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pkDownLoadButton.tintColor = [UIColor whiteColor];
    self.pkDownLoadButton.stopDownloadButton.tintColor = [UIColor whiteColor];
    self.pkDownLoadButton.startDownloadButton.tintColor = [UIColor whiteColor];
    [self.pkDownLoadButton.startDownloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.pkDownLoadButton.startDownloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pkDownLoadButton.stopDownloadButton.radius = 15.f;
    self.pkDownLoadButton.stopDownloadButton.emptyLineWidth = 1.f;
    self.pkDownLoadButton.stopDownloadButton.filledLineWidth = 2.f;
    self.pkDownLoadButton.stopDownloadButton.filledLineStyleOuter = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
