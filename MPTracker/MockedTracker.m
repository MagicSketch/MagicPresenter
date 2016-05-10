//
//  MockedTracker.m
//  MagicSketch
//
//  Created by James Tang on 31/1/2016.
//
//

#import "MockedTracker.h"
#import "TimedEvent.h"

@interface MockedTracker ()

@property (nonatomic, copy) NSString *startedEvent;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *properties;
@property (nonatomic, strong) NSMutableDictionary *globalProperties;
@property (nonatomic) CFTimeInterval sessionLength;

@end

@implementation MockedTracker

- (instancetype)init
{
  self = [super init];
  if (self) {
    _globalProperties = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)timedTracker:(TimedTracker *)tracker eventStarted:(NSString *)event {
  self.startedEvent = event;
}

- (void)timedTracker:(TimedTracker *)tracker eventFinished:(TimedEvent *)event {
  self.name = event.name;
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  [dict addEntriesFromDictionary:_globalProperties];
  [dict addEntriesFromDictionary:event.properties];
  self.properties = dict;
  self.sessionLength = event.sessionLength;
}

- (void)setSuperProperties:(NSDictionary *)properties {
  [_globalProperties addEntriesFromDictionary:properties];
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
  self.name = event;
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  [dict addEntriesFromDictionary:_globalProperties];
  [dict addEntriesFromDictionary:properties];
  self.properties = dict;
}

@end
