//
//  HBRequestManager.m
//  HZBicycle
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBRequestManager.h"

#pragma mark - RequestURL
static NSString *const kBaseRequestURL = @"http://c.ggzxc.com.cn/wz";
static NSString *const kNearBicycleRequestURL = @"np_getBikesByWeiXin.do";
static NSString *const kBicycleSearchURL = @"np_findNetPointByName.do";

#pragma mark - Requests
@implementation HBBaseRequest

-(YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (id)requestArgument {
    return self.requestArguments;
}

@end

@implementation HBNearBicycleRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return kNearBicycleRequestURL;
}

@end

@implementation HBBicycleSearchReqeust
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return kBicycleSearchURL;
}

@end


#pragma mark - RequestManager
@implementation HBRequestManager

+ (void)config {
    [self setBaseURL:kBaseRequestURL];
}

+ (instancetype)sharedManager {
    static HBRequestManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HBRequestManager alloc] init];
    });
    return _manager;
}

#pragma mark - Public Method
+ (void)setBaseURL:(NSString *)baseURL {
    [[YTKNetworkConfig sharedConfig] setBaseUrl:baseURL];
}

#pragma mark - SendRequest
+ (void)sendNearBicycleRequestWithLatitude:(NSNumber *)lat
                                longtitude:(NSNumber *)lon
                                    length:(NSNumber *)len
                         successJsonObject:(void (^)(NSDictionary *))success
                         failureCompletion:(YTKRequestCompletionBlock)failure {
    HBNearBicycleRequest *nearBicycleRequest =  [[HBNearBicycleRequest alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObjectOrNil:lon forKey:@"lng"];
    [params setObjectOrNil:lat forKey:@"lat"];
    [params setObjectOrNil:len forKey:@"len"];
    nearBicycleRequest.requestArguments = params;
    [nearBicycleRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData *resposneData = request.responseData;
        success([NSDictionary fh_dictionaryWithData:resposneData]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
}

+ (void)sendSearchBicycleStationRequestWithOptions:(NSString *)option
                                 successJsonObject:(void(^)(NSDictionary *jsonDict))success
                                 failureCompletion:(YTKRequestCompletionBlock)failure {
    HBBicycleSearchReqeust *searchRequest = [[HBBicycleSearchReqeust alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObjectOrNil:option forKey:@"option"];
    searchRequest.requestArguments = params;
    [searchRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData *resposneData = request.responseData;
        success([NSDictionary fh_dictionaryWithData:resposneData]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
}
@end
