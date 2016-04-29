//
//  SegmentIOTrackerTests.m
//  MagicPresenter
//
//  Created by James Tang on 28/4/2016.
//  Copyright © 2016 MagicSketch. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SegmentIOTracker.h"

@interface SegmentIOTrackerTests : XCTestCase

@property (nonatomic, strong) SegmentIOTracker *tracker;
@property (nonatomic, strong) NSMutableURLRequest *trackingRequest;
@property (nonatomic, strong) NSDictionary *body;

@end

@implementation SegmentIOTrackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.


    _trackingRequest = [SegmentIOTracker trackingRequestWithEvent:@"test"
                                                         writeKey:@"abc123"
                                                           userID:@"james"
                                                       properties:@{
                                                                    @"event": @"unit testing",
                                                                    }];
    _body = [SegmentIOTracker bodyForRequest:_trackingRequest];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasicAuthValue {
    NSString *value = [SegmentIOTracker basicAuthValueForUsername:@"abc123" password:nil];
    XCTAssertEqualObjects(value, @"YWJjMTIzOg==");
}

- (void)testContentType {
    XCTAssertEqualObjects(_trackingRequest.allHTTPHeaderFields[@"Content-Type"], @"application/json");
}

- (void)testAcceptEncoding {
    XCTAssertEqualObjects(_trackingRequest.allHTTPHeaderFields[@"Accept-Encoding"], @"gzip");
}

- (void)testAuthorization {
    XCTAssertEqualObjects(_trackingRequest.allHTTPHeaderFields[@"Authorization"], @"Basic YWJjMTIzOg==");
}

- (void)testURL {
    XCTAssertEqualObjects(_trackingRequest.URL.absoluteString, @"https://api.segment.io/v1/track");
}

- (void)testMethod {
    XCTAssertEqualObjects(_trackingRequest.HTTPMethod, @"POST");
}

- (void)testBody {
    NSError *error;
    NSDictionary *expected = [NSJSONSerialization JSONObjectWithData:_trackingRequest.HTTPBody
                                                               options:0
                                                                 error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(_body, expected);
}

- (void)testBodyGeneral {
    NSDictionary *body = _body;
    XCTAssertEqualObjects(body[@"userId"], @"james");
    XCTAssertEqualObjects(body[@"properties"], @{@"event": @"unit testing"});
    XCTAssertEqualObjects(body[@"event"], @"test");
    XCTAssertEqual([[body allKeys] count], 3);
}

- (void)testSendTracking {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Should Callback"];
    [SegmentIOTracker sendRequest:_trackingRequest
                      completion:^(NSDictionary *response, NSError *error) {
                          XCTAssertEqualObjects(response, @{ @"success":@YES });
                          [expectation fulfill];
                      }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

// Make sure segment logged this events
// https://segment.com/docs/spec/common/
// https://github.com/segmentio/analytics-ios/blob/2901a369dce826cd7404af95437e3f0f42e96588/Pod/Classes/Internal/SEGSegmentIntegration.m

- (void)testApp {
    XCTAssertNotNil([_body valueForKeyPath:@"context.app"]);
    NSString *version = @"1.0";
    NSString *build = @"1";
    XCTAssertEqualObjects([_body valueForKeyPath:@"context.app.version"], version);
    XCTAssertEqualObjects([_body valueForKeyPath:@"context.app.build"], build);
    XCTAssertEqualObjects([[_body valueForKeyPath:@"context.app.name"] isKindOfClass:[NSString class]]);
}

- (void)testDevice {
    XCTAssertNotNil([_body valueForKeyPath:@"context.device"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.device.id"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.device.type"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.device.name"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.device.modal"] isKindOfClass:[NSString class]]);
}

- (void)testIP {
    XCTAssertTrue([[_body valueForKeyPath:@"context.ip"] isKindOfClass:[NSString class]]);
}

- (void)testLibrary {
    XCTAssertNotNil([_body valueForKeyPath:@"context.library"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.library.name"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.library.version"] isKindOfClass:[NSString class]]);
}

- (void)testLocale {
    XCTAssertTrue([[_body valueForKeyPath:@"context.locale"] isKindOfClass:[NSString class]]);
}

- (void)testLocation {
    XCTAssertNotNil([_body valueForKeyPath:@"context.location"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.location.city"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.location.country"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.location.latitude"] isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.location.longitude"] isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.location.speed"] isKindOfClass:[NSNumber class]]);
}

- (void)testNetwork {
    XCTAssertNotNil([_body valueForKeyPath:@"context.network"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.network.bluetooth"] isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.network.carrier"] isKindOfClass:[NSNumber class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.network.celluar"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.network.wifi"] isKindOfClass:[NSNumber class]]);
}

- (void)testOS {
    XCTAssertNotNil([_body valueForKeyPath:@"context.os"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.os.name"] isKindOfClass:[NSString class]]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.os.version"] isKindOfClass:[NSString class]]);
}

- (void)testReferrer {
    XCTAssertNotNil([_body valueForKeyPath:@"context.referrer"]);
    XCTAssertTrue([_body[@"context.referrer.type"] isKindOfClass:[NSString class]], @"%@ should be string", _body[@"context.referrer.type"]);
}

- (void)testScreen {
    XCTAssertNotNil([_body valueForKeyPath:@"context.screen"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.screen.width"] isKindOfClass:[NSNumber class]], @"%@ must be number", [_body valueForKeyPath:@"context.screen.width"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.screen.height"] isKindOfClass:[NSNumber class]], @"%@ must be number", [_body valueForKeyPath:@"context.screen.height"]);
    XCTAssertTrue([[_body valueForKeyPath:@"context.screen.density"] isKindOfClass:[NSNumber class]], @"%@ must be number", [_body valueForKeyPath:@"context.screen.density"]);
}

- (void)testTimeZone {
    XCTAssertTrue([[_body valueForKeyPath:@"context.timezone"] isKindOfClass:[NSString class]]);
}

@end
