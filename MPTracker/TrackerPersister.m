//
//  TrackerPersister.m
//  MagicSketch
//
//  Created by James Tang on 28/1/2016.
//
//

#import "TrackerPersister.h"

@implementation TrackerPersister

- (void)setObject:(id)object forKey:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)objectForKey:(NSString *)key {
  return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)removeObjectForKey:(id)aKey {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

