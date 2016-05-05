//
//  TrackerTests.m
//  MagicSketch
//
//  Created by James Tang on 20/1/2016.
//
//

#import <XCTest/XCTest.h>
#import "TrackerManager.h"
#import "CounterTracker.h"
#import "TrackerPersister.h"
#import "MockedTracker.h"

@interface TrackerTests : XCTestCase

@property (nonatomic, strong) TrackerManager *tracker;
@property (nonatomic, strong) CounterTracker *counter;
@property (nonatomic, strong) id <TrackerPersister> persister;
@property (nonatomic, strong) MockedTracker *mocked;

@end

@interface NSMutableDictionary (TrackerPersister) <TrackerPersister>

@end


@implementation TrackerTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.

  self.counter = [[CounterTracker alloc] init];
  self.mocked = [[MockedTracker alloc] init];
  self.persister = [[NSMutableDictionary alloc] init];
  self.tracker = [[TrackerManager alloc] initWithTrackers:@[_counter, _mocked] persister:_persister identifier:@"test"];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.

  [super tearDown];
}

- (void)testInitial {
  XCTAssertNotNil(self.counter);
  XCTAssertEqual([[self.tracker allTrackers] count], 2);
  XCTAssertNotNil(self.tracker.uuid);
}

- (void)testChildGetsCalledForTrackingEvents {
  XCTAssertEqual(self.counter.tracksCount, 0);
  [self.tracker track:@"document"
           properties:@{
                        @"pages":@1,
                        @"name":@"test",
                        }];
  XCTAssertEqual(self.counter.tracksCount, 1);
}

- (void)testChildGetsCalledForTimedEvents {
  XCTAssertEqual(_counter.timesStarted, 0);
  XCTAssertEqual(_counter.timesFinished, 0);
  [self.tracker timedTrack:@"Image Upload"];
  XCTAssertEqual(_counter.timesStarted, 1);
  [self.tracker timedFinish:@"Image Upload" properties:nil];
  XCTAssertEqual(_counter.timesFinished, 1);
}

- (void)testUUIDHasPersistedAcrossPersister {
  TrackerManager *another = [[TrackerManager alloc] initWithTrackers:nil persister:self.persister identifier:@"test"];
  XCTAssertEqualObjects(another.uuid, self.tracker.uuid);
}

- (void)testUUIDHasPersisted {
  TrackerManager *first = [[TrackerManager alloc] initWithTrackers:nil identifier:@"test"];
  XCTAssertNotNil(first.uuid);
  TrackerManager *second = [[TrackerManager alloc] initWithTrackers:nil identifier:@"test"];
  XCTAssertEqualObjects(second.uuid, first.uuid);
}

- (void)testChildGetsUUIDWhenAddedToManager {
  XCTAssertEqualObjects(self.counter.uuid, self.tracker.uuid);
}

- (void)testChildGetsIncrementalTracked {
  [self.tracker timedTrack:@"App Launch"];
  [self.tracker event:@"App Launch" increment:@"Image Download"];
  [self.tracker timedFinish:@"App Launch" properties:@{}];
  XCTAssertEqualObjects(_mocked.properties, @{ @"Image Download":@1 });
  XCTAssertEqualObjects(_mocked.properties[@"Image Download"], @1);
}

- (void)testSuperProperties {
  [self.tracker setSuperProperties:@{
                                     @"support_id":@"12345"
                                     }];
  [self.tracker track:@"App Launch" properties:@{}];
  XCTAssertNotNil(self.mocked.properties);
  XCTAssertEqualObjects(self.mocked.properties[@"support_id"], @"12345");
}

@end
