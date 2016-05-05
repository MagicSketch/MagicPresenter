//
//  CounterTracker.h
//  MagicSketch
//
//  Created by James Tang on 21/1/2016.
//
//

#import <Foundation/Foundation.h>
#import "Tracker.h"

@class Event;

@interface CounterTracker : Tracker

@property (nonatomic, readonly) NSUInteger tracksCount;
@property (nonatomic, readonly) NSUInteger timesStarted;
@property (nonatomic, readonly) NSUInteger timesFinished;

- (nonnull NSArray <Event *> *)events;

@end

