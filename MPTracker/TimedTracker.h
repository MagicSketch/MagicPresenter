//
//  TimedTracker.h
//  MagicSketch
//
//  Created by James Tang on 29/1/2016.
//
//

#import <Foundation/Foundation.h>
#import "TimedTrackerDelegate.h"

@interface TimedTracker : NSObject

@property (nonatomic, strong, readonly) NSDictionary <NSString *, NSNumber *> *timedEvents;
@property (nonatomic, weak) id <TimedTrackerDelegate> delegate;

- (void)start:(NSString *)event;
- (void)event:(NSString *)event increment:(NSString *)property;   // increment by 1
- (void)event:(NSString *)event increment:(NSString *)property by:(NSNumber *)amount;
- (TimedEvent *)track:(NSString *)event properties:(NSDictionary *)properties;
- (void)start:(NSString *)event sinceTime:(CFTimeInterval)timeInterval;
- (TimedEvent *)track:(NSString *)event properties:(NSDictionary *)properties atTime:(CFTimeInterval)timeInterval;
- (TimedEvent *)track:(NSString *)event properties:(NSDictionary *)properties atTime:(CFTimeInterval)timeInterval delay:(CFTimeInterval)delay;
- (void)flushEvent:(NSString *)event;

@end
