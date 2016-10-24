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







#pragma mark - ReqeustManager
@interface HBRequestManager : NSObject

//+ (instancetype)sharedManager;

+ (void)config;

+ (void)setBaseURL:(NSString *)baseURL;

#pragma mark - SendRequest
+ (void)sendNearBicycleRequestWithLongtitude:(NSNumber *)lon
                                    latitude:(NSNumber *)la
                                      length:(NSNumber *)len
                           successJsonObject:(void(^)(NSDictionary *jsonDict))success
                           failureCompletion:(YTKRequestCompletionBlock)failure;
@end
