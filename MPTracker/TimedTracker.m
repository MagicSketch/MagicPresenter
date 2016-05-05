//
//  TimedTracker.m
//  MagicSketch
//
//  Created by James Tang on 29/1/2016.
//
//

#import "TimedTracker.h"
#import "TimedEvent.h"

@interface TimedTracker ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, MutableTimedEvent *> *events;
@property (nonatomic) CFTimeInterval delay;

@end

@implementation TimedTracker

- (instancetype)init
{
  self = [super init];
  if (self) {
    _events = [[NSMutableDictionary alloc] init];
//    _increments = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (NSDictionary *)timedEvents {
  return [_events copy];
}

- (void)start:(NSString *)event {
  [self start:event sinceTime:CACurrentMediaTime()];
}

- (void)start:(NSString *)eventName sinceTime:(CFTimeInterval)timeInterval {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(flushEvent:) object:eventName];

  MutableTimedEvent *event = [_events objectForKey:eventName];
  if ( ! event) {
    event = [MutableTimedEvent timedEventWithName:eventName
                                       properties:@{}
                                    sessionLength:0];
    [_events setObject:event forKey:eventName];
  }
  event.lastStartTime = timeInterval;
  [_delegate timedTracker:self eventStarted:event.name];
}

- (TimedEvent *)track:(NSString *)event properties:(NSDictionary *)properties {
  return [self track:event properties:properties atTime:CACurrentMediaTime()];
}

- (TimedEvent *)track:(NSString *)event properties:(NSDictionary *)properties atTime:(CFTimeInterval)timeInterval {
  return [self track:event properties:properties
              atTime:timeInterval delay:0];
}

- (TimedEvent *)track:(NSString *)eventName properties:(NSDictionary *)properties atTime:(CFTimeInterval)timeInterval delay:(CFTimeInterval)delay {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(flushEvent:) object:eventName];

  self.delay = delay;
  MutableTimedEvent *event = [_events objectForKey:eventName];
  CFTimeInterval sinceTime = [event lastStartTime];
  CFTimeInterval sessionLength = timeInterval - sinceTime;
  [event appendSessionLength:sessionLength];
  [event appendProperties:properties];

  if (delay == 0) {
    [self flushEvent:eventName];
  } else {
    [self performSelector:@selector(flushEvent:)
               withObject:eventName
               afterDelay:delay];
  }

  // Merge info from increment dictionary
  return event;
}

- (void)flushEvent:(NSString *)eventName {
  MutableTimedEvent *event = [_events objectForKey:eventName];
  if (event) {
    [_delegate timedTracker:self eventFinished:event];
    // Should Clean Up After Tracking
    [_events removeObjectForKey:eventName];
  }
}

- (void)event:(NSString *)event increment:(NSString *)property {
  [self event:event
    increment:property
           by:@1];
}

- (void)event:(NSString *)eventName increment:(NSString *)property by:(NSNumber *)amount {
    //[_properties setObject:property forKey:event];
  MutableTimedEvent *event = [_events objectForKey:eventName];
  [event incrementProperty:property by:amount];
}

@end
