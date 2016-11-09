//
//  HBOfflineMapCell.h
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKDownloadButton.h"

@interface HBOfflineMapCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PKStopDownloadButton *downLoadButton;

@property (weak, nonatomic) IBOutlet PKDownloadButton *pkDownLoadButton;

@end
