//
//  MockedTracker.h
//  MagicSketch
//
//  Created by James Tang on 31/1/2016.
//
//

#import <Foundation/Foundation.h>
#import "TimedTracker.h"
#import "Tracker.h"

@interface MockedTracker : Tracker <TimedTrackerDelegate>

@property (nonatomic, copy, readonly) NSString *startedEvent;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSDictionary *properties;
@property (nonatomic, readonly) CFTimeInterval sessionLength;

@end