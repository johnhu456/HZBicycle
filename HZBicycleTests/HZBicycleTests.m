//
//  HZBicycleTests.m
//  HZBicycleTests
//
//  Created by MADAO on 16/10/21.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HBNaviManager.h"

@interface HZBicycleTests : XCTestCase

@property (nonatomic, strong) HBNaviManager *manager;
@end

@implementation HZBicycleTests

- (void)setUp {
    [super setUp];
    self.manager = [HBNaviManager sharedManager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [[HBNaviManager sharedManager] getRouteWithStartCoordinate:CLLocationCoordinate2DMake(30.2, 120.3) endCoordinate:CLLocationCoordinate2DMake(30.6, 120.5) naviType:HBNaviTypeRide];
    [[HBNaviManager sharedManager] setNaviType:HBNaviTypeWalk withRecalculate:YES];

    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
