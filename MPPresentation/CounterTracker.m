//
//  CounterTracker.m
//  MagicSketch
//
//  Created by James Tang on 21/1/2016.
//
//

#import "CounterTracker.h"
#import "Event.h"

@interface CounterTracker ()

@property (nonatomic, strong, nonnull) NSMutableArray *storage;
@property (nonatomic) NSUInteger uploadsCount;

@end

@implementation CounterTracker

- (instancetype)init
{
  self = [super init];
  if (self) {
    _storage = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
  [_storage addObject:[Event eventWithName:event properties:properties]];
}

- (NSUInteger)tracksCount {
  return [_storage count];
}

- (NSArray <Event *> *)events {
  return [_storage copy];
}

- (void)timedTracker:(TimedTracker *)tracker eventStarted:(NSString *)event {
  _timesStarted++;
}

- (void)timedTracker:(TimedTracker *)tracker eventFinished:(TimedEvent *)event {
  _timesFinished++;
}

@end
