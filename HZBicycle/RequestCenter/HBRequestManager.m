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








#pragma mark - Requests
@implementation HBBaseRequest

-(YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}

@end
@interface HBNearBicycleRequest(){
    NSNumber *_longtitude;
    NSNumber *_latitude;
    NSNumber *_length;
}

@end
@implementation HBNearBicycleRequest

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl
{
    return kNearBicycleRequestURL;
}

- (id)requestArgument
{
    return self.requestArguments;
}

@end


#pragma mark - RequestManager
@implementation HBRequestManager

+ (void)config
{
    [self setBaseURL:kBaseRequestURL];
}

+ (instancetype)sharedManager
{
    static HBRequestManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HBRequestManager alloc] init];
    });
    return _manager;
}

#pragma mark - Public Method
+ (void)setBaseURL:(NSString *)baseURL
{
    [[YTKNetworkConfig sharedConfig] setBaseUrl:baseURL];
}

#pragma mark - SendRequest
+ (void)sendNearBicycleRequestWithLongtitude:(NSNumber *)lon
                                    latitude:(NSNumber *)la
                                      length:(NSNumber *)len
                          successJsonObject:(void (^)(NSDictionary *))success
                           failureCompletion:(YTKRequestCompletionBlock)failure
{
    HBNearBicycleRequest *nearBicycleRequest =  [[HBNearBicycleRequest alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObjectOrNil:lon forKey:@"lng"];
    [params setObjectOrNil:la forKey:@"lat"];
    [params setObjectOrNil:len forKey:@"len"];
    nearBicycleRequest.requestArguments = params;
    [nearBicycleRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData *resposneData = request.responseData;
        success([NSDictionary fh_dictionaryWithData:resposneData]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request);
    }];
}
@end
