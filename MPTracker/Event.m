//
//  Event.m
//  MagicSketch
//
//  Created by James Tang on 22/1/2016.
//
//

#import "Event.h"

@implementation Event

+ (instancetype)eventWithName:(NSString *)name properties:(NSDictionary *)properties {
  Event *event = [[self alloc] init];
  event.name = name;
  event.properties = properties;
  return event;
}

- (BOOL)isEqual:(id)object {
  BOOL equalName = [[object name] isEqual:self.name];
  BOOL equalProperties = [[object properties] isEqual:self.properties];
  if (equalName && equalProperties) {
    return YES;
  }
  return [super isEqual:object];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<Event: %@, %@>", self.name, self.properties];
}

@end
