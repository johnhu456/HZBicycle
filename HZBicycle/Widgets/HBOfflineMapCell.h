//
//  HBOfflineMapCell.h
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PKDownloadButton.h>

@interface HBOfflineMapCell : UITableViewCell

/**
 下载按钮
 */
@property (weak, nonatomic) IBOutlet PKDownloadButton *pkDownLoadButton;

/**
 城市名称标签
 */
@property (weak, nonatomic) IBOutlet UILabel *lblCity;

/**
 离线包大小
 */
@property (weak, nonatomic) IBOutlet UILabel *lblSize;

@end
