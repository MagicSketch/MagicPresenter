//
//  TimedEvent.m
//  MagicSketch
//
//  Created by James Tang on 29/1/2016.
//
//

#import "TimedEvent.h"

@interface TimedEvent ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *properties;
@property (nonatomic) CFTimeInterval sessionLength;

@end


@implementation TimedEvent

+ (instancetype)timedEventWithName:(NSString *)name properties:(NSDictionary *)properties sessionLength:(CFTimeInterval)sessionLength {
  TimedEvent *event = [[self alloc] init];
  event.name = name;
  event.properties = properties;
  event.sessionLength = sessionLength;
  return event;
}

@end


@implementation MutableTimedEvent

- (void)appendProperties:(NSDictionary *)properties {
  NSMutableDictionary *merged = [[NSMutableDictionary alloc] init];
  [merged addEntriesFromDictionary:self.properties ?: @{}];
  [merged addEntriesFromDictionary:properties ?: @{}];
  self.properties = [merged copy];
}

- (void)incrementProperty:(NSString *)property {
  [self incrementProperty:property by:@1];
}

- (void)incrementProperty:(NSString *)property by:(NSNumber *)amount {
  NSMutableDictionary *merged = [[NSMutableDictionary alloc] init];
  [merged addEntriesFromDictionary:self.properties ?: @{}];
  merged[property] = @([merged[property] floatValue] + [amount floatValue]);
  self.properties = [merged copy];
}

- (void)appendSessionLength:(CFTimeInterval)sessionLength {
  self.sessionLength += sessionLength;
}

@end
