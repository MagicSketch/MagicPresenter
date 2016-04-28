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

@end

@implementation SegmentIOTrackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.


    _trackingRequest = [SegmentIOTracker trackingRequestWithWriteKey:@"abc123"
                                                              userID:@"james"
                                                          properties:@{
                                                                       @"event": @"unit testing",
                                                                       }];

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
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:_trackingRequest.HTTPBody
                                                               options:0
                                                                 error:&error];
    XCTAssertNil(error);
    XCTAssertEqualObjects(dictionary[@"userId"], @"james");
    XCTAssertEqualObjects(dictionary[@"properties"], @{@"event": @"unit testing"});
    XCTAssertEqual([[dictionary allKeys] count], 2);
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

@end
