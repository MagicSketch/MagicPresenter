//
//  Tracker.m
//  MagicSketch
//
//  Created by James Tang on 28/1/2016.
//
//

#import <Foundation/Foundation.h>
#import "Tracker.h"
#import "TimedTracker.h"

@interface Tracker ()
@property (nonnull, nonatomic, strong) TimedTracker *timed;
@end

@implementation Tracker

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.timed = [[TimedTracker alloc] init];
    self.timed.delegate = self;
  }
  return self;
}

- (void)event:(NSString *)event increment:(NSString *)property {
  [self.timed event:event increment:property];
}

- (void)timedTrack:(NSString *)event {
  [self.timed start:event];
}

- (void)timedFinish:(NSString *)event properties:(NSDictionary *)properties {
  [self timedFinish:event properties:properties mergeFutureEventsWithinTimeInterval:0];
}

- (void)timedFinish:(NSString *)event properties:(NSDictionary *)properties mergeFutureEventsWithinTimeInterval:(CFTimeInterval)delay {
  [self.timed track:event properties:properties atTime:CACurrentMediaTime() delay:delay];
}

- (void)timedFlush:(NSString *)event {
  [self.timed flushEvent:event];
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
  // implement in subclass
}

- (void)timedTracker:(TimedTracker *)tracker eventStarted:(NSString *)event {
  // implement in subclass
}

- (void)timedTracker:(TimedTracker *)tracker eventFinished:(TimedEvent *)event {
  // implement in subclass
}

- (void)setSuperProperties:(NSDictionary *)properties {
  // implement in subclass
}

@end
