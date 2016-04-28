//
//  Tracker.m
//  MagicSketch
//
//  Created by James Tang on 20/1/2016.
//
//

#import "TrackerManager.h"
#import "Tracker.h"
#import "Each.h"
#import "TrackerPersister.h"

NSString *const TrackerManagerEventSessionEnded = @"Session Ended";

@interface TrackerManager ()

@property (nonatomic, strong) NSMutableArray <id <Tracker>> *trackers;
@property (nonatomic, strong) id <TrackerPersister> persister;

@end

@implementation TrackerManager

static TrackerManager *_tracker;

+ (instancetype)sharedInstance {
  if ( ! _tracker) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _tracker = [[TrackerManager alloc] initWithTrackers:@[]];
    });
  }
  return _tracker;
}

- (void)setUuid:(NSString *)uuid {
  [super setUuid:uuid];
  if (_trackers) {
    [self configureChild];
  }
}

- (void)setEmail:(NSString *)email {
  [super setEmail:email];
  if (email) {
    [_persister setObject:email forKey:@"io.magicsketch.tracker.email"];
  }
  if (_trackers) {
    [self configureChild];
  }
}

- (instancetype)initWithTrackers:(NSArray <id <Tracker>> *)trackers {
  TrackerPersister *persister = [[TrackerPersister alloc] init];
  self = [self initWithTrackers:trackers persister:persister];
  if (self) {
  }
  return self;
}

- (instancetype)initWithTrackers:(NSArray <id <Tracker>> *)trackers persister:(id<TrackerPersister>)persister {
  self = [super init];
  if (self) {
    _persister = persister;

    NSString *uuid = [persister objectForKey:@"io.magicsketch.tracker.uuid"];
    if ( ! uuid) {
      uuid = [[NSUUID UUID] UUIDString];
      [persister setObject:uuid forKey:@"io.magicsketch.tracker.uuid"];
    }
    self.uuid = uuid;

    NSString *email = [persister objectForKey:@"io.magicsketch.tracker.email"];
    self.email = email;

    _trackers = [NSMutableArray array];
    [_trackers addObjectsFromArray:trackers];
    [self configureChild];
  }
  return self;
}

- (void)setAsSharedInstance {
  if (_tracker != self) {
    _tracker = self;
  }
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties {
  [[_trackers each] track:event
               properties:properties];
}

- (NSArray<id<Tracker>> *)allTrackers {
  return [_trackers copy];
}

- (void)configureChild {
  if ([_trackers count]) {
    [[_trackers each] setUuid:self.uuid];
    [[_trackers each] setEmail:self.email];
  }
}

- (void)timedTracker:(TimedTracker *)tracker eventStarted:(NSString *)event {
  [[_trackers each] timedTracker:tracker
                    eventStarted:event];
}

- (void)timedTracker:(TimedTracker *)tracker eventFinished:(TimedEvent *)event {
  [[_trackers each] timedTracker:tracker
                   eventFinished:event];
}

- (void)setSuperProperties:(NSDictionary *)properties {
  [[_trackers each] setSuperProperties:properties];
}

@end

