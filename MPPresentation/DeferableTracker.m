//
//  DeferableTracker.m
//  MagicSketch
//
//  Created by James Tang on 20/2/2016.
//
//

#import "DeferableTracker.h"

@interface DeferableTracker ()

@end

@implementation DeferableTracker

+ (instancetype)deferredTracker {
  DeferableTracker *tracker = [[self alloc] init];
  return tracker;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _enabled = NO;
  }
  return self;
}

- (void)setEnabled:(BOOL)enabled {
  _enabled = enabled;
  [self enableStateDidChange:enabled];
}

- (void)enableStateDidChange:(BOOL)shouldEnable {
  
}

@end
