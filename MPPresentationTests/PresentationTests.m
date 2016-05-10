//
//  MPPresentationTests.m
//  MPPresentationTests
//
//  Created by James Tang on 18/4/2016.
//  Copyright © 2016 Magic Mirror. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MPPresentationTests : XCTestCase

@property (nonatomic, strong) NSBundle *pluginBundle;

@end

@implementation MPPresentationTests

- (void)setUp {
    [super setUp];

    _pluginBundle = [NSBundle bundleForClass:NSClassFromString(@"MPPresentationController")];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testVersionInSync {
    NSLog(@"project dir=%@, BUILD_ROOT_=%@", PROJECT_DIR, BUILD_ROOT);

    NSString *path = [PROJECT_DIR stringByAppendingPathComponent:@"MagicPresenter.sketchplugin/Contents/Sketch/manifest.json"];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);

    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    XCTAssertNotNil(JSON);

    XCTAssertEqualObjects(JSON[@"build"], [_pluginBundle objectForInfoDictionaryKey:@"CFBundleVersion"]);
    XCTAssertEqualObjects(JSON[@"version"], [_pluginBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
}

@end
