//
//  TimedEventTests.m
//  MagicSketch
//
//  Created by James Tang on 1/2/2016.
//
//

#import <XCTest/XCTest.h>
#import "TimedEvent.h"

@interface TimedEventTests : XCTestCase

@property (nonnull, nonatomic, strong) MutableTimedEvent *event;

@end

@implementation TimedEventTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

  _event = [MutableTimedEvent timedEventWithName:@"App Launch"
                                      properties:@{
                                                   @"country":@"Hong Kong",
                                                   @"population": @1000,
                                                   }
                                   sessionLength:10];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitial {
  XCTAssertEqualObjects(_event.name, @"App Launch");
  XCTAssertEqualObjects(_event.properties[@"country"], @"Hong Kong", @"Old key should retained");
  XCTAssertEqualObjects(_event.properties[@"population"], @1000, @"Old key should retained");
  XCTAssertEqual(_event.sessionLength, 10);
}

- (void)testAddingProperties {
  [_event appendProperties:@{
                             @"city": @"Causeway Bay",
                             @"population": @2000,
                             }];
  XCTAssertEqualObjects(_event.properties[@"country"], @"Hong Kong", @"Old key should be retained");
  XCTAssertEqualObjects(_event.properties[@"city"], @"Causeway Bay", @"New key should be added");
  XCTAssertEqualObjects(_event.properties[@"population"], @2000, @"Existing key should be updated");

}

- (void)testIncrementingProperty {
  [_event incrementProperty:@"population"];
  [_event incrementProperty:@"area"];
  XCTAssertEqualObjects(_event.properties[@"population"], @1001);
  XCTAssertEqualObjects(_event.properties[@"area"], @1, @"New key should be added");
}

- (void)testIncrementBy {
  [_event incrementProperty:@"population" by:@500];
  [_event incrementProperty:@"area" by:@100];
  XCTAssertEqualObjects(_event.properties[@"population"], @1500);
  XCTAssertEqualObjects(_event.properties[@"area"], @100, @"New key should be added");
}

- (void)testAppendSessionLength {
  [_event appendSessionLength:10];
  XCTAssertEqual(_event.sessionLength, 20);
}

@end
