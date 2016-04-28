//
//  NSMutableArrayShuffleTests.m
//  MagicSketch
//
//  Created by James Tang on 19/2/2016.
//
//

#import <XCTest/XCTest.h>
#import "NSMutableArray+Shuffle.h"

@interface NSMutableArrayShuffleTests : XCTestCase

@end

@implementation NSMutableArrayShuffleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIdentical {
  NSArray *array = @[@1, @2, @3, @4, @5];
  NSArray *array2 = @[@1, @2, @3, @4, @5];
  XCTAssertEqual(array2.count, array.count);
  XCTAssertEqualObjects(array, array2);
}

- (void)testShuffle {
  NSArray *array = @[@1, @2, @3, @4, @5];
  NSArray *array2 = [[[array mutableCopy] shuffle] copy];
  NSArray *array3 = [[[array mutableCopy] shuffle] copy];
  XCTAssertEqual(array2.count, array.count);
  XCTAssertEqual(array3.count, array.count);
  XCTAssertNotEqualObjects(array2, array);
  XCTAssertNotEqualObjects(array3, array2);
}

@end
