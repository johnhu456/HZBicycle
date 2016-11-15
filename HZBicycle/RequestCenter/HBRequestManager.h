//
//  HBRequestManager.h
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork.h>

#pragma mark - Requests
@interface HBBaseRequest : YTKRequest

@property (nonatomic, strong) NSDictionary *requestArguments;

@end

/**位置附近的自行车*/
@interface HBNearBicycleRequest : HBBaseRequest

@end

/**
 搜索自行车站点
 */
@interface HBBicycleSearchReqeust : HBBaseRequest

@end

#pragma mark - ReqeustManager
@interface HBRequestManager : NSObject

+ (void)config;

+ (void)setBaseURL:(NSString *)baseURL;

#pragma mark - SendRequest


/**
 查询附近的自行车

 @param lat     纬度
 @param lon     经度
 @param len     范围
 @param success 成功回调，内容为字典
 @param failure 失败回调
 */
+ (void)sendNearBicycleRequestWithLatitude:(NSNumber *)lat
                                    longtitude:(NSNumber *)lon
                                      length:(NSNumber *)len
                           successJsonObject:(void(^)(NSDictionary *jsonDict))success
                           failureCompletion:(YTKRequestCompletionBlock)failure;


/**
 搜索地址或者编号

 @param option 搜索关键字
 */
+ (void)sendSearchBicycleStationRequestWithOptions:(NSString *)option
                                 successJsonObject:(void(^)(NSDictionary *jsonDict))success
                                 failureCompletion:(YTKRequestCompletionBlock)failure;
@end
