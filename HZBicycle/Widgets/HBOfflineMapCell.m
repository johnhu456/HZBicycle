//
//  HBOfflineMapCell.m
//  HZBicycle
//
//  Created by MADAO on 16/11/8.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBOfflineMapCell.h"
#import <UIColor+PKDownloadButton.h>
#import <UIImage+PKDownloadButton.h>

@interface HBOfflineMapCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@end

@implementation HBOfflineMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblTitle.font = HB_FONT_MEDIUM_SIZE(19);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置下载按钮
    self.pkDownLoadButton.tintColor = [UIColor whiteColor];
    self.pkDownLoadButton.startDownloadButton.tintColor = [UIColor whiteColor];
    self.pkDownLoadButton.stopDownloadButton.tintColor = [UIColor whiteColor];
    self.pkDownLoadButton.stopDownloadButton.radius = 15.f;
    self.pkDownLoadButton.stopDownloadButton.emptyLineWidth = 1.f;
    self.pkDownLoadButton.stopDownloadButton.filledLineWidth = 2.f;
    self.pkDownLoadButton.stopDownloadButton.filledLineStyleOuter = NO;
    
    //更改下载按钮文字
    NSAttributedString *downloadTitle = [[NSAttributedString alloc] initWithString:@"下载" attributes:@{
                                                                                              NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    [self.pkDownLoadButton.startDownloadButton setAttributedTitle:downloadTitle forState:UIControlStateNormal];
    NSAttributedString *highlitedDownloadTitle = [[NSAttributedString alloc] initWithString:@"下载" attributes:@{
                                                                                                       NSForegroundColorAttributeName : [UIColor grayColor],
                                                                                                       NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    [self.pkDownLoadButton.startDownloadButton setAttributedTitle:highlitedDownloadTitle forState:UIControlStateHighlighted];
    
    //更改下载按钮背景色
    UIImage *backImage = [UIImage buttonBackgroundWithColor:[UIColor whiteColor]];
    [self.pkDownLoadButton.startDownloadButton setBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f)]
                    forState:UIControlStateNormal];
    
    [self.pkDownLoadButton.startDownloadButton setBackgroundImage:[UIImage highlitedButtonBackgroundWithColor:[UIColor whiteColor]]
                    forState:UIControlStateHighlighted];
    
    //更改删除按钮文字
    NSAttributedString *removeTitle = [[NSAttributedString alloc] initWithString:@"删除" attributes:@{
                                                                                              NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    [self.pkDownLoadButton.downloadedButton setAttributedTitle:removeTitle forState:UIControlStateNormal];
    NSAttributedString *highlitedRemoveTitle = [[NSAttributedString alloc] initWithString:@"删除" attributes:@{
                                                                                                       NSForegroundColorAttributeName : [UIColor grayColor],
                                                                                                       NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    [self.pkDownLoadButton.downloadedButton setAttributedTitle:highlitedRemoveTitle forState:UIControlStateHighlighted];
    
    //更改删除按钮背景色
    [self.pkDownLoadButton.downloadedButton setBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(15.f, 15.f, 15.f, 15.f)]
                                                         forState:UIControlStateNormal];
    
    [self.pkDownLoadButton.downloadedButton setBackgroundImage:[UIImage highlitedButtonBackgroundWithColor:[UIColor whiteColor]]
                                                         forState:UIControlStateHighlighted];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
