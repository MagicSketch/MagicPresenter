//
//  TimedTrackerDelegaet.h
//  MagicSketch
//
//  Created by James Tang on 29/1/2016.
//
//

#import <Foundation/Foundation.h>

@class TimedTracker;
@class TimedEvent;

@protocol TimedTrackerDelegate <NSObject>

- (void)timedTracker:(TimedTracker *)tracker eventStarted:(NSString *)event;
- (void)timedTracker:(TimedTracker *)tracker eventFinished:(TimedEvent *)event;

@end