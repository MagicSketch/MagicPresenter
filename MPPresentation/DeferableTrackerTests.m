//
//  DeferableTrackerTests.m
//  MagicSketch
//
//  Created by James Tang on 23/2/2016.
//
//

#import <XCTest/XCTest.h>

#import "DeferableTracker.h"

@interface MockDeferredTracker : DeferableTracker

@property (nonatomic) NSNumber *stateDidChangeValue;

@end

@interface DeferableTrackerTests : XCTestCase

@property (nonatomic, strong) MockDeferredTracker *tracker;

@end

@implementation MockDeferredTracker

- (void)enableStateDidChange:(BOOL)shouldEnable {
  _stateDidChangeValue = @(shouldEnable);
}

@end

@implementation DeferableTrackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

  _tracker = [MockDeferredTracker deferredTracker];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitial {
  XCTAssertFalse(_tracker.enabled);
  XCTAssertNil(_tracker.stateDidChangeValue);
}

- (void)testToggleEnabledState {
  _tracker.enabled = YES;
  XCTAssertTrue(_tracker.enabled);
  XCTAssertEqualObjects(_tracker.stateDidChangeValue, @(YES));
}

@end
