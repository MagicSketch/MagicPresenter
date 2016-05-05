//
//  DeferableTracker.h
//  MagicSketch
//
//  Created by James Tang on 20/2/2016.
//
//

#import "Tracker.h"

@interface DeferableTracker : Tracker

@property (nonatomic) BOOL enabled;

- (void)enableStateDidChange:(BOOL)shouldEnable;  // Override in subclass

+ (instancetype)deferredTracker;

@end
