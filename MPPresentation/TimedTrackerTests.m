//
//  TimedTrackerTests.m
//  MagicSketch
//
//  Created by James Tang on 29/1/2016.
//
//

#import <XCTest/XCTest.h>
#import "TimedTracker.h"
#import "TimedEvent.h"
#import "CounterTracker.h"
#import "MockedTracker.h"


@interface TimedTrackerTests : XCTestCase

@property (nonatomic, strong) TimedTracker *tracker;
@property (nonatomic, strong) MockedTracker *delegate;

@end


@implementation TimedTrackerTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.

  _tracker = [[TimedTracker alloc] init];
  _delegate = [[MockedTracker alloc] init];
  _tracker.delegate = _delegate;
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInitialPropertyGetsConfigured {
  XCTAssertNotNil(_tracker.timedEvents);
  XCTAssertNotNil(_tracker.delegate);
}

- (void)testDelegateGetsCalledInTimedEvent {
  [_tracker start:@"Image Upload"];
  XCTAssertEqualObjects(_delegate.startedEvent, @"Image Upload");
}

- (void)testPropertyHasBeenConfigureCorrectlyWhenLoggingTimedEvent {
  [_tracker start:@"Image Upload" sinceTime:3];
  [_tracker track:@"Image Upload" properties:@{ @"size":@1000 } atTime:13];
  XCTAssertEqual(_delegate.sessionLength, 10);
  XCTAssertEqualObjects(_delegate.name, @"Image Upload");
  XCTAssertEqualObjects(_delegate.startedEvent, @"Image Upload");
  XCTAssertEqualObjects(_delegate.properties[@"size"], @1000);
}

- (void)testSingleEventCorrectlyTimed {
  [_tracker start:@"Image Upload" sinceTime:0];
  TimedEvent *event = [_tracker track:@"Image Upload" properties:nil atTime:10];
  XCTAssertEqual(event.sessionLength, 10);
}

- (void)testIfMultipleEventsAreCorrectlyTimed {
  [_tracker start:@"App Launch" sinceTime:0];
  [_tracker start:@"Image Upload" sinceTime:10];
  TimedEvent *imageUploadEvent = [_tracker track:@"Image Upload" properties:nil atTime:11];
  TimedEvent *appSessionEvent = [_tracker track:@"App Launch" properties:@{@"dummy":@1} atTime:20];
  XCTAssertEqual(imageUploadEvent.sessionLength, 1);
  XCTAssertEqual(appSessionEvent.sessionLength, 20);
}

- (void)testAutoResumeCorrectlyTimed {
  [_tracker start:@"App Launch" sinceTime:0];
  [_tracker track:@"App Launch" properties:@{} atTime:10 delay:10];
  [_tracker start:@"App Launch" sinceTime:15];
  TimedEvent *event = [_tracker track:@"App Launch" properties:@{} atTime:20];
  XCTAssertEqual(event.sessionLength, 15);
}

- (void)testThingsGetsCleanedUpWhenFinishedTrackingTimedEvent {
  [_tracker start:@"Image Upload"];
  [_tracker track:@"Image Upload" properties:@{ @"size":@1000 }];
  XCTAssertNil(_tracker.timedEvents[@"Image Upload"]);
}

- (void)testSingleIncrement {
    [_tracker start:@"App Launch"];
    [_tracker event:@"App Launch" increment:@"Image Upload"];
    TimedEvent *event = [_tracker track:@"App Launch" properties:nil];
    XCTAssertEqual([event.properties[@"Image Upload"] integerValue], 1);
}

- (void)testMixedIncrementWorks {
    [_tracker start:@"App Launch"];
    [_tracker event:@"App Launch" increment:@"Image Upload"];
    [_tracker event:@"App Launch" increment:@"Document Opened"];
    [_tracker event:@"App Launch" increment:@"Image Upload"];
    TimedEvent *event = [_tracker track:@"App Launch" properties:nil];
    XCTAssertEqual([event.properties[@"Image Upload"] integerValue], 2);
    XCTAssertEqual([event.properties[@"Document Opened"] integerValue], 1);
}

- (void)testCleanUpAfterIncrement {
    [_tracker start:@"App Launch"];
    [_tracker event:@"App Launch" increment:@"Image Upload"];
    TimedEvent *event = [_tracker track:@"App Launch" properties:nil];
    XCTAssertEqual([event.properties[@"Image Upload"] integerValue], 1);
    [_tracker start:@"App Launch"];
    TimedEvent *event2 = [_tracker track:@"App Launch" properties:nil];
    XCTAssertEqual([event2.properties[@"Image Upload"] integerValue], 0);
}

- (void)testIncrementBy {
  [_tracker start:@"App Launch"];
  [_tracker event:@"App Launch" increment:@"Touch Down" by:@1.2];
  TimedEvent *event = [_tracker track:@"App Launch" properties:@{}];
  XCTAssertEqual([event.properties[@"Touch Down"] floatValue], 1.2f);
}

- (void)testDelayed {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Delayed Call"];
  [_tracker start:@"Touch Down"];
  [_tracker track:@"Touch Down" properties:@{} atTime:CACurrentMediaTime() delay:1];
  XCTAssertNil(_delegate.name);
  XCTAssertNil(_delegate.properties);
    __weak __typeof (self) weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    XCTAssertEqualObjects(weakSelf.delegate.name, @"Touch Down");
    XCTAssertNotNil(weakSelf.delegate.name);
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testDelayedAndResetTimeOnInterrupt {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Delayed Call"];
  [_tracker start:@"Touch Down"];
  [_tracker track:@"Touch Down" properties:@{@"point":@"{0, 0}"} atTime:CACurrentMediaTime() delay:1];
  __weak __typeof (self) weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_tracker track:@"Touch Down" properties:@{} atTime:CACurrentMediaTime() delay:1];
    XCTAssertNil(weakSelf.delegate.name);
    XCTAssertNil(weakSelf.delegate.properties);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      XCTAssertNotNil(weakSelf.delegate.name);
      XCTAssertEqualObjects(weakSelf.delegate.name, @"Touch Down");
      XCTAssertEqualObjects(weakSelf.delegate.properties[@"point"], @"{0, 0}");
      [expectation fulfill];
    });
  });
  [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testFlushEvent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Event Should Flush Before end of delay"];
  [_tracker start:@"Touch Down"];
  [_tracker track:@"Touch Down" properties:@{@"point":@"{0, 0}"} atTime:CACurrentMediaTime() delay:1];
  __weak __typeof (self) weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    XCTAssertNil(weakSelf.delegate.name);
    XCTAssertNil(weakSelf.delegate.properties);
    [_tracker flushEvent:@"Touch Down"];
    XCTAssertNotNil(weakSelf.delegate.name);
    XCTAssertEqualObjects(weakSelf.delegate.name, @"Touch Down");
    XCTAssertEqualObjects(weakSelf.delegate.properties[@"point"], @"{0, 0}");
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

- (void)testFlushingUnrelatedEvent {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Event Should Flush Before end of delay"];
  [_tracker start:@"Touch Up"];
  [_tracker track:@"Touch Up" properties:@{
                                           @"point" : @"{50, 50}",
                                           }];
  __weak __typeof (self) weakSelf = self;
  XCTAssertEqualObjects(weakSelf.delegate.name, @"Touch Up");
  XCTAssertEqualObjects(weakSelf.delegate.properties, @{ @"point": @"{50, 50}" });
  [_tracker start:@"Touch Down"];
  [_tracker track:@"Touch Down" properties:@{@"point":@"{0, 0}"} atTime:CACurrentMediaTime() delay:1];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [_tracker flushEvent:@"Something Else"];
    XCTAssertEqualObjects(weakSelf.delegate.name, @"Touch Up");
    XCTAssertEqualObjects(weakSelf.delegate.properties, @{ @"point": @"{50, 50}" });
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) { XCTAssertNil(error); }];
}

@end
