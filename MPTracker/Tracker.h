//
//  Tracker.h
//  MagicSketch
//
//  Created by James Tang on 21/1/2016.
//
//

#import <Foundation/Foundation.h>
#import "TimedEvent.h"
#import "TimedTracker.h"
#import "TimedTrackerDelegate.h"

typedef void(^TrackerUploadCompletionHandler)();

@protocol Tracker <NSObject, TimedTrackerDelegate>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *email;

- (void)track:(NSString *)event properties:(NSDictionary *)properties;
- (void)setSuperProperties:(NSDictionary *)properties;

@end



@interface Tracker : NSObject <Tracker>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *email;

// These methods should not be subclassed
- (void)event:(NSString *)event increment:(NSString *)property;
- (void)timedTrack:(NSString *)event;
- (void)timedFlush:(NSString *)event;
- (void)timedFinish:(NSString *)event properties:(NSDictionary *)properties;
- (void)timedFinish:(NSString *)event properties:(NSDictionary *)properties mergeFutureEventsWithinTimeInterval:(CFTimeInterval)delay;

@end