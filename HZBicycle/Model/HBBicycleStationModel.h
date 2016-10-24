//
//  HBBicycleStationModel.h
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBBicycleBaseModel.h"

@interface HBBicycleStationModel : HBBicycleBaseModel

#pragma mark - Primary Property

/**站点名称*/
@property (nonatomic, copy) NSString *name;
/**编号*/
@property (nonatomic, assign) long number;
/**可借数量*/
@property (nonatomic, assign) NSUInteger rentcount;
/**可还数量*/
@property (nonatomic, assign) NSUInteger restorecount;
/**纬度*/
@property (nonatomic, assign) double lat;
/**经度*/
@property (nonatomic, assign) double lon;
/**距离*/
@property (nonatomic, assign) double len;
/**自行车总数*/
@property (nonatomic, assign) NSUInteger bikenum;

#pragma mark - Detail
/**id*/
@property (nonatomic, assign) long stationID;
/**地址*/
@property (nonatomic, copy) NSString *address;
/**区域名称*/
@property (nonatomic, copy) NSString *areaname;
/**值守类型*/
@property (nonatomic, copy) NSString *guardType;
/**可租还时间*/
@property (nonatomic, assign) NSString *serviceType;
/**排序*/
@property (nonatomic, assign) NSUInteger sort;
/**值守电话1*/
@property (nonatomic, copy) NSString *stationPhone;
/**值守电话2*/
@property (nonatomic, copy) NSString *stationPhone2;
/**服务状态*/
@property (nonatomic, copy) NSString *useflag;
/**查询时间*/
@property (nonatomic, copy) NSString *createTime;

@end

