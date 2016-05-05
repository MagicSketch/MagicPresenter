//
//  TimedEvent.h
//  MagicSketch
//
//  Created by James Tang on 29/1/2016.
//
//

#import <Foundation/Foundation.h>

@interface TimedEvent : NSObject

@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSDictionary *properties;
@property (readonly, nonatomic) CFTimeInterval sessionLength;

+ (instancetype)timedEventWithName:(NSString *)name properties:(NSDictionary *)properties sessionLength:(CFTimeInterval)sessionLength;

@end


@interface MutableTimedEvent : TimedEvent

@property (nonatomic) CFTimeInterval lastStartTime;

- (void)appendProperties:(NSDictionary *)properties;
- (void)incrementProperty:(NSString *)property;
- (void)incrementProperty:(NSString *)property by:(NSNumber *)amount;
- (void)appendSessionLength:(CFTimeInterval)sessionLength;

@end