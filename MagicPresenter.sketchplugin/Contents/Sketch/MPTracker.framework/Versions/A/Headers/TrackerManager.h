//
//  Tracker.h
//  MagicSketch
//
//  Created by James Tang on 20/1/2016.
//
//

#import <Foundation/Foundation.h>
#import "Tracker.h"

extern NSString *const TrackerManagerEventSessionEnded;

@protocol TrackerPersister;
@class TimedEvent;

@interface TrackerManager : Tracker

@property (nonatomic, strong, readonly) id <TrackerPersister> persister; // Default is TrackerPersister

+ (instancetype)sharedInstance;
- (instancetype)initWithTrackers:(NSArray <id <Tracker>> *)trackers persister:(id <TrackerPersister>)persister identifier:(NSString *)identifier;
- (instancetype)initWithTrackers:(NSArray <id <Tracker>> *)trackers identifier:(NSString *)identifier;
- (void)setAsSharedInstance;
- (NSArray <id <Tracker>> *)allTrackers;

@end

